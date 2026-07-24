# SDD — Software Design Document
## Aplikasi Pencatat Pengeluaran Pribadi (Flutter)

## 1. Arsitektur Umum
Aplikasi mobile Flutter, **offline-first**, tanpa backend/server. Semua data disimpan di database lokal (SQLite via Drift) di dalam HP. Menggunakan pola **layered architecture** sederhana:

```
UI Layer (Widgets/Screens)
   ↓ ↑
State Management Layer (Riverpod Providers/Notifiers)
   ↓ ↑
Repository Layer (business logic: hitung saldo, gabung history, dsb)
   ↓ ↑
Data Layer (Drift/SQLite — tabel Transaksi, Kategori, HistorySaldoAkhir)
```

## 2. Tech Stack

| Kebutuhan | Pilihan | Alasan |
|---|---|---|
| Framework | Flutter (Dart) | Cross-platform, bisa langsung sideload APK ke Android |
| Local Database | Drift (SQLite) | Type-safe, mendukung query relasional & agregasi (total per kategori, dsb) |
| State Management | Riverpod | Modern, reactive, gampang di-test |
| Export Excel | package `excel` | Generate file .xlsx dengan kontrol penuh atas kolom, warna, format |
| Format tanggal/angka | package `intl` | Format Rupiah & tanggal Indonesia (dd/MM/yyyy) |
| Akses file & share | `path_provider`, `permission_handler`, `share_plus` | Simpan & bagikan hasil export |
| Notifikasi (opsional) | `flutter_local_notifications` | Untuk reminder harian (nice-to-have, iterasi berikutnya) |
| Ikon | `lucide_icons` | Sesuai gaya line-icon yang ditentukan di Design.md §8 |

### 2.1 Font (offline, bundled — bukan google_fonts)
Font (Fraunces, Plus Jakarta Sans, IBM Plex Mono) di-bundle langsung sebagai file lokal di `assets/fonts/`, didaftarkan di `pubspec.yaml` lewat `fonts:`. Pendekatan ini dipilih daripada package `google_fonts` supaya tampilan tetap konsisten walau HP belum pernah terkoneksi internet saat pertama kali app dibuka (offline-first, sesuai kebutuhan non-fungsional di PRD §8).

## 3. Skema Database

### Tabel `kategori`
| Kolom | Tipe | Keterangan |
|---|---|---|
| id | int (PK, autoincrement) | |
| nama | text | Nilai tetap: K - Operasional, K - Material, Listrik, Keperluan kantor, Keperluan mess, ATK, Perlengkapan Kantor, Perawatan Kendaraan, Pantry |

Di-seed sekali saat pertama kali aplikasi dijalankan (first-run migration).

### Tabel `transaksi`
| Kolom | Tipe | Keterangan |
|---|---|---|
| id | int (PK, autoincrement) | |
| tanggal | DateTime | Tanggal transaksi |
| kategori_id | int (FK → kategori.id) | |
| uraian | text | Deskripsi bebas |
| pemasukan | double (nullable/default 0) | |
| pengeluaran | double (nullable/default 0) | |
| saldo_setelah | double | Saldo berjalan tepat setelah transaksi ini disimpan (snapshot, memudahkan render tanpa re-kalkulasi tiap saat) |
| dibuat_pada | DateTime | Timestamp pencatatan (audit) |

### Tabel `history_saldo_akhir`
| Kolom | Tipe | Keterangan |
|---|---|---|
| id | int (PK, autoincrement) | |
| tanggal_periode | DateTime | Tanggal transaksi terakhir sebelum reset (tanggal lengkap, bukan cuma tahun) |
| saldo_akhir | double | Saldo akhir final periode tsb (boleh negatif) |
| dicatat_pada | DateTime | Timestamp saat reset dilakukan |

### Tabel `sesi_aktif` (single-row config, menyimpan status periode berjalan)
| Kolom | Tipe | Keterangan |
|---|---|---|
| id | int (selalu 1) | |
| saldo_awal_input | double | Nominal saldo awal yang diinput manual di awal periode ini |
| saldo_mulai | double | Hasil penjumlahan saldo_awal_input + saldo_akhir history terakhir (titik awal periode berjalan) |
| sudah_diisi | bool | Apakah saldo awal periode ini sudah diisi (menentukan app langsung ke Home atau tampilkan form Saldo Awal) |

## 4. Logika Perhitungan Saldo

