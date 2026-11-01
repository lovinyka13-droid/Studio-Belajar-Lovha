# Riwayat versi spesifikasi

Format: versi, tanggal, alasan, pemilik keputusan, dampak (agent, data, keamanan, biaya).

## 1.1.1 — 1 November 2026

- **Alasan:** audit ulang repository.
- **Pemilik keputusan:** Alvin (menunggu persetujuan).
- **Perubahan:**
  - Komponen SNBT dikoreksi dari 3 tambahan menjadi daftar lengkap 7 subtes (format SNBT 2026, sumber sekunder); format 2027 tetap keputusan terbuka.
  - `db/schema.sql`: penulisan jawaban, skor, dan unggahan hanya lewat server (kebijakan insert dari klien dihapus agar skor tidak bisa dipalsukan); trigger pembuatan profil otomatis dengan peran `pelajar`; constraint skor OCR belum terkonfirmasi dan persentase kesiapan saat data belum cukup; indeks tambahan; `audit_log` juga tidak bisa di-truncate.
  - `.env.example`: variabel model AI dibuat generik (penyedia belum diputuskan); komentar dipindah ke baris sendiri agar aman di semua parser.
  - `README.md`: panduan mengunggah ke GitHub.
- **Dampak:** data dan keamanan; agent dan biaya tidak berubah.

## 1.1 — 1 November 2026

- **Alasan:** pemeriksaan ulang terhadap v1.0; 12 perbaikan (lihat tabel di `docs/spesifikasi-v1.1.md`).
- **Pemilik keputusan:** Alvin (menunggu persetujuan).
- **Dampak:**
  - Agent: 1, 2, 5, 6, 7, 8, 9, 10, 12.
  - Data: penanda label mapel (Komponen SNBT/Penguatan), kepemilikan memori, status QA bank soal.
  - Keamanan: peran akses, penonaktifan agent, penahanan tindakan sensitif bila tidak ada respons.
  - Biaya: belum berubah; batas biaya menjadi keputusan terbuka.

## 1.0 — 1 November 2026

- **Alasan:** baseline awal.
- **Pemilik keputusan:** Alvin.
- **Dampak:** seluruh sistem.
