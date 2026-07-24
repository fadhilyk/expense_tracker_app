import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/saldo_provider.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/saldo_card.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyListProvider);

    return Scaffold(
      backgroundColor: AppColors.ledgerCream,
      appBar: AppBar(
        title: Text(
          'Riwayat Periode',
          style: AppTypography.displayMedium.copyWith(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: historyAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (historyList) {
            if (historyList.isEmpty) {
              return Center(
                child: Text(
                  'Belum ada riwayat periode sebelumnya.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.slateGrey,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final hist = historyList[index];
                final aman = hist.saldoAkhir >= 0;
                final warnaStatus =
                    aman ? AppColors.emeraldPulse : AppColors.signalCoral;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.inkNavy.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SALDO AKHIR PER',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.slateGrey,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatTanggalLengkap(hist.tanggalPeriode),
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.inkNavy,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            formatRupiah(hist.saldoAkhir),
                            style: AppTypography.monoData.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: warnaStatus,
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: StempelWidget(aman: aman),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
