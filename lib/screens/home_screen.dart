import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../providers/saldo_provider.dart';
import '../providers/transaksi_provider.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/saldo_card.dart';
import '../widgets/transaksi_tile.dart';
import 'detail_transaksi_screen.dart';
import 'export_preview_screen.dart';
import 'history_screen.dart';
import 'tambah_transaksi_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _tambahTransaksi(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TambahTransaksiSheet(),
    );
  }

  void _bukaExport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ExportPreviewScreen()),
    );
  }

  void _bukaHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HistoryScreen()),
    );
  }

  void _tampilkanResetDialog(BuildContext context, WidgetRef ref) {
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
              'Reset Periode',
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
          'Pastikan sudah export laporan. Reset akan mengosongkan transaksi periode ini.',
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
                ref.read(saldoRepositoryProvider).resetPeriode();
                // Sesi stream in main.dart will trigger routing automatically
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.signalCoral,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Text(
                'Ya, Reset',
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
  Widget build(BuildContext context, WidgetRef ref) {
    final saldoBerjalan = ref.watch(saldoBerjalanProvider) ?? 0.0;
    final totalPeng = ref.watch(totalPengeluaranProvider);
    
    final transaksiAsync = ref.watch(transaksiListProvider);
    final kategoriAsync = ref.watch(kategoriListProvider);
    final saldoAkhirTerakhirAsync = ref.watch(saldoAkhirTerakhirProvider);

    return Scaffold(
      backgroundColor: AppColors.ledgerCream,
      appBar: AppBar(
        title: Text(
          'Catetin',
          style: AppTypography.displayMedium.copyWith(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.history),
            onPressed: () => _bukaHistory(context),
          ),
          IconButton(
            icon: const Icon(LucideIcons.share2),
            onPressed: () => _bukaExport(context),
          ),
          IconButton(
            icon: const Icon(LucideIcons.trash2),
            onPressed: () => _tampilkanResetDialog(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SaldoCard(
                saldo: saldoBerjalan,
                totalPengeluaran: totalPeng,
              ),
            ),
            
            saldoAkhirTerakhirAsync.when(
              loading: () => const SizedBox(),
              error: (e, _) => const SizedBox(),
              data: (saldoAkhir) {
                if (saldoAkhir == 0) return const SizedBox();
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(
                    'SALDO AKHIR PERIODE LALU: ${formatRupiah(saldoAkhir)}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.slateGrey,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),

            const Divider(color: AppColors.slateGrey, height: 1),

            Expanded(
              child: transaksiAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (transaksiList) {
                  if (transaksiList.isEmpty) {
                    return Center(
                      child: Text(
                        'Belum ada transaksi periode ini.\nKetuk tombol + untuk menambah.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.slateGrey,
                        ),
                      ),
                    );
                  }

                  return kategoriAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Error: $e')),
                    data: (kategoriList) {
                      final kategoriMap = {
                        for (final kat in kategoriList) kat.id: kat.nama
                      };

                      return ListView.builder(
                        itemCount: transaksiList.length,
                        itemBuilder: (context, index) {
                          final trx = transaksiList[index];
                          final namaKategori =
                              kategoriMap[trx.kategoriId] ?? 'Lain-lain';

                          return TransaksiTile(
                            transaksi: trx,
                            namaKategori: namaKategori,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailTransaksiScreen(
                                    transaksi: trx,
                                    namaKategori: namaKategori,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.goldStamp,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () => _tambahTransaksi(context),
        child: const Icon(LucideIcons.plus, size: 28),
      ),
    );
  }
}
