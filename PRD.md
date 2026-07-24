# PRD — Aplikasi Pencatat Pengeluaran Pribadi

## 1. Ringkasan Produk
Aplikasi mobile untuk pencatatan pengeluaran pribadi/operasional yang dipakai sendiri (bukan untuk publik), dijalankan secara **lokal** di HP tanpa perlu Play Store, dan hasil pencatatannya bisa diekspor ke file Excel (.xlsx) dengan format yang sudah baku (sesuai template yang sudah ada).

## 2. Latar Belakang & Masalah
Saat ini pencatatan pengeluaran dilakukan manual di Excel. Prosesnya kurang praktis saat transaksi terjadi di lapangan (misal saat perjalanan dinas, isi bensin, makan siang, dll) karena harus buka laptop/file Excel. Dibutuhkan cara mencatat yang cepat lewat HP, namun hasil akhirnya tetap harus bisa masuk ke format Excel yang sudah ada agar tidak mengubah alur pelaporan yang berjalan.

## 3. Tujuan
- Memudahkan pencatatan transaksi harian langsung dari HP.
- Saldo berjalan (real-time) selalu terlihat setiap kali mencatat transaksi.
- Data bisa diekspor ke Excel dengan format identik seperti sekarang, kapan saja dibutuhkan.
- Setelah laporan diekspor, data transaksi bisa direset agar pencatatan periode berikutnya mulai bersih, namun riwayat saldo akhir tetap tersimpan sebagai jejak historis.

## 4. Target Pengguna
Satu pengguna (pemilik aplikasi sendiri) — aplikasi single-user, tidak perlu sistem login/akun banyak pengguna.

## 5. Ruang Lingkup (In Scope)
- Pencatatan transaksi (tanggal, kategori, uraian, nominal pemasukan/pengeluaran).
- Perhitungan saldo berjalan otomatis.
- Input saldo awal periode, digabung dengan saldo akhir periode sebelumnya.
- Export ke file .xlsx sesuai format template.
- Reset data transaksi + penyimpanan riwayat saldo akhir (dengan tanggal lengkap).
- Riwayat/history saldo akhir dari semua periode sebelumnya.
- Instalasi lokal (sideload APK), tanpa Play Store.

## 6. Di Luar Ruang Lingkup (Out of Scope)
- Multi-user / sistem login.
- Sinkronisasi cloud otomatis (real-time) — tidak dipakai, cukup local storage + export manual.
- Publikasi ke Play Store / App Store.
- Approval/workflow pelaporan berjenjang.

## 7. Kebutuhan Fungsional (Functional Requirements)

### 7.1 Input Saldo Awal
- Saat pertama kali dibuka, atau setelah reset, pengguna **wajib** mengisi nominal "Saldo Awal" sebelum bisa mencatat transaksi. Nominal ini boleh diisi **0** (tombol tetap aktif) — tidak ada validasi minimum, karena boleh saja periode baru dimulai tanpa tambahan dana masuk.
- Saldo Awal ini dijumlahkan (penjumlahan bertanda / signed addition) dengan Saldo Akhir periode sebelumnya (jika ada di history) untuk menghasilkan saldo mulai periode berjalan.
  - Contoh: Saldo Akhir sebelumnya = -Rp1.246.000, Saldo Awal baru = Rp5.000.000 → Saldo mulai = Rp3.754.000.
  - Jika Saldo Akhir sebelumnya negatif, otomatis mengurangi; jika positif, otomatis menambah. Ini murni penjumlahan matematis biasa (tidak perlu pilihan manual tambah/kurang).
- Hasil penjumlahan ini ditampilkan sebagai **preview real-time** di layar input (lihat Design.md §5.2), ter-update begitu pengguna mengetik nominal Saldo Awal, sebelum tombol "Mulai Periode Ini" ditekan.

### 7.2 Pencatatan Transaksi
Setiap transaksi berisi:
- **Tanggal** (default hari ini, bisa diubah)
- **Kategori** (dropdown, daftar tetap — lihat 7.5)
- **Uraian** (teks bebas, deskripsi detail transaksi)
- **Nominal** — bisa masuk sebagai Pemasukan atau Pengeluaran
- Saldo berjalan otomatis ter-update setiap transaksi baru disimpan (saldo sebelumnya − pengeluaran + pemasukan).
- **Saldo boleh minus** — tidak ada validasi yang menolak/memblokir transaksi walau saldo jadi negatif.

### 7.3 Tampilan Riwayat Transaksi (Home)
- Daftar transaksi berjalan ditampilkan berurutan, mengikuti format tabel Excel: No, Tanggal, Keterangan (kategori), Uraian, Pemasukan, Pengeluaran, Saldo.
- Baris paling atas menampilkan referensi "SALDO AKHIR PER [tanggal terakhir]" dari periode sebelumnya (jika ada), lalu baris "PEMASUKAN DARI FINANCE" (saldo awal yang baru diinput + hasil penjumlahan).
- Baris ringkasan di bawah menampilkan Total Pemasukan, Total Pengeluaran, dan Saldo Akhir berjalan.
- Tap salah satu baris transaksi membuka layar detail, di mana transaksi tersebut bisa **diedit** (tanggal, kategori, uraian, nominal) atau **dihapus**. Saldo berjalan pada transaksi-transaksi sesudahnya otomatis dihitung ulang agar tetap konsisten.

