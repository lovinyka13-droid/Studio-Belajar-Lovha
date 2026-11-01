# 12 Agent

Status: **rancangan**. Belum ada agent yang aktif. Spesifikasi lengkap: [`../docs/spesifikasi-v1.1.md`](../docs/spesifikasi-v1.1.md).

Orchestrator internal (komponen eksekusi: routing, antrean, workflow) bukan agent dan berbeda dari Agent 12.

| No | Nama | Tim | Tugas inti | Batas penting |
| --- | --- | --- | --- | --- |
| 1 | Teman Diskusi | Belajar | Tutor percakapan adaptif, petunjuk bertahap, membaca memori relevan; suara dua arah mulai Tahap 4 | Tidak mengarang fakta; hanya membaca memori |
| 2 | Pengumpul Soal | Konten & Kualitas | Impor, metadata, deteksi duplikasi, merawat bank soal (awal 500 soal terverifikasi; target jangka panjang 5.000) | Soal baru berstatus "perlu verifikasi" sampai lolos Agent 5 |
| 3 | Pencari Materi | Belajar | Mengkurasi materi dari sumber resmi/terbuka/berlisensi, simpan sumber dan tanggal verifikasi | Tidak scraping atau menyalin materi komersial |
| 4 | Pelatih Soal | Belajar | Latihan dan simulasi, menilai pilihan ganda/esai, solusi langkah demi langkah, kredit parsial | Penilaian menyertakan alasan dan tingkat keyakinan |
| 5 | QA Trainer | Konten & Kualitas | Memeriksa isi: soal, kunci, pembahasan, format, konsistensi; keluaran Agent 2, 3, 4; isi memori | Status: lolos, revisi, perlu verifikasi |
| 6 | Perencana Strategi | Strategi & Analitik | Roadmap, target, analisis tryout, portofolio, pemilik Readiness Score, isi memori belajar | Strategi besar perlu persetujuan Alvin |
| 7 | Pelapor | Laporan & Komunikasi | Laporan mingguan, peringatan, validasi angka | Tidak mempublikasikan data pribadi; media sosial ditinjau Alvin |
| 8 | Visualisasi Data & Dashboard | Strategi & Analitik | Dashboard dan grafik dari data tervalidasi; deteksi risiko belajar | Berbasis metrik eksplisit; visual baru besar perlu persetujuan |
| 9 | Newsletter | Laporan & Komunikasi | Pantau info SNBT 2027 dan IPB, verifikasi sumber, tanggal, format komponen tes | Tidak mengirim bila tidak ada info baru |
| 10 | Teknisi Website & System Monitor | Teknis | Stabilitas, keamanan, backup, unggahan, OCR, parser PDF, audio, ASR/TTS, infrastruktur memori | Tidak menghapus, menimpa, restore, atau mengubah keamanan kritis tanpa persetujuan |
| 11 | Pembuat Visual Bagikan | Laporan & Komunikasi | Infografik dari data/laporan yang sudah disetujui | Tidak mengunggah atau membagikan data privat otomatis |
| 12 | Master Orchestrator | Pengawas | Delegasi, koordinasi, pemeriksaan proses dan kinerja agent, deteksi konflik dan risiko | Evaluasi dirinya ditinjau Alvin |

## Matriks persetujuan

| Tindakan | Siapa | Syarat |
| --- | --- | --- |
| Delegasi, koordinasi, revisi rutin | Agent 12 | Mandiri, tercatat di audit log |
| Penonaktifan sementara agent | Agent 12 | Langsung, wajib dilaporkan ke Panel Kakak segera |
| Aktivasi kembali setelah insiden serius | Alvin | Persetujuan wajib |
| Hapus data, overwrite, restore | Alvin | Persetujuan wajib |
| Hapus atau reset memori | Alvin | Persetujuan wajib |
| Bagikan data, publikasi, tindakan eksternal/irreversibel | Alvin | Persetujuan wajib |
| Ubah keamanan kritis | Alvin | Persetujuan wajib |
| Strategi besar, integrasi visual besar | Alvin | Persetujuan wajib |

Bila Alvin tidak merespons, tindakan yang memerlukan persetujuan ditahan dan tidak pernah dianggap disetujui.

## Pembagian pemantauan risiko

| Peran | Pemilik |
| --- | --- |
| Deteksi risiko belajar | Agent 8 |
| Deteksi risiko teknis dan keamanan | Agent 10 |
| Deteksi risiko perilaku agent | Agent 12 |
| Penyampaian peringatan | Agent 7 |
| Keputusan tindakan | Agent 12 (rutin), Alvin (sensitif) |

## Kepemilikan memori

| Fungsi | Pemilik |
| --- | --- |
| Infrastruktur (penyimpanan, akses, backup, retensi) | Agent 10 |
| Isi memori belajar | Agent 6 |
| Membaca memori dalam percakapan | Agent 1 |
| Pemeriksaan isi memori | Agent 5 |
| Audit dan eskalasi; reset/hapus perlu Alvin | Agent 12 |

## Template spesifikasi agent

Saat sebuah agent mulai dibangun, buat berkas `agents/NN-nama.md` dengan bagian: tujuan, input, output, alat yang boleh dipakai, kewenangan dan batas, kasus ambigu, metrik keberhasilan, dan log versi.
