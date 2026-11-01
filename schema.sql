-- =====================================================================
-- Ruang Belajar Lovha - DRAF skema Supabase (Postgres)
-- Status: DRAF v0.1, BELUM FINAL, belum diuji. Tujuan: bahan diskusi Tahap 0.
-- Sebelum produksi: tetapkan struktur final, kebijakan akses, retensi, dan backup.
-- Semua penulisan (jawaban, skor, unggahan, hasil agent) dilakukan di sisi server
-- dengan service role, bukan dari browser, agar skor dan status QA tidak bisa dipalsukan.
-- =====================================================================

create extension if not exists pgcrypto;

-- ---------- Tipe ----------
create type app_role         as enum ('pelajar', 'pengawas');
create type label_mapel      as enum ('komponen_snbt', 'penguatan');
create type qa_status        as enum ('perlu_verifikasi', 'lolos', 'revisi');
create type format_soal      as enum ('pilihan_ganda', 'esai', 'isian');
create type mode_percobaan   as enum ('latihan', 'simulasi');
create type status_agent     as enum ('aktif', 'nonaktif_sementara', 'nonaktif');
create type status_tugas     as enum ('antre', 'berjalan', 'selesai', 'gagal', 'dibatalkan');
create type status_persetujuan as enum ('menunggu', 'disetujui', 'ditolak', 'kedaluwarsa');
create type jenis_berkas     as enum ('foto', 'pdf', 'audio');
create type kecukupan_data   as enum ('belum_cukup', 'estimasi_awal', 'cukup');
create type jenis_memori     as enum ('pola_kesalahan', 'preferensi', 'riwayat');

-- ---------- Akun ----------
create table profiles (
  id                  uuid primary key references auth.users (id) on delete cascade,
  role                app_role not null default 'pelajar',
  display_name        text,
  is_minor            boolean,                 -- null = belum diketahui
  guardian_consent_at timestamptz,             -- diisi bila persetujuan orang tua/wali diperlukan
  created_at          timestamptz not null default now()
);

create or replace function is_pengawas() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from profiles where id = auth.uid() and role = 'pengawas');
$$;

-- Profil dibuat otomatis saat akun baru terdaftar. Peran selalu 'pelajar';
-- peran 'pengawas' hanya diberikan manual oleh Alvin lewat service role.
create or replace function handle_new_user() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into profiles (id, role) values (new.id, 'pelajar');
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function handle_new_user();

-- ---------- Katalog ----------
create table sumber (
  id          uuid primary key default gen_random_uuid(),
  judul       text not null,
  url         text,
  lisensi     text,
  diakses_pada date,
  diverifikasi_pada date
);

create table mapel (
  id                 uuid primary key default gen_random_uuid(),
  kode               text not null unique,
  nama               text not null,
  label              label_mapel not null,     -- komponen_snbt atau penguatan
  label_diverifikasi_pada date,
  label_sumber_id    uuid references sumber (id)
);

create table topik (
  id         uuid primary key default gen_random_uuid(),
  mapel_id   uuid not null references mapel (id) on delete cascade,
  parent_id  uuid references topik (id) on delete cascade,   -- subtopik
  nama       text not null
);

create table materi (
  id               uuid primary key default gen_random_uuid(),
  topik_id         uuid not null references topik (id) on delete cascade,
  judul            text not null,
  isi              text not null,
  sumber_id        uuid references sumber (id),
  diverifikasi_pada date,
  status_relevansi text,
  qa               qa_status not null default 'perlu_verifikasi'
);

create table soal (
  id                 uuid primary key default gen_random_uuid(),
  topik_id           uuid not null references topik (id),
  kompetensi         text,
  tingkat_kesulitan  smallint check (tingkat_kesulitan between 1 and 5),
  format             format_soal not null,
  pertanyaan         text not null,
  kunci              jsonb,
  pembahasan         text,
  sumber_id          uuid references sumber (id),
  tahun_sumber       smallint,
  lisensi            text,
  qa                 qa_status not null default 'perlu_verifikasi',
  hash_konten        text unique,               -- deteksi duplikasi
  dibuat_oleh_agent  smallint check (dibuat_oleh_agent between 1 and 12),
  created_at         timestamptz not null default now()
);

create table opsi_soal (
  id          uuid primary key default gen_random_uuid(),
  soal_id     uuid not null references soal (id) on delete cascade,
  label       text not null,                    -- A, B, C, ...
  teks        text not null,
  benar       boolean not null default false,
  alasan      text,                             -- alasan opsi pengecoh
  unique (soal_id, label)
);

