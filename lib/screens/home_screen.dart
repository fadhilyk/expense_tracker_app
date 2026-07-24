import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/saldo_provider.dart';
import '../providers/transaksi_provider.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/saldo_card.dart';
import '../widgets/transaksi_tile.dart';
import 'detail_transaksi_screen.dart';
import 'export_preview_screen.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saldoBerjalan = ref.watch(saldoBerjalanProvider) ?? 0.0;
    final totalPem = ref.watch(totalPemasukanProvider);
    final totalPeng = ref.watch(totalPengeluaranProvider);
    
    final transaksiAsync = ref.watch(transaksiListProvider);
    final kategoriAsync = ref.watch(kategoriListProvider);
    final saldoAkhirTerakhirAsync = ref.watch(saldoAkhirTerakhirProvider);

    return Scaffold(
      backgroundColor: AppColors.ledgerCream,
      appBar: AppBar(
        title: Text(
          'Buku Kas',
          style: AppTypography.displayMedium.copyWith(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Placeholder for history screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.ios_share),
            onPressed: () => _bukaExport(context),
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
                totalPemasukan: totalPem,
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
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
