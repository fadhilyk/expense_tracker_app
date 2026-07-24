import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../data/database.dart';
import '../providers/transaksi_provider.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../utils/kategori_helper.dart';
import 'tambah_transaksi_sheet.dart';

class DetailTransaksiScreen extends ConsumerWidget {
  final TransaksiData transaksi;
  final String namaKategori;

  const DetailTransaksiScreen({
    super.key,
    required this.transaksi,
    required this.namaKategori,
  });

  void _hapus(BuildContext context, WidgetRef ref) {
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
              LucideIcons.trash2,
              color: AppColors.signalCoral,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'Hapus Transaksi',
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
          'Apakah Anda yakin ingin menghapus transaksi ini? Saldo berjalan setelah transaksi ini akan dihitung ulang.',
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
                ref
                    .read(transaksiRepositoryProvider)
                    .hapusTransaksi(transaksi.id);
                Navigator.pop(ctx); // Close dialog
                Navigator.pop(context); // Close detail screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.signalCoral,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Text(
                'Hapus',
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

  void _edit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TambahTransaksiSheet(editTransaksi: transaksi),
    ).then((_) {
      if (context.mounted) {
        Navigator.pop(context); // Go back home after editing modal closes
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nominal = transaksi.pengeluaran;

    return Scaffold(
      backgroundColor: AppColors.ledgerCream,
      appBar: AppBar(
        title: Text(
          'Detail Transaksi',
          style: AppTypography.displayMedium.copyWith(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.inkNavy,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.inkNavy.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: warnaKategori(transaksi.kategoriId),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          namaKategori,
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.inkNavy,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.signalCoral
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            'Pengeluaran',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.signalCoral,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Nominal',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.slateGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatRupiah(nominal),
                      style: AppTypography.monoData.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.signalCoral,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Uraian',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.slateGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaksi.uraian.isEmpty ? '-' : transaksi.uraian,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.inkNavy,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tanggal',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.slateGrey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatTanggalLengkap(transaksi.tanggal),
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.inkNavy,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Saldo Setelah',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.slateGrey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatRupiah(transaksi.saldoSetelah),
                                style: AppTypography.monoData.copyWith(
                                  color: transaksi.saldoSetelah >= 0
                                      ? AppColors.emeraldPulse
                                      : AppColors.signalCoral,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () => _edit(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.inkNavy),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Ubah',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.inkNavy,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => _hapus(context, ref),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.signalCoral,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Hapus',
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
            ],
          ),
        ),
      ),
    );
  }
}
