# Spesifikasi Sistem Ruang Belajar Lovha v1.1

Tanggal: 1 November 2026 · Status: baseline rancangan, menunggu persetujuan Alvin.
Menggantikan v1.0. Semua keputusan baseline v1.0 dipertahankan.

## Ringkasan perubahan v1.0 → v1.1

| # | Perubahan | Alasan |
| --- | --- | --- |
| 1 | Komponen SNBT dilengkapi menjadi 7 subtes (4 TPS + 3 Literasi) mengikuti format SNBT 2026; format 2027 masih perlu verifikasi | v1.0 hanya memuat 4 subtes |
| 2 | Satu istilah: "SNBT Readiness Score" | v1.0 memakai "UTBK" dan "SNBT" bergantian |
| 3 | Evaluasi Agent 12 ditinjau Alvin lewat audit log | Agent 12 tidak boleh menilai dirinya sendiri |
| 4 | Penonaktifan agent masuk matriks kewenangan, wajib dilaporkan segera | v1.0 hanya mengatur pengaktifan kembali |
| 5 | Pemantauan risiko dibagi: deteksi, pelaporan, keputusan | Agent 7, 8, 10, 12 tumpang tindih |
| 6 | Nama Agent 1 disamakan: "Teman Diskusi" (prototype: "Tutor AI") | Penamaan beda |
| 7 | Kepemilikan memori ditetapkan | v1.0 tidak punya pemilik lapisan memori |
| 8 | Bank soal Agent 2 juga wajib lolos QA Agent 5 | v1.0 hanya memeriksa keluaran Agent 3 dan 4 |
| 9 | Bila Alvin tidak merespons, tindakan sensitif ditahan | Mencegah persetujuan otomatis |
| 10 | Peran akses (Lovha, Alvin) dan perlindungan data pelajar | Pengguna kemungkinan di bawah 18 tahun; UU PDP |
| 11 | Ambang kecukupan data Readiness Score menjadi keputusan terbuka | v1.0 belum menetapkan ukurannya |
| 12 | Daftar keputusan terbuka dan batas biaya | v1.0 menyebut biaya tanpa penetapan |

## 1. Visi, tujuan, dan ruang lingkup

Ruang Belajar Lovha adalah platform pendamping belajar personal untuk persiapan SNBT 2027 dengan target Ilmu Gizi, IPB University. Pengguna belajarnya Lovha; pengawas dan pemberi persetujuan adalah Alvin ("Kakak").

- **Tujuan:** membantu Lovha memahami materi, berlatih, menerima penilaian dan pembahasan, memantau perkembangan, dan menyiapkan diri menghadapi SNBT 2027.
- **Prinsip cakupan:** semua kelompok pembelajaran dirancang sejak awal; pembangunan teknis bertahap.
- **Batas penting:**
  - SNBT Readiness Score adalah indeks kesiapan belajar, bukan peluang diterima di IPB.
  - Biologi, Kimia, dan Fisika adalah penguatan dasar Ilmu Gizi, tidak dilabeli komponen SNBT resmi tanpa verifikasi ketentuan SNBT 2027.
  - Dokumen ini adalah spesifikasi rancangan, bukan bukti bahwa agent atau fitur sudah aktif.

## 2. Cakupan pembelajaran

| Kelompok | Isi | Status |
| --- | --- | --- |
| Komponen SNBT: Tes Potensi Skolastik (TPS) | Penalaran Umum, Pengetahuan & Pemahaman Umum, Pemahaman Bacaan & Menulis, Pengetahuan Kuantitatif | Mengikuti format SNBT 2026; format 2027 perlu verifikasi oleh Agent 9 |
| Komponen SNBT: Tes Literasi | Literasi Bahasa Indonesia, Literasi Bahasa Inggris, Penalaran Matematika | Mengikuti format SNBT 2026; format 2027 perlu verifikasi oleh Agent 9 |
| Penguatan akademik | Matematika, Biologi, Kimia, Fisika, termasuk topik pendukung Ilmu Gizi | Berlabel "penguatan", bukan komponen tes |
| Keterampilan bahasa | Membaca, menulis, tata bahasa, kosakata, listening, dictation, speaking, percakapan interaktif | Listening dan speaking mulai Tahap 4 |

