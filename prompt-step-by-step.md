# prompt-step-by-step.md — Prompt Bertahap per Milestone (dengan mode Plan/Build)

Cara pakai: jalankan milestone **satu per satu, sesuai urutan**. Tiap milestone punya dua versi prompt:

- **🅰️ Mode PLAN** — agent cuma menjelaskan rencananya (file apa yang akan dibuat/diubah, pendekatan teknisnya) TANPA menulis kode. Pakai ini kalau kamu mau review dulu sebelum agent benar-benar coding — berguna terutama untuk milestone yang lebih kompleks (3, 4, 5).
- **🅱️ Mode BUILD** — agent langsung menulis kode sesuai spesifikasi. Pakai ini kalau kamu sudah yakin/sudah pernah review rencananya (baik lewat mode PLAN sebelumnya, atau karena milestone-nya cukup sederhana).

**Rekomendasi:** untuk milestone 1, 2, dan 6 (relatif sederhana/mekanis), boleh langsung ke mode BUILD. Untuk milestone 3, 4, dan 5 (logika lebih rumit: recalculate saldo, export Excel, reset+history), sebaiknya jalankan mode PLAN dulu, baca rencananya, baru lanjut mode BUILD di milestone yang sama.

Jangan kasih prompt milestone berikutnya sebelum milestone sekarang selesai dan sudah kamu tes/konfirmasi. Pastikan `PRD.md`, `SDD.md`, `Design.md`, dan `Agents.md` sudah ada di root folder project sebelum mulai Milestone 0.

---

## Milestone 0 — Orientasi (wajib dijalankan pertama, sekali saja, tidak ada pilihan mode)

```
Kamu adalah Flutter developer yang akan membangun aplikasi pencatat pengeluaran pribadi ini
secara BERTAHAP, per milestone, mengikuti instruksi yang saya kasih satu per satu.

Sebelum mulai apa pun, baca file berikut secara berurutan dan pahami isinya:
1. Agents.md — panduan kerja & batasanmu sebagai agent
2. PRD.md — kebutuhan produk
3. SDD.md — desain teknis, skema database, dan alur data
4. Design.md — spesifikasi tampilan (warna, tipografi, layout, micro-interaction)

Setelah selesai membaca, jangan menulis kode apa pun dulu. Cukup balas dengan ringkasan
singkat (5-8 poin) yang menunjukkan kamu sudah paham: apa aplikasinya, tech stack-nya apa,
dan bagaimana alur perhitungan saldo bekerja. Saya akan konfirmasi dulu sebelum kamu lanjut
ke Milestone 1.
```

---

## Milestone 1 — Setup Project & Database

### 🅰️ Mode PLAN
```
Sebelum coding, jelaskan dulu rencanamu untuk Milestone 1: Setup Project & Database.

Sebutkan: dependency apa saja yang akan kamu tambahkan ke pubspec.yaml (sesuai SDD.md §2),
struktur folder lib/ yang akan kamu buat (sesuai SDD.md §6), dan bagaimana kamu akan
mendefinisikan skema Drift untuk 4 tabel di SDD.md §3 (kategori, transaksi,
history_saldo_akhir, sesi_aktif) beserta seed data 9 kategori dari PRD §7.5.

Jangan menulis kode dulu. Tunggu saya konfirmasi rencana ini sebelum lanjut ke mode BUILD.
```

### 🅱️ Mode BUILD
```
Lanjut ke Milestone 1: Setup Project & Database — mode BUILD.

Kerjakan HANYA hal berikut, jangan menyentuh bagian UI/layar dulu:
1. Tambahkan semua dependency yang dibutuhkan ke pubspec.yaml sesuai SDD.md §2
   (drift, riverpod, excel, intl, path_provider, permission_handler, share_plus, lucide_icons,
   dan siapkan struktur assets/fonts/ sesuai SDD.md §2.1 — untuk font-nya, gunakan placeholder
   dulu kalau file font aslinya belum saya kasih, tapi tetap daftarkan strukturnya di pubspec.yaml).
2. Buat struktur folder lib/ sesuai SDD.md §6.
3. Buat skema database Drift sesuai SDD.md §3: tabel kategori, transaksi, history_saldo_akhir,
   dan sesi_aktif — persis sesuai kolom yang didefinisikan di sana.
4. Buat migration/seed data kategori (9 kategori tetap dari PRD §7.5) yang jalan otomatis saat
   pertama kali aplikasi dibuka.

Setelah selesai, jelaskan:
- File apa saja yang kamu buat/ubah
- Cara saya mengetesnya (perintah apa yang saya jalankan untuk memastikan database & seed
  kategori sudah benar, tanpa perlu UI dulu)

Jangan lanjut ke Milestone 2 sebelum saya konfirmasi.
```

