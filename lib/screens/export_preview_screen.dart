import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../data/database.dart';
import '../main.dart';
import '../providers/saldo_provider.dart';
import '../providers/transaksi_provider.dart';
import '../services/excel_export_service.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class ExportPreviewScreen extends ConsumerStatefulWidget {
  const ExportPreviewScreen({super.key});

  @override
  ConsumerState<ExportPreviewScreen> createState() => _ExportPreviewScreenState();
}

class _ExportPreviewScreenState extends ConsumerState<ExportPreviewScreen> {
  bool _isExporting = false;

  Future<void> _exportExcel() async {
    setState(() {
      _isExporting = true;
    });

    try {
      final list = ref.read(transaksiListProvider).valueOrNull ?? [];
      final kategoriList = ref.read(kategoriListProvider).valueOrNull ?? [];
      final sesi = ref.read(sesiAktifStreamProvider).valueOrNull;
      final saldoAkhir = ref.read(saldoBerjalanProvider) ?? 0.0;
      final totalPem = ref.read(totalPemasukanProvider);
      final totalPeng = ref.read(totalPengeluaranProvider);

      if (sesi == null) {
        throw Exception('Sesi aktif tidak ditemukan');
      }

      final kategoriMap = {
        for (final kat in kategoriList) kat.id: kat.nama
      };

      final db = ref.read(databaseProvider);
      final allHistory = await db.select(db.historySaldoAkhir).get();
      print('DEBUG_EXPORT: 1. Isi tabel history_saldo_akhir langsung dari DB:');
      for (final h in allHistory) {
        print(' - ID: ${h.id}, tanggalPeriode: ${h.tanggalPeriode}, saldoAkhir: ${h.saldoAkhir}, dicatatPada: ${h.dicatatPada}');
      }

      final lastHistoryRepo = await ref.read(saldoRepositoryProvider).ambilSaldoAkhirTerakhir();
      print('DEBUG_EXPORT: 2. Hasil ambilSaldoAkhirTerakhir dari repo (double): $lastHistoryRepo');

      final lastHistory = ref.read(historyListProvider).valueOrNull?.firstOrNull;
      print('DEBUG_EXPORT: 2b. lastHistory from StreamProvider: $lastHistory');

      // 1. Generate excel file in temp directory
      final tempFile = await ExcelExportService.generateXlsx(
        saldoAwalInput: sesi.saldoAwalInput,
        saldoMulai: sesi.saldoMulai,
        lastHistory: lastHistory,
        transaksiList: list.reversed.toList(), // reverse to chronologically ascending
        kategoriMap: kategoriMap,
        totalPemasukan: totalPem,
        totalPengeluaran: totalPeng,
        saldoAkhir: saldoAkhir,
      );

      File savedFile = tempFile;
      bool isSavedToPublicFolder = false;

      if (Platform.isAndroid) {
        print('DEBUG_EXPORT: 4. Cek status permission.manageExternalStorage...');
        var status = await Permission.manageExternalStorage.status;
        print('DEBUG_EXPORT: 4b. Status permission.manageExternalStorage saat ini: $status');
        if (!status.isGranted) {
          print('DEBUG_EXPORT: 4c. Meminta permission.manageExternalStorage...');
          status = await Permission.manageExternalStorage.request();
          print('DEBUG_EXPORT: 4d. Status setelah request permission.manageExternalStorage: $status');
        }

        if (!status.isGranted) {
          print('DEBUG_EXPORT: 4e. permission.manageExternalStorage tidak ter-grant. Mencoba fallback ke standard storage...');
          var fallbackStatus = await Permission.storage.request();
          print('DEBUG_EXPORT: 4f. Status fallback storage: $fallbackStatus');
          if (!fallbackStatus.isGranted) {
            print('DEBUG_EXPORT: 4g. Semua permission ditolak. Menampilkan permission error dialog...');
            if (mounted) {
              _showPermissionErrorDialog();
            }
            return;
          }
        }

        print('DEBUG_EXPORT: 5. Membuat folder LaporanPengeluaran...');
        const folderPath = '/storage/emulated/0/LaporanPengeluaran';
        final dir = Directory(folderPath);
        if (!await dir.exists()) {
          print('DEBUG_EXPORT: 5b. Folder belum ada, mencoba membuat folder: $folderPath');
          await dir.create(recursive: true);
          print('DEBUG_EXPORT: 5c. Pembuatan folder berhasil.');
        } else {
          print('DEBUG_EXPORT: 5d. Folder sudah ada.');
        }

        final targetPath = p.join(folderPath, p.basename(tempFile.path));
        print('DEBUG_EXPORT: 6. Menyalin file dari temp ${tempFile.path} ke target $targetPath...');
        savedFile = await tempFile.copy(targetPath);
        print('DEBUG_EXPORT: 6b. Penyalinan file berhasil.');
        isSavedToPublicFolder = true;
      }

      // Share File
      final XFile xFile = XFile(savedFile.path);
      await Share.shareXFiles([xFile], text: 'Laporan Pengeluaran Harian');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isSavedToPublicFolder
                ? 'Tersimpan di LaporanPengeluaran'
                : 'File Excel siap dibagikan!'),
            backgroundColor: AppColors.emeraldPulse,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  void _showPermissionErrorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.ledgerCream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Column(
          children: [
            Icon(
              LucideIcons.alertTriangle,
              color: AppColors.signalCoral,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'Izin Ditolak',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Fraunces',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.inkNavy,
              ),
            ),
          ],
        ),
        content: const Text(
          'Aplikasi membutuhkan izin akses semua berkas untuk menyimpan laporan langsung ke folder LaporanPengeluaran.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 15,
            color: AppColors.slateGrey,
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actionsPadding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
        actions: [
          SizedBox(
            width: 110,
            height: 48,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(ctx),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.slateGrey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Text(
                'Batal',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.slateGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 110,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.emeraldPulse,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Text(
                'Pengaturan',
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.ledgerCream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Column(
          children: [
            Icon(
              LucideIcons.alertTriangle,
              color: AppColors.signalCoral,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'Gagal Ekspor',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Fraunces',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.inkNavy,
              ),
            ),
          ],
        ),
        content: Text(
          'Terjadi kesalahan saat mengekspor: $message',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 15,
            color: AppColors.slateGrey,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
        actions: [
          SizedBox(
            width: 120,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.emeraldPulse,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Text(
                'OK',
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(transaksiListProvider);
    final sesiAsync = ref.watch(sesiAktifStreamProvider);
    final kategoriAsync = ref.watch(kategoriListProvider);
    final historyAsync = ref.watch(historyListProvider);

    return Scaffold(
      backgroundColor: AppColors.ledgerCream,
      appBar: AppBar(
        title: Text(
          'Preview Laporan',
          style: AppTypography.displayMedium.copyWith(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: sesiAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text('Error: $e')),
                      data: (sesi) => listAsync.when(
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Center(child: Text('Error: $e')),
                        data: (transaksiList) => kategoriAsync.when(
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Center(child: Text('Error: $e')),
                          data: (kategoriList) => historyAsync.when(
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (e, _) => Center(child: Text('Error: $e')),
                            data: (historyList) {
                              final kategoriMap = {
                                for (final kat in kategoriList) kat.id: kat.nama
                              };
                              final lastHistory = historyList.firstOrNull;
                              return _buildPreviewTable(
                                sesi.saldoAwalInput,
                                sesi.saldoMulai,
                                lastHistory,
                                transaksiList.reversed.toList(), // Chronologically ascending for report
                                kategoriMap,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isExporting ? null : _exportExcel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emeraldPulse,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isExporting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Ekspor & Bagikan (.xlsx)',
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewTable(
    double saldoAwalInput,
    double saldoMulai,
    HistorySaldoAkhirData? lastHistory,
    List<TransaksiData> transaksiList,
    Map<int, String> kategoriMap,
  ) {
    // Computes aggregate totals
    double totalPem = saldoAwalInput;
    double totalPeng = 0.0;
    for (final t in transaksiList) {
      totalPem += t.pemasukan;
      totalPeng += t.pengeluaran;
    }
    final saldoAkhir = (lastHistory?.saldoAkhir ?? 0.0) + totalPem - totalPeng;

    final headerBg = AppColors.inkNavy;
    final startRowBg = const Color(0xFFD1EAE0);
    final totalRowBg = const Color(0xFFFCEFCB);

    final List<TableRow> tableRows = [];

    // 1. Header
    tableRows.add(
      TableRow(
        decoration: BoxDecoration(color: headerBg),
        children: [
          _buildHeaderCell('No'),
          _buildHeaderCell('Tanggal'),
          _buildHeaderCell('Keterangan'),
          _buildHeaderCell('Uraian'),
          _buildHeaderCell('Pemasukan'),
          _buildHeaderCell('Pengeluaran'),
          _buildHeaderCell('Saldo'),
        ],
      ),
    );

    // 2. Baris "SALDO AKHIR PER [tanggal periode sebelumnya]"
    if (lastHistory != null) {
      final historyDateStr = formatTanggalLengkap(lastHistory.tanggalPeriode).toUpperCase();
      tableRows.add(
        TableRow(
          decoration: const BoxDecoration(color: Colors.white),
          children: [
            _buildCell('1', alignCenter: true),
            _buildCell('-'),
            _buildCell('SALDO AKHIR PER $historyDateStr'),
            _buildCell('Referensi Saldo Akhir Lalu'),
            _buildCell(formatRupiah(0.0), isMono: true),
            _buildCell(formatRupiah(0.0), isMono: true),
            _buildCell(formatRupiah(lastHistory.saldoAkhir), isMono: true),
          ],
        ),
      );
    }

    // 3. Baris "PEMASUKAN DARI FINANCE"
    final financeRowNo = lastHistory != null ? 2 : 1;
    tableRows.add(
      TableRow(
        decoration: BoxDecoration(color: startRowBg),
        children: [
          _buildCell(financeRowNo.toString(), alignCenter: true),
          _buildCell('-'),
          _buildCell('PEMASUKAN DARI FINANCE'),
          _buildCell('Saldo Awal Periode'),
          _buildCell(formatRupiah(saldoAwalInput), isMono: true),
          _buildCell(formatRupiah(0.0), isMono: true),
          _buildCell(formatRupiah(saldoMulai), isMono: true),
        ],
      ),
    );

    // 4. Transaksi rows
    for (var i = 0; i < transaksiList.length; i++) {
      final t = transaksiList[i];
      final no = (lastHistory != null ? 3 : 2) + i;
      tableRows.add(
        TableRow(
          decoration: const BoxDecoration(color: Colors.white),
          children: [
            _buildCell(no.toString(), alignCenter: true),
            _buildCell(DateFormat('dd/MM/yyyy').format(t.tanggal)),
            _buildCell(kategoriMap[t.kategoriId] ?? '-'),
            _buildCell(t.uraian),
            _buildCell(formatRupiah(t.pemasukan), isMono: true),
            _buildCell(formatRupiah(t.pengeluaran), isMono: true),
            _buildCell(formatRupiah(t.saldoSetelah), isMono: true),
          ],
        ),
      );
    }

    // 5. Totals Row
    final lastDate = transaksiList.isNotEmpty ? transaksiList.last.tanggal : DateTime.now();
    final totalRowDateStr = formatTanggalLengkap(lastDate).toUpperCase();
    tableRows.add(
      TableRow(
        decoration: BoxDecoration(color: totalRowBg),
        children: [
          _buildCell(''),
          _buildCell(''),
          _buildCell('SALDO AKHIR PER $totalRowDateStr', isBold: true),
          _buildCell(''),
          _buildCell(formatRupiah(totalPem), isMono: true, isBold: true),
          _buildCell(formatRupiah(totalPeng), isMono: true, isBold: true),
          _buildCell(formatRupiah(saldoAkhir), isMono: true, isBold: true),
        ],
      ),
    );

    return Table(
      defaultColumnWidth: const FixedColumnWidth(120),
      columnWidths: const {
        0: FixedColumnWidth(50),  // No
        1: FixedColumnWidth(100), // Tanggal
        2: FixedColumnWidth(220), // Keterangan (increased width for date text!)
        3: FixedColumnWidth(180), // Uraian
        4: FixedColumnWidth(120), // Pemasukan
        5: FixedColumnWidth(120), // Pengeluaran
        6: FixedColumnWidth(130), // Saldo
      },
      border: TableBorder.all(
        color: AppColors.slateGrey.withValues(alpha: 0.3),
        width: 1,
      ),
      children: tableRows,
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Center(
        child: Text(
          text,
          style: AppTypography.bodySmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCell(
    String text, {
    bool alignCenter = false,
    bool isMono = false,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Align(
        alignment: alignCenter ? Alignment.center : Alignment.centerLeft,
        child: Text(
          text,
          style: (isMono ? AppTypography.monoData : AppTypography.bodySmall).copyWith(
            color: AppColors.inkNavy,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isMono ? 13 : 13,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