Jenis aktivitas: mempelajari materi, membaca rangkuman, pilihan ganda, esai, soal bertahap, simulasi berbatas waktu, unggah foto jawaban tulisan tangan, unggah PDF, latihan berbasis audio.

Aturan label: setiap mapel dan topik memiliki penanda "Komponen SNBT" atau "Penguatan" beserta tanggal verifikasi. Penanda diubah hanya setelah Agent 9 menautkan sumber resmi.

Sumber acuan daftar subtes 2026: [artikel UNNES tentang subtes UTBK-SNBT 2026](https://unnes.ac.id/utbk-snbt-2026-subtests-that-you-must-prepare-well-for/) (sumber sekunder, diakses 1 November 2026). Jumlah soal dan durasi per subtes tidak dicantumkan di sini sampai terverifikasi di situs resmi SNPMB (snpmb.id).

## 3. Fitur utama dan alur input

| Fitur | Fungsi |
| --- | --- |
| Beranda | Target harian, aktivitas terakhir, pengingat, capaian, rekomendasi |
| Semua Mata Pelajaran | Katalog mapel, topik, subtopik, kesulitan, status penguasaan, penanda Komponen SNBT/Penguatan |
| Materi Pembelajaran | Materi terstruktur, rangkuman, contoh, sumber, tanggal verifikasi |
| Bank Soal | Soal dengan kunci, pembahasan, alasan opsi pengecoh, sumber/lisensi, status QA |
| Ruang Latihan | Pilihan ganda, esai, jawaban bertahap, latihan berbatas waktu |
| Unggah Jawaban | Foto tulisan tangan, foto rumus, PDF; cek kualitas berkas dan konfirmasi bila hasil baca tidak pasti |
| Listening & Speaking | Audio pemahaman, kosakata, dictation, respons lisan, percakapan interaktif |
| Simulasi SNBT | Paket simulasi dengan timer, hasil, analisis, riwayat |
| Portofolio Belajar | Riwayat per mapel/topik; dapat diekspor ke PDF/CSV |
| Kesiapan SNBT 2027 | Persentase kesiapan, dimensi, tren, kecukupan data, rekomendasi |
| Panel Kakak | Khusus Alvin: progres, laporan, status agent, kualitas, aktivitas, permintaan persetujuan |

**Smart Input Router:** satu pintu input menerima teks, pilihan mapel/topik, foto, PDF, dan audio, lalu merutekan ke agent yang tepat. Lovha tetap boleh memilih agent secara manual.

**Alur umum:**

1. Input Lovha masuk lewat Smart Input Router.
2. Pemeriksaan format dan kualitas berkas.
3. Klasifikasi: tujuan, mapel, topik, kesulitan, jenis tugas.
4. Penugasan agent.
5. Evaluasi dan QA bila diperlukan.
6. Hasil dan pembahasan.
7. Simpan ke portofolio.
8. Agent 6 memperbarui analitik; Agent 8 menampilkan; Agent 7 melaporkan temuan penting.

**Aturan ketidakpastian:** bila tulisan, rumus, simbol, atau audio tidak terbaca dengan yakin, sistem tidak menebak dan tidak memberi nilai final. Bagian ambigu ditandai, lalu sistem meminta foto/audio yang lebih jelas atau konfirmasi Lovha. Nilai yang belum terkonfirmasi tidak masuk ke Readiness Score.

## 4. Struktur 12 agent

Dua belas agent dikelompokkan dalam lima tim. Agent 12 berada di atas semua tim dan melapor ke Alvin. Orchestrator internal adalah komponen eksekusi (routing, antrean, workflow), bukan agent, dan berbeda dari Agent 12. Rincian ada di [`agents/README.md`](../agents/README.md).

| Tim | Agent |
| --- | --- |
| Belajar | 1 Teman Diskusi, 3 Pencari Materi, 4 Pelatih Soal |
| Konten & Kualitas | 2 Pengumpul Soal, 5 QA Trainer |
| Strategi & Analitik | 6 Perencana Strategi, 8 Visualisasi Data & Dashboard |
| Laporan & Komunikasi | 7 Pelapor, 9 Newsletter, 11 Pembuat Visual Bagikan |
| Teknis | 10 Teknisi Website & System Monitor |
| Pengawas | 12 Master Orchestrator |

**Pembagian pemeriksaan:** Agent 5 memeriksa *isi* (benar tidaknya soal, kunci, penilaian). Agent 12 memeriksa *proses dan kinerja* (tepat waktu, dalam kewenangan, lolos QA).

## 5. Orkestrasi, kewenangan, dan persetujuan Alvin

Setiap tugas agent memiliki ID, pemilik, input, output, status, waktu, dan jejak audit; hasil penting menyimpan sumber dan versi.

| Tindakan | Siapa yang boleh | Syarat |
| --- | --- | --- |
| Delegasi, koordinasi, permintaan revisi rutin | Agent 12 | Mandiri, tercatat di audit log |
| Penonaktifan sementara agent yang dicurigai keliru, membahayakan data, atau melampaui kewenangan | Agent 12 | Boleh langsung, wajib dilaporkan ke Panel Kakak segera |
| Pengaktifan kembali setelah insiden serius | Alvin | Persetujuan wajib |
| Penghapusan data, overwrite, restore | Alvin | Persetujuan wajib |
| Penghapusan atau reset memori | Alvin | Persetujuan wajib |
| Pembagian data, publikasi, tindakan eksternal atau irreversibel | Alvin | Persetujuan wajib |
| Perubahan keamanan kritis | Alvin | Persetujuan wajib |
| Perubahan strategi besar, integrasi visual besar | Alvin | Persetujuan wajib |

- **Bila Alvin tidak merespons:** tindakan yang memerlukan persetujuan ditahan dan tidak pernah dianggap disetujui. Pekerjaan rutin tetap berjalan; Agent 7 mengirim pengingat.
- **Konflik antar agent:** konflik rutin diputus Agent 12; yang menyangkut tindakan sensitif dieskalasi ke Alvin.
- **Evaluasi harian:** Agent 12 mengevaluasi agent lain (ketepatan waktu, kegagalan workflow, hasil QA, kepatuhan kewenangan). Laporan harian dan audit log Agent 12 sendiri ditinjau Alvin di Panel Kakak.
- **Human override:** Alvin dapat menghentikan, mengoreksi, menyetujui, atau menolak tindakan agent kapan saja; semuanya masuk audit log. Persetujuan dalam percakapan tidak menggantikan mekanisme persetujuan aplikasi bila aplikasi memerlukannya.

**Pembagian pemantauan risiko**

| Peran | Pemilik |
| --- | --- |
| Mendeteksi risiko belajar (metrik eksplisit) | Agent 8 |
| Mendeteksi risiko teknis dan keamanan | Agent 10 |
| Mendeteksi risiko perilaku agent | Agent 12 |
| Menyampaikan peringatan | Agent 7 |
| Memutuskan tindakan | Agent 12 (rutin), Alvin (sensitif) |

## 6. Keamanan dan kepemilikan memori

**Keamanan** dimiliki Agent 10, diawasi Agent 12, keputusan kritis di tangan Alvin.

- Autentikasi dan otorisasi berbasis peran: Lovha (pelajar) dan Alvin (pengawas, akses Panel Kakak); hak akses minimum.
- Validasi unggahan, rahasia dan API key hanya di sisi server, dependensi diperbarui, aktivitas tercatat.
- Backup terjadwal, uji pemulihan, pencatatan versi; restore yang menimpa data aktif perlu persetujuan Alvin.
- Berkas privat di object storage dengan kontrol akses, batas ukuran, dan retensi; tidak pada URL publik.

**Kepemilikan memori**

| Fungsi | Pemilik | Aturan |
| --- | --- | --- |
| Infrastruktur memori: penyimpanan, akses, backup, retensi | Agent 10 | Perubahan skema dan penghapusan perlu persetujuan Alvin |
| Isi memori belajar: pola kesalahan, preferensi, riwayat | Agent 6 | Hanya menyimpan fakta yang tercatat, bukan dugaan |
| Membaca memori dalam percakapan | Agent 1 | Hanya yang relevan; tidak menulis ke memori |
| Pemeriksaan isi memori | Agent 5 | Menandai entri keliru atau tidak bersumber |
| Audit dan eskalasi | Agent 12 | Reset atau hapus memori hanya dengan persetujuan Alvin |

Prinsip memori: pisahkan fakta, estimasi, dan rekomendasi; simpan sumber, tanggal, dan status verifikasi.

## 7. SNBT Readiness Score

Skor menggambarkan kesiapan belajar Lovha berdasarkan bukti performa, bukan peluang diterima di IPB. Pemilik utama: Agent 6; kalibrasi bersama Agent 5; audit Agent 12.

| Dimensi | Bobot awal (hipotesis) |
| --- | --- |
| Penguasaan kompetensi | 30% |
| Akurasi | 25% |
| Penalaran dan penerapan | 20% |
| Konsistensi dan retensi | 15% |
| Manajemen waktu | 10% |

Bobot berjumlah 100%, belum final, bukan standar resmi; diuji dan dikalibrasi setelah ada data representatif.

**Aturan bukti**

- Simulasi terstruktur berbatas waktu berbobot bukti lebih besar daripada latihan ringan.
- Jawaban yang belum dikonfirmasi (OCR/rumus ambigu) atau berstatus QA "perlu verifikasi" tidak dihitung.
- Kecukupan data ditampilkan terpisah dari persentase. Bila belum memadai, tampilkan "Data belum cukup" atau "Estimasi awal", bukan persentase seolah pasti.
- Ambang kecukupan data belum ditetapkan; diputuskan di Tahap 2 dan dicatat sebagai versi baru.

**Label internal (usulan, bukan ambang resmi SNBT)**

| Rentang | Label |
| --- | --- |
| 0–49% | Perlu Penguatan |
| 50–74% | Dalam Proses Persiapan |
| 75–89% | Mendekati Siap |
| 90–100% | Siap Menghadapi Simulasi Ujian |

Prediksi penerimaan, bila kelak dipertimbangkan, adalah model terpisah dan membutuhkan data pembanding yang sahih.

## 8. Data, privasi, dan hak cipta

**Data dan penyimpanan**

- **Supabase** (direkomendasikan): data relasional. Draf skema ada di [`db/schema.sql`](../db/schema.sql).
- **Graphiti** (dievaluasi): lapisan memori relasional/temporal; bukan orchestrator dan bukan pengganti database relasional.
- **Object storage:** foto, PDF, audio dengan kontrol akses, batas ukuran, retensi.
- **Portabilitas:** ekspor portofolio dan laporan ke PDF/CSV; skema didokumentasikan.

**Privasi**

- Kumpulkan data seperlunya, batasi akses, lindungi berkas dan percakapan; tidak ada data pribadi di laporan publik.
- Bila Lovha berusia di bawah 18 tahun, pastikan persetujuan orang tua/wali dan tentukan retensi data. Kepatuhan terhadap UU Pelindungan Data Pribadi (UU No. 27 Tahun 2022) dikonfirmasi di Tahap 0.
- Pembagian data atau visual ke luar selalu melalui persetujuan Alvin.

**Hak cipta:** gunakan soal orisinal, materi terbuka, berlisensi, atau item resmi yang boleh dipakai; catat sumber dan izin; tidak menyalin massal buku atau bank soal komersial.

**Layanan pihak ketiga:** OCR, model AI, ASR/TTS, hosting, database, dan penyimpanan memiliki biaya, batas penggunaan, dan ketentuan privasi. Periksa sebelum produksi; jangan menjanjikan semua fitur gratis.

## 9. Tahapan, status, dan penerimaan

| Tahap | Isi | Agent utama |
| --- | --- | --- |
| 0 Fondasi | Kebutuhan, peta data, akses, privasi, arsitektur, pilihan layanan, indikator keberhasilan, batas biaya | Alvin, Agent 10 |
| 1 MVP pembelajaran | Autentikasi, katalog semua mapel, materi, bank soal awal, latihan, penilaian, portofolio, dashboard dasar | Agent 1, 2, 3, 4 |
| 2 Kualitas dan strategi | QA Agent 5, analitik Agent 6, Readiness Score estimasi, laporan Agent 7, pengawasan Agent 12 | Agent 5, 6, 7, 8, 12 |
| 3 Input multimodal | Foto tulisan tangan, rumus, PDF, konfirmasi OCR; uji akurasi dan kegagalan | Agent 10, 4, 5 |
| 4 Audio dan percakapan | Listening, dictation, speaking, ASR/TTS, percakapan suara | Agent 1, 10 |
| 5 Simulasi dan skala | Simulasi lengkap, bank soal terverifikasi diperluas, performa, backup, monitoring, ekspor | Semua tim |

**Status prototype:** prototype HTML baru menampilkan Beranda, Tutor AI, Progres, dan Panel Kakak. Daftar agent masih lima contoh, balasan chat simulasi berbasis kata kunci, angka dashboard statis. Prototype belum membuktikan 12 agent aktif, AI sungguhan, penyimpanan progres, OCR, atau Readiness Score yang valid.

**Kriteria penerimaan tiap tahap:** alur utama dapat diuji; data tersimpan dan bisa diambil kembali; hasil penilaian dapat ditelusuri; kasus ambigu ditangani aman; hak akses berfungsi; laporan sesuai data; backup dapat dipulihkan dalam uji terkontrol.

**Keputusan baseline (tetap dari v1.0):** semua mapel dirancang sejak awal dengan implementasi bertahap; 11 agent spesialis + Orchestrator internal + Agent 12, tanpa Agent 13; tindakan sensitif dan irreversibel perlu persetujuan Alvin; pembelajaran multimodal masuk rancangan; Readiness Score dengan kecukupan data dan terpisah dari peluang diterima.

Keputusan yang belum diambil ada di [`keputusan-terbuka.md`](keputusan-terbuka.md). Riwayat versi ada di [`../CHANGELOG.md`](../CHANGELOG.md).

## Lampiran A — Alur penilaian foto jawaban

1. Lovha memilih mapel/topik atau mengirim foto lewat Smart Input Router.
2. Agent 10 memeriksa tipe file, ukuran, kualitas gambar, lalu menjalankan OCR/pengenalan rumus.
3. Bila ada karakter atau langkah tidak terbaca, sistem meminta konfirmasi sebelum penilaian.
4. Agent 4 menilai jawaban dan menyusun pembahasan; Agent 5 memeriksa kebenaran penilaian.
5. Agent 1 menjelaskan kesalahan dengan bahasa sesuai tingkat pemahaman Lovha.
6. Hasil, foto, jawaban, skor, pembahasan, dan status QA disimpan ke portofolio.
7. Agent 6 memperbarui analisis dan Readiness Score bila bukti cukup; Agent 8 menampilkan visual; Agent 7 memasukkan temuan penting ke laporan.

## Lampiran B — Glosarium

| Istilah | Arti |
| --- | --- |
| ASR | Automatic Speech Recognition: mengubah ucapan menjadi teks |
| TTS | Text-to-Speech: mengubah teks menjadi suara |
| OCR | Optical Character Recognition: membaca teks dari gambar/dokumen |
| MVP | Minimum Viable Product: versi awal dengan fungsi inti yang dapat diuji |
| Readiness Score | Indeks kesiapan belajar berbasis bukti; bukan peluang diterima |
| Orchestrator internal | Komponen teknis untuk routing dan eksekusi workflow |
| Master Orchestrator | Agent 12 yang mengawasi koordinasi, kualitas, dan tata kelola |