### 7.4 Export ke Excel
- Tombol "Export" menghasilkan file .xlsx dengan struktur kolom & tata letak identik dengan template yang sudah ada (header biru, baris highlight hijau untuk saldo awal, baris kuning untuk total di akhir).
- Urutan baris di dalam file, persis sesuai template asli:
  1. Header kolom (No, Tanggal, Keterangan, Uraian, Pemasukan, Pengeluaran, Saldo) — background biru.
  2. Baris **"SALDO AKHIR PER [tanggal periode sebelumnya]"** — baris referensi dari `history_saldo_akhir` terakhir (kalau belum ada history sama sekali, baris ini boleh dilewati). Nominal saldo akhir sebelumnya ditampilkan di kolom Saldo.
  3. Baris **"PEMASUKAN DARI FINANCE"** — background hijau muda, nominal Saldo Awal yang diinput di kolom Pemasukan, hasil penjumlahan (saldo mulai periode) di kolom Saldo.
  4. Baris-baris transaksi berjalan, berurutan sesuai tanggal.
  5. Baris **"SALDO AKHIR PER [tanggal transaksi terakhir]"** — background kuning, berisi Total Pemasukan, Total Pengeluaran, dan Saldo Akhir final.
- File tersimpan ke folder Download HP, dengan nama `Laporan_Pengeluaran_[dd-MM-yyyy].xlsx` (contoh: `Laporan_Pengeluaran_23-07-2026.xlsx`), dan bisa langsung dibagikan (share) ke WhatsApp/Drive/Email.
- Catatan: belum ada file .xlsx asli sebagai rujukan pasti — layout warna/kolom mengikuti deskripsi & screenshot template yang sudah dibahas di dokumen ini. Kalau nanti hasilnya kurang pas dibanding template asli, akan disesuaikan ulang.

### 7.5 Kategori (daftar tetap, dropdown)
1. K - Operasional
2. K - Material
3. Listrik
4. Keperluan kantor
5. Keperluan mess
6. ATK
7. Perlengkapan Kantor
8. Perawatan Kendaraan
9. Pantry

(Daftar ini bisa ditambah di kemudian hari lewat halaman pengaturan/kategori, tapi untuk versi awal cukup daftar tetap di atas.)

### 7.6 Reset Periode
- Tombol "Reset" (dengan konfirmasi, mengingatkan "pastikan sudah export sebelum reset").
- Saat reset:
  1. Hitung Saldo Akhir final periode berjalan.
  2. Simpan ke **History Saldo Akhir** — nominal + tanggal lengkap (tanggal/bulan/tahun) transaksi terakhir.
  3. Hapus seluruh data transaksi periode berjalan.
  4. Kembali ke alur "Input Saldo Awal" (poin 7.1) untuk memulai periode baru.

### 7.7 Riwayat Saldo Akhir (History)
- Halaman terpisah menampilkan seluruh riwayat "SALDO AKHIR PER [tanggal]" dari semua reset yang pernah terjadi, sebagai jejak historis.

### 7.8 Pengingat Harian (Nice to Have — opsional, bukan prioritas utama)
- Notifikasi harian untuk mengingatkan mencatat pengeluaran. Bisa dikerjakan di iterasi berikutnya setelah fitur inti selesai.

### 7.9 Navigasi Antar Layar
Aplikasi ini sederhana (satu alur utama), sehingga **tidak menggunakan bottom navigation bar**. Home adalah layar utama; layar History (riwayat saldo akhir) dan Export diakses lewat ikon di AppBar Home.

## 8. Kebutuhan Non-Fungsional
- **Offline-first**: semua fitur inti (input, lihat saldo, export) harus berfungsi tanpa koneksi internet.
- **Instalasi**: APK di-sideload langsung ke HP pribadi, tanpa Play Store, tanpa proses verifikasi developer.
- **Data**: tersimpan lokal di database HP (tidak ada server backend).
- **Kompatibilitas**: Android (minimal versi yang didukung Flutter saat ini, disarankan Android 8.0 / API 26 ke atas).
- **Tampilan**: modern, enak dilihat, nyaman dipakai sehari-hari (lihat Design.md untuk detail visual).

## 9. Metrik Keberhasilan (untuk penggunaan pribadi)
- Waktu input satu transaksi < 15 detik.
- Hasil export .xlsx bisa langsung dipakai tanpa perlu diedit ulang manual.
- Tidak ada data hilang saat reset (history saldo akhir selalu tercatat).