# Design.md — Spesifikasi Desain UI/UX
## Aplikasi Pencatat Pengeluaran Pribadi

## 1. Arah Desain: "Buku Kas Digital"
Aplikasi ini pada dasarnya menggantikan buku kas/Excel manual, jadi konsep visualnya diangkat dari budaya **pembukuan kantor Indonesia** — bukan tema "fintech generik" biasa. Elemen seperti stempel tanggal, garis ledger, dan angka yang rapi sejajar (seperti kolom Excel) jadi identitas visual utama, dibalut dengan sentuhan modern supaya tetap terasa premium dan "memanjakan mata", bukan kaku seperti spreadsheet.

## 2. Palet Warna
| Nama | Hex | Fungsi |
|---|---|---|
| Ink Navy | `#101A2E` | Warna dasar header, app bar, teks utama pada saldo card |
| Ledger Cream | `#F7F3EA` | Background utama layar (nuansa kertas) |
| Emerald Pulse | `#1FA97F` | Aksen utama, Pemasukan, saldo positif, tombol utama |
| Signal Coral | `#E85C4A` | Pengeluaran, saldo negatif, peringatan reset |
| Gold Stamp | `#D9A441` | Aksen "stempel" saldo awal, highlight badge, ikon kategori aktif |
| Slate Grey | `#5B6472` | Teks sekunder, garis pembatas antar baris transaksi |

Gradasi khusus untuk Saldo Card: `linear-gradient(135deg, #101A2E 0%, #1B3A4B 60%, #1FA97F 130%)` — transisi dari navy gelap ke emerald, memberi kesan "dari gelap ke terang" sesuai naik-turunnya saldo.

## 3. Tipografi
| Peran | Font | Alasan |
|---|---|---|
| Display (judul, nominal saldo besar) | **Fraunces** (serif, weight 600–900) | Karakter tebal & sedikit "berat" seperti tinta stempel/cap kantor, beda dari sans-serif generik |
| Body (label form, uraian, teks umum) | **Plus Jakarta Sans** | Bersih, modern, sangat mudah dibaca di layar kecil |
| Data/Angka (nominal, tanggal, kolom saldo) | **IBM Plex Mono** (tabular figures) | Angka sejajar rapi seperti kolom Excel — krusial supaya deretan nominal Rupiah enak dipindai mata |

Skala tipe: Display besar 40sp (saldo utama) → Display sedang 24sp (judul layar) → Body 16sp → Caption 13sp → Mono data 15sp dengan letter-spacing sedikit lebar (+0.5) biar angka terasa presisi.

## 4. Elemen Tanda Tangan (Signature Element): "Stempel Saldo"
Di pojok kanan atas Saldo Card, ada **badge bundar mirip stempel kantor** (rotasi -8°, border ganda tipis, teks kapital) yang otomatis berganti isi & warna sesuai kondisi saldo:
- Saldo ≥ 0 → stempel warna Emerald, teks **"AMAN"**
- Saldo < 0 → stempel warna Coral, teks **"DEFISIT"**

Stempel ini juga muncul di riwayat History Saldo Akhir, menandai tiap periode yang pernah "ditutup" — memberi kesan otentik seperti dokumen yang benar-benar sudah diperiksa/disahkan.

## 5. Layout per Layar

### 5.1 Home
```
┌──────────────────────────────┐
│  [Ink Navy → Emerald grad]   │
│  Saldo Berjalan               │  ← Display font, 40sp, putih
│  Rp 3.754.000        (AMAN)⚈ │  ← stempel di pojok
│  ↑ Pemasukan Rp5.000.000       │  ← caption kecil, dua kolom
│  ↓ Pengeluaran Rp4.741.000     │
└──────────────────────────────┘
  SALDO AKHIR PER 14 Juli 2026   ← baris referensi, italic, Slate
──────────────────────────────────
  15/07  Pantry            -64rb  ← baris ledger, garis tipis Slate
  16/07  K-Operasional     -20rb     bawah tiap baris (bukan card
  16/07  K-Operasional    -200rb     penuh — biar terasa "ledger")
  ...
──────────────────────────────────
                    [ + ]  ← FAB bundar Gold, shadow lembut
```
- List transaksi memakai **garis pembatas tipis** (bukan card bertumpuk) supaya nuansa "buku besar" tetap terasa, tapi tetap modern lewat spacing lega dan warna kategori sebagai aksen kecil (dot warna di kiri tiap baris, konsisten per kategori).
- Tap baris transaksi → buka detail/edit.

