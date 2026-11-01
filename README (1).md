# Ruang Belajar Lovha

Platform pendamping belajar personal untuk persiapan **SNBT 2027** dengan target **Ilmu Gizi, IPB University**. Sistem dirancang dengan 11 agent spesialis, satu Orchestrator internal, dan Agent 12 sebagai Master Orchestrator.

> **Status: tahap rancangan (Tahap 0).** Repository ini memuat spesifikasi dan kerangka awal. Belum ada agent atau fitur yang aktif. Prototype HTML sebelumnya hanya simulasi (balasan berbasis kata kunci, angka dashboard statis).

## Prinsip utama

- Semua mata pelajaran dirancang sejak awal; pembangunan bertahap.
- SNBT Readiness Score adalah indeks kesiapan belajar, **bukan** peluang diterima di IPB.
- Tindakan sensitif atau tidak bisa dibatalkan (hapus data, restore, publikasi, ubah keamanan kritis) selalu memerlukan persetujuan Alvin.
- Bila bukti tidak cukup, sistem menyatakan "belum diketahui" dan tidak menebak.

## Struktur repository

```
.
├── README.md
├── CHANGELOG.md                # log versi spesifikasi
├── .env.example                # nama variabel saja, tanpa nilai rahasia
├── .gitignore
├── docs/
│   ├── spesifikasi-v1.1.md     # baseline spesifikasi
│   └── keputusan-terbuka.md    # hal yang menunggu keputusan Alvin
├── agents/
│   └── README.md              # daftar 12 agent, kewenangan, template
├── db/
│   └── schema.sql              # DRAF skema Supabase (belum final)
└── .github/
    ├── pull_request_template.md
    └── ISSUE_TEMPLATE/
        └── perubahan-spesifikasi.md
```

## Tahapan

| Tahap | Isi |
| --- | --- |
| 0 Fondasi | Kebutuhan, peta data, akses, privasi, arsitektur, pilihan layanan, batas biaya |
| 1 MVP pembelajaran | Autentikasi, katalog mapel, materi, bank soal awal, latihan, penilaian, portofolio, dashboard dasar |
| 2 Kualitas dan strategi | QA Agent 5, analitik Agent 6, Readiness Score estimasi, laporan, pengawasan Agent 12 |
| 3 Input multimodal | Foto tulisan tangan, rumus, PDF, konfirmasi OCR |
| 4 Audio dan percakapan | Listening, dictation, speaking, ASR/TTS |
| 5 Simulasi dan skala | Simulasi lengkap, bank soal diperluas, monitoring, backup, ekspor |

## Aturan kontribusi

1. Perubahan spesifikasi lewat issue "Perubahan spesifikasi", lalu pull request.
2. Setiap perubahan mencatat: nomor versi, tanggal, alasan, pemilik keputusan, dampak ke agent, data, keamanan, dan biaya (isi di `CHANGELOG.md`).
3. Perubahan teknis besar menunggu persetujuan Alvin.
4. Jangan pernah meng-commit data belajar Lovha, foto, audio, API key, atau file `.env`.

## Privasi

Gunakan repository **private**. Data pelajar tidak boleh masuk repository.

## Cara mengunggah ke GitHub

1. Ekstrak `lovha-repo.zip` di komputer. GitHub tidak mengekstrak file zip otomatis, dan aplikasi GitHub di ponsel tidak mendukung unggah folder, jadi langkah ini sebaiknya dari komputer.
2. Buat repository baru, pilih **Private**, dan jangan centang README, .gitignore, atau license (semuanya sudah ada).
3. Pilih "uploading an existing file", lalu seret **isi** folder `lovha-repo` (bukan file zip-nya) dan commit. Folder `.github` bersifat tersembunyi: di macOS tekan Cmd+Shift+. agar terlihat, dan pastikan folder itu ikut terunggah.

Atau lewat terminal:

```bash
cd lovha-repo
git init -b main
git add .
git commit -m "Spesifikasi dan kerangka awal Ruang Belajar Lovha v1.1"
git remote add origin https://github.com/<akun>/<nama-repo>.git
git push -u origin main
```

Pastikan `.env` tidak pernah ikut ter-commit (sudah diabaikan oleh `.gitignore`).

## Catatan status

- `db/schema.sql` sudah dijalankan di Postgres 16 dengan tiruan skema `auth` Supabase dan lolos tanpa error. Belum diuji di Supabase asli.
- Daftar subtes SNBT mengikuti format 2026 dari sumber sekunder; format 2027 menunggu verifikasi ke sumber resmi.
- Lisensi belum ditetapkan (repository private).