---

## Milestone 2 — Layar Saldo Awal

### 🅰️ Mode PLAN
```
Sebelum coding, jelaskan dulu rencanamu untuk Milestone 2: Layar Saldo Awal.

Sebutkan: widget/file apa yang akan kamu buat untuk ScreenSaldoAwal (Design.md §5.2), bagaimana
kamu akan implementasi preview real-time "Saldo mulai periode ini" (listener di input field,
sesuai SDD.md §4.1), dan bagaimana routing awal di main.dart menentukan tampil ke Home atau
ke layar ini berdasarkan sesi_aktif.sudah_diisi (SDD.md §5.1).

Jangan menulis kode dulu. Tunggu saya konfirmasi rencana ini sebelum lanjut ke mode BUILD.
```

### 🅱️ Mode BUILD
```
Lanjut ke Milestone 2: Layar Saldo Awal — mode BUILD.

Bangun HANYA layar ini dulu:
1. ScreenSaldoAwal sesuai Design.md §5.2 (kartu "amplop" di tengah, referensi saldo akhir
   periode lalu ditampilkan redup kalau ada, input nominal besar dengan format Rupiah otomatis,
   tombol "Mulai Periode Ini").
2. Logika perhitungan saldo_mulai sesuai SDD.md §4.1 (saldo_awal_input + saldo_akhir_terakhir,
   penjumlahan bertanda biasa), termasuk **preview real-time**: begitu pengguna mengetik nominal
   di field Saldo Awal, tampilkan pill kecil "Saldo mulai periode ini" dengan hasil penjumlahan
   yang ter-update otomatis (listener pada input, bukan menunggu submit) — lihat Design.md §5.2.
3. Logika di main.dart / routing: kalau sesi_aktif.sudah_diisi masih false, tampilkan layar ini
   duluan (SDD.md §5.1). Untuk sementara, setelah tombol "Mulai Periode Ini" ditekan, cukup
   tampilkan halaman kosong/placeholder "Home (belum dibuat)" — Home baru dibangun di
   Milestone 3.

Terapkan token warna & tipografi dari Design.md (jangan pakai Material Design default).

Setelah selesai, jelaskan cara saya mengetesnya di emulator. Jangan lanjut ke Milestone 3
sebelum saya konfirmasi.
```

---

## Milestone 3 — Layar Home & Input Transaksi

### 🅰️ Mode PLAN (disarankan dijalankan dulu — milestone paling kompleks)
```
Sebelum coding, jelaskan dulu rencanamu untuk Milestone 3: Layar Home & Input Transaksi.

Sebutkan: struktur widget ScreenHome (Design.md §5.1) — Saldo Card, baris referensi, list
ledger; struktur bottom sheet Tambah Transaksi (Design.md §5.3) — toggle, chip kategori, form;
bagaimana provider Riverpod akan mengatur state saldo berjalan supaya UI auto-update;
dan yang paling penting: bagaimana kamu akan implementasi logika recalculate berantai saat
edit/hapus transaksi sesuai SDD.md §4.3 — jelaskan pseudocode/alurnya sebelum menulis kode
sungguhan.

Jangan menulis kode dulu. Tunggu saya konfirmasi rencana ini sebelum lanjut ke mode BUILD.
```

