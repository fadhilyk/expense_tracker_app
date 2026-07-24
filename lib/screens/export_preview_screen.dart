import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../data/database.dart';
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

      // 1. Generate excel file in temp directory
      final tempFile = await ExcelExportService.generateXlsx(
        saldoMulai: sesi.saldoMulai,
        transaksiList: list.reversed.toList(), // reverse to chronologically ascending
        kategoriMap: kategoriMap,
        totalPemasukan: totalPem,
        totalPengeluaran: totalPeng,
        saldoAkhir: saldoAkhir,
      );

      // 2. Request Storage Permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }

      // Check manage external storage for Android 11+
      if (Platform.isAndroid && !status.isGranted) {
        // If normal storage permission not granted, request manageExternalStorage on SDK 30+
        var statusManage = await Permission.manageExternalStorage.status;
        if (!statusManage.isGranted) {
          statusManage = await Permission.manageExternalStorage.request();
        }
        status = statusManage;
      }

      File? savedFile;
      if (status.isGranted) {
        // 3. Save to Download directory
        const downloadPath = '/storage/emulated/0/Download';
        final downloadDir = Directory(downloadPath);
        if (await downloadDir.exists()) {
          final targetPath = p.join(downloadPath, p.basename(tempFile.path));
          savedFile = await tempFile.copy(targetPath);
        }
      }

      // 4. Share File
      final XFile xFile = XFile(savedFile?.path ?? tempFile.path);
      await Share.shareXFiles([xFile], text: 'Laporan Pengeluaran Harian');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              savedFile != null
                  ? 'Berhasil disimpan ke folder Download & siap dibagikan!'
                  : 'File Excel siap dibagikan!',
            ),
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.ledgerCream,
        title: const Text('Gagal Ekspor'),
        content: Text('Terjadi kesalahan saat mengekspor: $message\n\nSilakan periksa izin penyimpanan aplikasi Anda.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings();
            },
            child: const Text('Buka Pengaturan'),
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
                          data: (kategoriList) {
                            final kategoriMap = {
                              for (final kat in kategoriList) kat.id: kat.nama
                            };
                            return _buildPreviewTable(
                              sesi.saldoMulai,
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
    double saldoMulai,
    List<TransaksiData> transaksiList,
    Map<int, String> kategoriMap,
  ) {
    // Computes aggregate totals
    double totalPem = saldoMulai;
    double totalPeng = 0.0;
    for (final t in transaksiList) {
      totalPem += t.pemasukan;
      totalPeng += t.pengeluaran;
    }
    final saldoAkhir = totalPem - totalPeng;

    final headerBg = AppColors.inkNavy;
    final startRowBg = const Color(0xFFD1EAE0);
    final totalRowBg = const Color(0xFFFCEFCB);

    return Table(
      defaultColumnWidth: const FixedColumnWidth(120),
      columnWidths: const {
        0: FixedColumnWidth(50),  // No
        1: FixedColumnWidth(100), // Tanggal
        2: FixedColumnWidth(150), // Keterangan
        3: FixedColumnWidth(180), // Uraian
        4: FixedColumnWidth(120), // Pemasukan
        5: FixedColumnWidth(120), // Pengeluaran
        6: FixedColumnWidth(130), // Saldo
      },
      border: TableBorder.all(
        color: AppColors.slateGrey.withValues(alpha: 0.3),
        width: 1,
      ),
      children: [
        // Header
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

        // Saldo Awal row
        TableRow(
          decoration: BoxDecoration(color: startRowBg),
          children: [
            _buildCell('1', alignCenter: true),
            _buildCell('-'),
            _buildCell('PEMASUKAN DARI FINANCE'),
            _buildCell('Saldo Awal Periode'),
            _buildCell(formatRupiah(saldoMulai), isMono: true),
            _buildCell(formatRupiah(0), isMono: true),
            _buildCell(formatRupiah(saldoMulai), isMono: true),
          ],
        ),

        // Transaksi rows
        for (var i = 0; i < transaksiList.length; i++) ...[
          TableRow(
            decoration: const BoxDecoration(color: Colors.white),
            children: [
              _buildCell((i + 2).toString(), alignCenter: true),
              _buildCell(DateFormat('dd/MM/yyyy').format(transaksiList[i].tanggal)),
              _buildCell(kategoriMap[transaksiList[i].kategoriId] ?? '-'),
              _buildCell(transaksiList[i].uraian),
              _buildCell(formatRupiah(transaksiList[i].pemasukan), isMono: true),
              _buildCell(formatRupiah(transaksiList[i].pengeluaran), isMono: true),
              _buildCell(formatRupiah(transaksiList[i].saldoSetelah), isMono: true),
            ],
          ),
        ],

        // Totals Row
        TableRow(
          decoration: BoxDecoration(color: totalRowBg),
          children: [
            _buildCell(''),
            _buildCell(''),
            _buildCell('TOTAL', isBold: true),
            _buildCell(''),
            _buildCell(formatRupiah(totalPem), isMono: true, isBold: true),
            _buildCell(formatRupiah(totalPeng), isMono: true, isBold: true),
            _buildCell(formatRupiah(saldoAkhir), isMono: true, isBold: true),
          ],
        ),
      ],
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