### 5.2 Form Saldo Awal (muncul di awal / setelah reset)
- Layar penuh, background Ledger Cream, dengan kartu "amplop" di tengah: menampilkan Saldo Akhir periode lalu (kalau ada) sebagai referensi redup, lalu input besar untuk Saldo Awal baru dengan keypad angka custom (format otomatis jadi "Rp 5.000.000" saat mengetik).
- Di bawah input Saldo Awal, ada baris preview kecil bergaya "pill" (background abu lembut) yang menampilkan **"Saldo mulai periode ini"** — hasil penjumlahan real-time (Saldo Awal + Saldo Akhir sebelumnya, sesuai rumus di SDD.md §4.1), ter-update otomatis begitu pengguna mengetik nominal Saldo Awal, sebelum tombol konfirmasi ditekan. Ini memberi kepastian visual ke pengguna sebelum memulai periode baru.
- Tombol "Mulai Periode Ini" (Emerald, full-width, rounded).

### 5.3 Tambah Transaksi
- Bottom sheet (bukan halaman penuh) supaya cepat diisi tanpa kehilangan konteks Home di belakang.
- Toggle switch besar "Pemasukan / Pengeluaran" di atas (default Pengeluaran, karena lebih sering dipakai), warna toggle berubah Emerald/Coral sesuai pilihan.
- Dropdown Kategori bergaya "chip" (bisa juga grid pilihan chip warna-warni sesuai 9 kategori) agar lebih cepat dipilih dibanding dropdown biasa.
- Field Uraian & Tanggal (date picker bergaya kalender minimal).
- Tombol "Simpan Transaksi".

### 5.4 Preview & Export
- Menampilkan preview tabel (mirip tampilan Excel asli: header biru, baris hijau saldo awal, baris kuning total) sebelum file benar-benar dibuat — supaya pengguna yakin formatnya benar sebelum export.
- Tombol "Export ke Excel" dan "Bagikan".

### 5.5 History Saldo Akhir
- Daftar kartu kecil per periode: tanggal, nominal saldo akhir, stempel AMAN/DEFISIT — disusun seperti "kartu arsip" bertumpuk, scroll vertikal.

### 5.6 Reset (dialog konfirmasi)
- Modal dengan ikon stempel besar, teks tegas: "Pastikan sudah export laporan. Reset akan mengosongkan transaksi periode ini." Tombol "Batal" (netral) dan "Ya, Reset" (Coral).

## 6. Mikro-interaksi & Motion
- **Saat saldo berubah** (baru simpan transaksi): angka pada Saldo Card melakukan animasi "count-up/count-down" singkat (300ms) ke nilai baru — memberi umpan balik jelas tanpa berlebihan.
- **Stempel "AMAN/DEFISIT"**: transisi warna dengan sedikit efek "stamp bounce" (scale 0.9→1.05→1) saat pertama muncul/berubah status.
- **FAB tambah transaksi**: saat ditekan, bottom sheet naik dengan easing halus (curve `easeOutCubic`), bukan langsung muncul instan.
- Animasi dijaga minim & bertujuan — tidak ada efek dekoratif berlebihan yang mengganggu kecepatan input (ingat: tujuan utamanya input transaksi < 15 detik).

## 7. Aksesibilitas & Kualitas Dasar
- Kontras teks di atas gradient Saldo Card dijaga minimal rasio 4.5:1 (teks putih di atas Ink Navy/Emerald sudah memenuhi).
- Semua tombol & target sentuh minimal 48x48dp.
- Mendukung font scaling sistem Android (tidak fixed pixel yang memaksa).
- Warna bukan satu-satunya penanda status (Emerald/Coral juga disertai label teks "AMAN"/"DEFISIT" dan ikon panah ↑/↓) — ramah untuk buta warna.

## 8. Ikonografi
- Gaya ikon: **line icon** tipis (bukan filled solid) memakai `lucide` icon set — konsisten dengan estetika "ledger" yang bersih. Ikon kategori: kopi/pantry (cangkir), operasional (koper), listrik (petir), kantor (map-pin/gedung), ATK (pensil), kendaraan (mobil).