### 4.1 Saat mengisi Saldo Awal (mulai periode baru)
```
saldo_akhir_terakhir = SELECT saldo_akhir FROM history_saldo_akhir ORDER BY dicatat_pada DESC LIMIT 1
                       (0 jika belum ada history sama sekali — first run)

saldo_mulai = saldo_awal_input + saldo_akhir_terakhir
```
Ini murni penjumlahan bertanda: kalau `saldo_akhir_terakhir` negatif, otomatis mengurangi; kalau positif, otomatis menambah. Tidak ada logika kondisional tambahan.

**Catatan UI**: `saldo_mulai` dihitung dan ditampilkan sebagai preview **secara real-time** di ScreenSaldoAwal begitu pengguna mengetik nominal Saldo Awal (listener pada input field, bukan menunggu tombol submit ditekan) — lihat Design.md §5.2. Nilai ini baru benar-benar disimpan ke tabel `sesi_aktif` setelah tombol "Mulai Periode Ini" ditekan.

### 4.2 Saat mencatat transaksi baru
```
saldo_baru = saldo_terakhir_saat_ini - pengeluaran
```
Transaksi harian dari form Tambah Transaksi hanya berupa **Pengeluaran** (kolom `pemasukan` pada tabel `transaksi` tidak dipakai lagi untuk input harian — tetap ada di skema untuk kompatibilitas/masa depan, tapi selalu 0 pada baris transaksi biasa). `saldo_terakhir_saat_ini` diambil dari transaksi terakhir yang tersimpan (`saldo_setelah`), atau dari `saldo_mulai` kalau ini transaksi pertama di periode berjalan. Tidak ada validasi yang menolak saldo negatif.

### 4.3 Saat edit atau hapus transaksi
Transaksi individual bisa diedit (ubah tanggal/kategori/uraian/nominal) atau dihapus dari layar detail (dibuka lewat tap baris transaksi, lihat Design.md §5.1). Karena tiap baris menyimpan snapshot `saldo_setelah`, operasi ini butuh **recalculate berantai**:
```
edit/hapus transaksi X →
  ambil saldo_setelah dari transaksi tepat SEBELUM X (atau saldo_mulai kalau X transaksi pertama)
  → hitung ulang saldo_setelah untuk X (kalau diedit, bukan dihapus)
  → lanjut hitung ulang saldo_setelah untuk SEMUA transaksi SESUDAH X, berurutan dari yang terlama
  → simpan semua perubahan, notify provider agar Home rebuild
```
Ini memastikan saldo berjalan tetap konsisten sepanjang riwayat, tidak cuma di baris yang diedit/dihapus.

### 4.4 Saat reset
```
saldo_akhir_final = saldo_setelah dari transaksi terakhir (atau saldo_mulai kalau belum ada transaksi sama sekali)
tanggal_periode   = tanggal dari transaksi terakhir (atau hari ini kalau belum ada transaksi)

INSERT INTO history_saldo_akhir (tanggal_periode, saldo_akhir, dicatat_pada)
DELETE FROM transaksi (semua baris)
RESET sesi_aktif.sudah_diisi = false
```

## 5. Alur Data (Sequence)

### 5.1 Membuka aplikasi
```
main() → inisialisasi database →
  cek sesi_aktif.sudah_diisi
    false → tampilkan ScreenSaldoAwal
    true  → tampilkan ScreenHome
```

### 5.2 Input transaksi
```
User isi form → validasi input (tanggal wajib, kategori wajib, salah satu dari pemasukan/pengeluaran wajib diisi)
  → repository.tambahTransaksi()
    → hitung saldo_setelah
    → simpan ke tabel transaksi
    → notify Riverpod provider → UI (Home) rebuild otomatis
```