-- ---------- Aktivitas belajar ----------
create table berkas (
  id               uuid primary key default gen_random_uuid(),
  user_id          uuid not null references profiles (id) on delete cascade,
  jenis            jenis_berkas not null,
  storage_path     text not null,               -- bucket PRIVAT, bukan URL publik
  mime             text,
  ukuran_byte      bigint check (ukuran_byte > 0),
  teks_ocr         text,
  keyakinan_ocr    numeric check (keyakinan_ocr between 0 and 1),
  perlu_konfirmasi boolean not null default false,
  retensi_sampai   date,
  created_at       timestamptz not null default now()
);

create table simulasi (
  id                uuid primary key default gen_random_uuid(),
  user_id           uuid not null references profiles (id) on delete cascade,
  mulai             timestamptz not null default now(),
  selesai           timestamptz,
  batas_waktu_detik integer
);

create table percobaan (
  id               uuid primary key default gen_random_uuid(),
  user_id          uuid not null references profiles (id) on delete cascade,
  soal_id          uuid not null references soal (id),
  simulasi_id      uuid references simulasi (id) on delete set null,
  mode             mode_percobaan not null default 'latihan',
  jawaban          jsonb,
  berkas_id        uuid references berkas (id) on delete set null,
  terkonfirmasi    boolean,                     -- untuk jawaban dari OCR; null bila bukan OCR
  skor             numeric,
  keyakinan        numeric check (keyakinan between 0 and 1),
  alasan_penilaian text,
  qa               qa_status not null default 'perlu_verifikasi',
  durasi_detik     integer,
  created_at       timestamptz not null default now(),
  -- Jawaban dari OCR yang belum dikonfirmasi tidak boleh memiliki skor final.
  constraint skor_perlu_konfirmasi
    check (berkas_id is null or terkonfirmasi is true or skor is null)
);

-- Readiness Score: hanya jawaban terkonfirmasi dan lolos QA yang dihitung (aturan di aplikasi).
create table snapshot_kesiapan (
  id             uuid primary key default gen_random_uuid(),
  user_id        uuid not null references profiles (id) on delete cascade,
  dihitung_pada  timestamptz not null default now(),
  persen         numeric check (persen between 0 and 100),  -- null bila data belum cukup
  kecukupan      kecukupan_data not null,
  dimensi        jsonb not null,
  bobot          jsonb not null,
  versi_bobot    text not null,
  -- Persentase tidak boleh ditampilkan bila data belum cukup.
  constraint persen_perlu_data check (kecukupan <> 'belum_cukup' or persen is null)
);

create table memori (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references profiles (id) on delete cascade,
  jenis       jenis_memori not null,
  isi         text not null,
  sumber_ref  text,
  qa          qa_status not null default 'perlu_verifikasi',
  dibuat_oleh_agent smallint default 6 check (dibuat_oleh_agent between 1 and 12),
  created_at  timestamptz not null default now()
);

create table laporan (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid references profiles (id) on delete cascade,
  periode_mulai date not null,
  periode_akhir date not null,
  isi           jsonb not null,
  angka_valid   boolean not null default false,   -- divalidasi Agent 7 sebelum dikirim
  created_at    timestamptz not null default now()
);

-- ---------- Agent, tugas, persetujuan, audit ----------
create table agent (
  id          smallint primary key check (id between 1 and 12),
  nama        text not null,
  tim         text not null,
  status      status_agent not null default 'nonaktif',
  alasan      text,
  updated_at  timestamptz not null default now()
);

create table tugas_agent (
  id              uuid primary key default gen_random_uuid(),
  agent_id        smallint not null references agent (id),
  induk_id        uuid references tugas_agent (id),
  masukan         jsonb,
  keluaran        jsonb,
  status          status_tugas not null default 'antre',
  sumber_ref      jsonb,
  versi           text,
  mulai           timestamptz,
  selesai         timestamptz,
  created_at      timestamptz not null default now()
);

create table persetujuan (
  id            uuid primary key default gen_random_uuid(),
  tindakan      text not null,                   -- mis. hapus_data, restore, publikasi, aktivasi_ulang_agent
  diminta_agent smallint references agent (id),
  rincian       jsonb,
  status        status_persetujuan not null default 'menunggu',
  diminta_pada  timestamptz not null default now(),
  diputuskan_oleh uuid references profiles (id),
  diputuskan_pada timestamptz
);