### 🅱️ Mode BUILD
```
Lanjut ke Milestone 3: Layar Home & Input Transaksi — mode BUILD (bagian paling inti dari
aplikasi ini).

Bangun:
1. ScreenHome sesuai Design.md §5.1: Saldo Card dengan gradient & "stempel AMAN/DEFISIT",
   baris referensi "SALDO AKHIR PER [tanggal]", list transaksi bergaya ledger (garis tipis,
   dot warna kategori), FAB tambah transaksi.
2. Bottom sheet Tambah Transaksi sesuai Design.md §5.3: toggle Pemasukan/Pengeluaran, chip
   kategori (9 kategori), field Uraian, date picker Tanggal.
3. Logika hitung saldo_setelah tiap transaksi baru sesuai SDD.md §4.2 (boleh minus, tanpa
   validasi blocking).
4. Layar/dialog Detail Transaksi: tap satu baris transaksi → bisa edit atau hapus, dengan
   logika recalculate berantai sesuai SDD.md §4.3 (saldo_setelah semua transaksi sesudahnya
   ikut dihitung ulang).
5. State management pakai Riverpod sesuai SDD.md — begitu ada transaksi baru/edit/hapus,
   Saldo Card & list di Home harus otomatis update (termasuk animasi count-up/count-down
   singkat sesuai Design.md §6).

Setelah selesai, jelaskan cara saya mengetes alur: isi saldo awal → tambah beberapa transaksi
→ cek saldo berubah dengan benar → coba edit satu transaksi di tengah → cek saldo sesudahnya
ikut ter-update. Jangan lanjut ke Milestone 4 sebelum saya konfirmasi semua ini bekerja benar.
```

---

## Milestone 4 — Export ke Excel

### 🅰️ Mode PLAN (disarankan dijalankan dulu)
```
Sebelum coding, jelaskan dulu rencanamu untuk Milestone 4: Export ke Excel.

Sebutkan: bagaimana struktur ScreenExportPreview akan meniru layout Excel asli (header biru,
baris hijau, baris kuning — PRD.md §7.4), bagaimana ExcelService akan menyusun data dari
database ke format .xlsx pakai package `excel`, dan bagaimana kamu akan handle permission
storage + penamaan file (SDD.md §5.3).

Jangan menulis kode dulu. Tunggu saya konfirmasi rencana ini sebelum lanjut ke mode BUILD.
```

### 🅱️ Mode BUILD
```
Lanjut ke Milestone 4: Export ke Excel — mode BUILD.

Bangun:
1. ScreenExportPreview sesuai Design.md §5.4: preview tabel mirip Excel asli (header biru,
   baris hijau saldo awal, baris kuning total) sebelum file benar-benar dibuat.
2. ExcelService sesuai SDD.md §5.3: generate file .xlsx dengan kolom No, Tanggal, Keterangan,
   Uraian, Pemasukan, Pengeluaran, Saldo — layout & warna semirip mungkin dengan deskripsi di
   PRD.md §7.4.
3. Nama file: Laporan_Pengeluaran_[dd-MM-yyyy].xlsx (SDD.md §5.3), disimpan ke folder Download
   HP, dengan opsi share (share_plus) setelah berhasil dibuat.
4. Handle permission storage (kalau ditolak, tampilkan dialog error mengarahkan ke pengaturan
   izin — SDD.md §7).

Setelah selesai, jelaskan cara saya mengetes: export dengan beberapa transaksi dummy, buka
file .xlsx hasilnya, cek apakah formatnya sesuai. Jangan lanjut ke Milestone 5 sebelum saya
konfirmasi file export-nya benar.
```

---

## Milestone 5 — Reset & History Saldo Akhir

### 🅰️ Mode PLAN (disarankan dijalankan dulu)
```
Sebelum coding, jelaskan dulu rencanamu untuk Milestone 5: Reset & History Saldo Akhir.

Sebutkan: bagaimana dialog konfirmasi Reset akan bekerja (Design.md §5.6), urutan operasi
saat reset dieksekusi sesuai SDD.md §4.4 (hitung saldo akhir final → simpan ke history →
hapus transaksi → set sudah_diisi = false → navigasi balik ke ScreenSaldoAwal), dan struktur
ScreenHistory (Design.md §5.5).

Jangan menulis kode dulu. Tunggu saya konfirmasi rencana ini sebelum lanjut ke mode BUILD.
```