### 5.3 Export
```
User tekan Export → repository.ambilDataUntukExport()
  → ambil: history terakhir (baris referensi "SALDO AKHIR PER [tanggal]"), sesi_aktif
    (baris "PEMASUKAN DARI FINANCE"), semua transaksi, total agregat
  → ExcelService.generateXlsx(data) → susun baris SESUAI URUTAN INI (wajib, jangan dilewati
    salah satunya):
      1. Header kolom (biru)
      2. Baris referensi "SALDO AKHIR PER [tanggal periode sebelumnya]" — dari
         history_saldo_akhir terakhir (skip baris ini kalau history masih kosong / first run).
         **Bukan baris transaksi**: No dikosongkan, sel Tanggal-sampai-Uraian di-MERGE jadi
         satu sel berisi teks label ini, Pemasukan & Pengeluaran dikosongkan, hanya kolom Saldo
         diisi nominal. Background hijau muda.
      3. Baris "PEMASUKAN DARI FINANCE" (hijau muda) — dari sesi_aktif. Format sel sama seperti
         poin 2 (No kosong, merge Tanggal-Uraian, Pengeluaran kosong), kolom Pemasukan diisi
         nominal saldo awal, kolom Saldo diisi hasil penjumlahan.
      4. Baris-baris transaksi (urut tanggal) — baris normal, No terisi nomor urut, tiap kolom
         terisi sesuai field masing-masing (bukan merge).
      5. Baris total "SALDO AKHIR PER [tanggal transaksi terakhir]" (kuning) — format sel sama
         seperti poin 2 (No kosong, merge Tanggal-Uraian), kolom Pemasukan = Total Pemasukan,
         Pengeluaran = Total Pengeluaran, Saldo = Saldo Akhir final.

  **Format angka Rupiah**: semua sel di kolom Pemasukan, Pengeluaran, dan Saldo memakai custom
  number format Excel, BUKAN angka polos. Set `CellStyle.numberFormat` (atau setara di package
  `excel`) ke pola custom sejenis `"Rp" #,##0;-"Rp" #,##0` — supaya nilai tersimpan tetap berupa
  angka murni (bisa dihitung ulang di Excel/Sheets kalau perlu), tapi TAMPILANNYA otomatis jadi
  `Rp 5.000.000` atau `-Rp 1.246.000` untuk nilai negatif. Jangan format manual jadi string teks
  ("Rp " + angka.toString()) karena itu akan merusak tipe data sel (jadi teks, bukan angka) dan
  bikin kolom Saldo tidak bisa dihitung ulang / auto-sum di Excel.
  → simpan ke path Download dengan nama file `Laporan_Pengeluaran_[dd-MM-yyyy].xlsx`
    (contoh: `Laporan_Pengeluaran_23-07-2026.xlsx`, tanggal mengikuti tanggal saat export dilakukan)
  → tampilkan opsi share
```

### 5.4 Reset
```
User tekan Reset → dialog konfirmasi ("Sudah export? Yakin reset?")
  → repository.resetPeriode()
    → insert ke history_saldo_akhir
    → hapus semua transaksi
    → set sesi_aktif.sudah_diisi = false
  → navigasi ke ScreenSaldoAwal
```

## 6. Struktur Folder Proyek (disarankan)
```
lib/
  main.dart
  data/
    database.dart              # setup Drift
    tables/
      kategori_table.dart
      transaksi_table.dart
      history_saldo_akhir_table.dart
      sesi_aktif_table.dart
  repositories/
    transaksi_repository.dart
    saldo_repository.dart
    export_repository.dart
  providers/                   # Riverpod
    saldo_provider.dart
    transaksi_provider.dart
    history_provider.dart
  screens/
    saldo_awal_screen.dart
    home_screen.dart
    tambah_transaksi_screen.dart
    export_preview_screen.dart
    history_screen.dart
  widgets/
    saldo_card.dart
    transaksi_tile.dart
    kategori_dropdown.dart
  services/
    excel_export_service.dart
  utils/
    formatters.dart            # format Rupiah & tanggal Indonesia
  theme/
    app_theme.dart
assets/
  fonts/
    Fraunces/                  # file .ttf, di-bundle offline
    PlusJakartaSans/
    IBMPlexMono/
```

## 7. Penanganan Error & Edge Case
- **Belum ada history sama sekali (first run)**: `saldo_akhir_terakhir` dianggap 0, saldo mulai = saldo awal input murni.
- **Saldo minus**: dibiarkan, tidak ada blocking validation, tapi UI menampilkan warna berbeda (merah) untuk memberi sinyal visual (lihat Design.md).
- **Reset tanpa transaksi sama sekali**: tetap boleh reset — saldo akhir final = saldo_mulai, tanggal_periode = tanggal hari ini.
- **Export gagal (permission storage ditolak)**: tampilkan dialog error, arahkan ke pengaturan izin aplikasi.
- **Kategori kosong/tidak dipilih**: tombol simpan transaksi disabled sampai kategori dipilih.