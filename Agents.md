# Agents.md — Panduan untuk AI Coding Agent

Dokumen ini adalah instruksi kerja untuk agent (misalnya Claude Code, Cursor, atau agent lain) yang akan membangun aplikasi ini. Baca dokumen ini **sebelum** menulis kode apa pun.

## 1. Dokumen Rujukan (wajib dibaca urut sebelum mulai)
1. `PRD.md` — apa yang harus dibangun & kenapa (requirement produk).
2. `SDD.md` — bagaimana membangunnya secara teknis (arsitektur, skema database, alur data).
3. `Design.md` — bagaimana tampilannya (palet warna, tipografi, layout, micro-interaction).

Jangan mengasumsikan detail yang tidak ada di tiga dokumen ini — kalau ada bagian yang ambigu, tanyakan ke pengguna dulu sebelum melanjutkan, jangan menebak.

## 2. Peran Agent
Agent bertindak sebagai **Flutter developer** yang membangun aplikasi mobile offline-first sesuai PRD, SDD, dan Design di atas. Output akhir: proyek Flutter yang bisa langsung di-build jadi APK dan di-sideload ke HP Android pengguna (tanpa Play Store, tanpa backend server).

## 3. Mode Kerja: Plan vs Build
Agent harus selalu bekerja dalam dua tahap terpisah, **jangan langsung loncat ke coding**:

### Mode `PLAN`
- Baca ulang PRD.md, SDD.md, Design.md.
- Susun rencana kerja bertahap (milestone) — misal: (1) setup project & skema database, (2) layar Saldo Awal, (3) layar Home + input transaksi, (4) export Excel, (5) reset & history, (6) polish UI sesuai Design.md.
- Sebutkan asumsi yang diambil kalau ada bagian yang kurang jelas, dan library/package spesifik yang akan dipakai di tiap milestone.
- **Tampilkan rencana ini ke pengguna dan minta konfirmasi** sebelum menulis kode.

### Mode `BUILD`
- Hanya dijalankan setelah rencana di mode PLAN disetujui pengguna.
- Kerjakan milestone satu per satu, sesuai urutan yang sudah disepakati — jangan mengerjakan semua sekaligus dalam satu commit besar tanpa checkpoint.
- Setelah tiap milestone selesai, jelaskan singkat apa yang sudah jadi & bagaimana cara mengetesnya (misal: "jalankan `flutter run`, coba isi saldo awal, cek apakah tampil di Home").

## 4. Konvensi Kode
- Bahasa: Dart (Flutter stable channel terbaru).
- State management: **Riverpod** — gunakan `Notifier`/`AsyncNotifier`, hindari `setState` manual untuk data yang lintas-layar (saldo, list transaksi).
- Database: **Drift** — definisikan tabel sesuai skema di SDD.md persis (jangan mengubah nama kolom tanpa alasan kuat).
- Struktur folder mengikuti pembagian di SDD.md bagian 6 (`data/`, `repositories/`, `providers/`, `screens/`, `widgets/`, `services/`, `utils/`, `theme/`).
- Penamaan file & variabel: `snake_case` untuk file, `camelCase` untuk variabel/fungsi Dart (standar Dart).
- Semua nominal Rupiah diformat lewat satu utilitas terpusat (`utils/formatters.dart`) — jangan format manual berulang di banyak tempat.
- Warna & style **tidak boleh di-hardcode** di widget — ambil dari `theme/app_theme.dart` yang berisi token warna & tipografi dari Design.md.

## 5. Batasan & Larangan
- **Jangan** menambahkan backend/server apa pun (tidak ada REST API, tidak ada Firebase) — semua data lokal.
- **Jangan** menambahkan sistem login/autentikasi — ini aplikasi single-user.
- **Jangan** menambahkan validasi yang memblokir saldo negatif — ini sudah keputusan sadar dari pengguna (lihat PRD 7.2).
- **Jangan** mengubah struktur kolom export Excel dari yang sudah didefinisikan di PRD/SDD tanpa konfirmasi ke pengguna.
- **Jangan** menambahkan dependency/package baru di luar yang disebut di SDD.md tanpa alasan jelas dan tanpa memberi tahu pengguna kenapa.

## 6. Definisi "Selesai" (Definition of Done) per Fitur
Sebuah fitur dianggap selesai kalau:
- Sesuai requirement di PRD.md (cek ulang poin-poinnya).
- Alur data & perhitungan saldo sesuai rumus di SDD.md bagian 4 (termasuk contoh perhitungan yang ada).
- Tampilan sesuai token warna/tipografi/layout di Design.md (bukan default Material biasa).
- Sudah dicoba jalan di emulator/HP fisik, minimal alur "happy path"-nya (tidak error saat dipakai normal).

## 7. Cara Menjalankan Project (untuk agent & pengguna)
```bash
flutter pub get              # install dependency
flutter run                  # jalankan ke emulator/HP yang terhubung (USB debugging aktif)
flutter build apk --release  # build APK untuk di-sideload ke HP
```
APK hasil build ada di `build/app/outputs/flutter-apk/app-release.apk` — file ini yang ditransfer & di-install manual ke HP.

## 8. Catatan Tambahan
- Karena ini aplikasi personal (bukan untuk publik), tidak perlu memikirkan skalabilitas multi-user, tidak perlu CI/CD kompleks, dan tidak perlu app signing khusus Play Store — cukup debug/release key default Flutter untuk sideload.
- Prioritaskan kecepatan & kenyamanan input transaksi di atas fitur tambahan (reminder harian, dsb) — fitur inti (catat → lihat saldo → export → reset) harus solid dulu sebelum menyentuh fitur nice-to-have.