### 🅱️ Mode BUILD
```
Lanjut ke Milestone 5: Reset & History Saldo Akhir — mode BUILD.

Bangun:
1. Dialog konfirmasi Reset sesuai Design.md §5.6 (ikon stempel besar, teks peringatan,
   tombol Batal/Ya Reset).
2. Logika reset sesuai SDD.md §4.4: hitung saldo_akhir_final, simpan ke history_saldo_akhir
   dengan tanggal_periode lengkap, hapus semua transaksi, set sesi_aktif.sudah_diisi = false,
   lalu navigasi balik ke ScreenSaldoAwal (yang otomatis menampilkan referensi saldo akhir
   baru ini, sesuai Milestone 2).
3. ScreenHistory sesuai Design.md §5.5: daftar kartu tiap periode (tanggal, nominal saldo
   akhir, stempel AMAN/DEFISIT), diakses lewat ikon di AppBar Home (PRD.md §7.9 — tanpa
   bottom navigation).

Setelah selesai, jelaskan cara saya mengetes siklus penuh: catat beberapa transaksi → export
→ reset → cek muncul di History → isi saldo awal baru → cek perhitungannya benar mengikuti
contoh di PRD.md §7.1. Jangan lanjut ke Milestone 6 sebelum saya konfirmasi.
```

---

## Milestone 6 — Polish UI & Micro-interaction

### 🅰️ Mode PLAN (opsional — milestone ini relatif sederhana, boleh langsung BUILD)
```
Sebelum coding, jelaskan dulu rencanamu untuk Milestone 6: Polish UI & Micro-interaction.

Sebutkan bagian mana saja yang menurutmu masih belum sepenuhnya konsisten dengan Design.md
(warna, tipografi, ikon, animasi) berdasarkan hasil Milestone 1-5 sejauh ini, dan apa yang
akan kamu perbaiki.

Jangan menulis kode dulu. Tunggu saya konfirmasi rencana ini sebelum lanjut ke mode BUILD.
```

### 🅱️ Mode BUILD
```
Lanjut ke Milestone 6 (milestone terakhir): Polish UI & Micro-interaction — mode BUILD.

Sekarang semua fitur inti sudah jalan, fokus ke detail visual dan interaksi sesuai Design.md
secara menyeluruh:
1. Pastikan seluruh palet warna, tipografi (Fraunces/Plus Jakarta Sans/IBM Plex Mono), dan
   ikon lucide_icons sudah konsisten dipakai di semua layar (Design.md §2, §3, §8) — bukan
   cuma di Home.
2. Terapkan animasi count-up/count-down saldo dan stamp bounce sesuai Design.md §6, kalau
   belum sepenuhnya diterapkan di Milestone 3.
3. Cek ulang aksesibilitas dasar sesuai Design.md §7 (kontras teks, ukuran target sentuh
   minimal 48x48dp, warna tidak jadi satu-satunya penanda status).
4. Cek ulang bahwa tidak ada tampilan Material Design default yang generik tersisa
   (Agents.md §4).

Setelah selesai, jelaskan ringkasan akhir: fitur apa saja yang sudah lengkap sesuai PRD.md,
dan langkah untuk build APK release (flutter build apk --release) untuk saya sideload ke HP.
```

---

### Catatan
- Kalau di tengah satu milestone agent butuh info yang belum jelas dari dokumen, minta dia bertanya dulu — jangan biarkan dia menebak sendiri (lihat Agents.md §1).
- Kalau rencana di mode PLAN ternyata kurang pas, koreksi dulu lewat percakapan biasa sebelum masuk ke mode BUILD — jangan biarkan agent lanjut coding dengan rencana yang belum benar.
- Kalau satu milestone hasil BUILD-nya ternyata kurang pas, minta perbaikan dulu di milestone yang sama sebelum lanjut — jangan lompat ke milestone berikutnya dengan fondasi yang belum benar.