create table audit_log (
  id          bigint generated always as identity primary key,
  jenis_aktor text not null check (jenis_aktor in ('pengguna', 'agent', 'sistem')),
  aktor_id    text,
  tindakan    text not null,
  target_jenis text,
  target_id   text,
  rincian     jsonb,
  created_at  timestamptz not null default now()
);

-- ---------- Indeks ----------
create index on topik (mapel_id);
create index on soal (topik_id);
create index on opsi_soal (soal_id);
create index on percobaan (soal_id);
create index on percobaan (user_id, created_at desc);
create index on snapshot_kesiapan (user_id, dihitung_pada desc);
create index on tugas_agent (agent_id, status);
create index on audit_log (created_at desc);

-- ---------- Row Level Security ----------
alter table profiles          enable row level security;
alter table sumber            enable row level security;
alter table mapel             enable row level security;
alter table topik             enable row level security;
alter table materi            enable row level security;
alter table soal              enable row level security;
alter table opsi_soal         enable row level security;
alter table berkas            enable row level security;
alter table simulasi          enable row level security;
alter table percobaan         enable row level security;
alter table snapshot_kesiapan enable row level security;
alter table memori            enable row level security;
alter table laporan           enable row level security;
alter table agent             enable row level security;
alter table tugas_agent       enable row level security;
alter table persetujuan       enable row level security;
alter table audit_log         enable row level security;

-- Profil
create policy profiles_baca on profiles for select
  using (id = auth.uid() or is_pengawas());

-- Katalog yang aman dibaca semua pengguna masuk
create policy mapel_baca   on mapel   for select to authenticated using (true);
create policy topik_baca   on topik   for select to authenticated using (true);
create policy materi_baca  on materi  for select to authenticated using (qa = 'lolos' or is_pengawas());
create policy sumber_baca  on sumber  for select to authenticated using (true);

-- Soal memuat kunci: pelajar TIDAK membacanya langsung (agar kunci tidak bocor sebelum menjawab).
-- Pelajar mengakses soal lewat server/fungsi yang tidak mengembalikan kunci.
create policy soal_pengawas      on soal      for select using (is_pengawas());
create policy opsi_soal_pengawas on opsi_soal for select using (is_pengawas());

-- Data milik pelajar: hanya dibaca dari klien. Penulisan (unggahan, jawaban, skor)
-- lewat server dengan service role, supaya skor dan status QA tidak bisa dipalsukan.
create policy berkas_milik     on berkas     for select using (user_id = auth.uid() or is_pengawas());
create policy simulasi_milik   on simulasi   for select using (user_id = auth.uid() or is_pengawas());
create policy percobaan_milik  on percobaan  for select using (user_id = auth.uid() or is_pengawas());
create policy kesiapan_milik   on snapshot_kesiapan for select using (user_id = auth.uid() or is_pengawas());
create policy memori_milik     on memori     for select using (user_id = auth.uid() or is_pengawas());
create policy laporan_pengawas on laporan    for select using (is_pengawas());

-- Khusus pengawas (Panel Kakak)
create policy agent_pengawas       on agent       for select using (is_pengawas());
create policy tugas_pengawas       on tugas_agent for select using (is_pengawas());
create policy persetujuan_pengawas on persetujuan for select using (is_pengawas());
create policy persetujuan_putus    on persetujuan for update using (is_pengawas());
create policy audit_pengawas       on audit_log   for select using (is_pengawas());

-- Audit log append-only: tidak ada yang boleh mengubah atau menghapus lewat API.
revoke update, delete, truncate on audit_log from anon, authenticated;

-- ---------- Data awal: 12 agent ----------
insert into agent (id, nama, tim) values
  (1,  'Teman Diskusi',                    'Belajar'),
  (2,  'Pengumpul Soal',                   'Konten & Kualitas'),
  (3,  'Pencari Materi',                   'Belajar'),
  (4,  'Pelatih Soal',                     'Belajar'),
  (5,  'QA Trainer',                       'Konten & Kualitas'),
  (6,  'Perencana Strategi',               'Strategi & Analitik'),
  (7,  'Pelapor',                          'Laporan & Komunikasi'),
  (8,  'Visualisasi Data & Dashboard',     'Strategi & Analitik'),
  (9,  'Newsletter',                       'Laporan & Komunikasi'),
  (10, 'Teknisi Website & System Monitor', 'Teknis'),
  (11, 'Pembuat Visual Bagikan',           'Laporan & Komunikasi'),
  (12, 'Master Orchestrator',              'Pengawas');
