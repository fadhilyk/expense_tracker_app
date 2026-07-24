import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../providers/saldo_provider.dart';
import '../providers/transaksi_provider.dart';
import '../data/database.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../utils/slide_route.dart';
import '../widgets/saldo_card.dart';
import '../widgets/transaksi_tile.dart';
import 'detail_transaksi_screen.dart';
import 'export_preview_screen.dart';
import 'history_screen.dart';
import 'tambah_transaksi_sheet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _listKey = GlobalKey<AnimatedListState>();
  List<TransaksiData> _previousList = [];
  final Set<int> _highlightIds = {};

  void _tambahTransaksi(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TambahTransaksiSheet(),
    );
  }

  void _bukaExport(BuildContext context) {
    Navigator.push(context, slideRoute(const ExportPreviewScreen()));
  }

  void _bukaHistory(BuildContext context) {
    Navigator.push(context, slideRoute(const HistoryScreen()));
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

  void _syncAnimatedList(List<TransaksiData> newList) {
    final oldIds = _previousList.map((t) => t.id).toSet();
    final newIds = newList.map((t) => t.id).toSet();

    final added = newIds.difference(oldIds);
    final removed = oldIds.difference(newIds);

    for (final id in removed) {
      final oldIndex = _previousList.indexWhere((t) => t.id == id);
      if (oldIndex != -1) {
        final removedItem = _previousList[oldIndex];
        _listKey.currentState?.removeItem(
          oldIndex,
          (context, animation) => _buildRemovedTile(removedItem, animation),
          duration: const Duration(milliseconds: 300),
        );
      }
    }

    for (final id in added) {
      final newIndex = newList.indexWhere((t) => t.id == id);
      if (newIndex != -1) {
        _highlightIds.add(id);
        _listKey.currentState?.insertItem(
          newIndex,
          duration: const Duration(milliseconds: 320),
        );
      }
    }

    _previousList = List.of(newList);
  }

  Widget _buildRemovedTile(TransaksiData trx, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: TransaksiTile(
          transaksi: trx,
          namaKategori: '',
          onTap: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  if (transaksiList.isEmpty && _previousList.isNotEmpty) {
                    _previousList = [];
                  }

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

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_previousList.isEmpty && transaksiList.isNotEmpty) {
                          _previousList = List.of(transaksiList);
                        } else {
                          _syncAnimatedList(transaksiList);
                        }
                      });

                      if (_previousList.isEmpty && transaksiList.isNotEmpty) {
                        _previousList = List.of(transaksiList);
                      }

                      return AnimatedList(
                        key: _listKey,
                        initialItemCount: transaksiList.length,
                        itemBuilder: (context, index, animation) {
                          if (index >= transaksiList.length) {
                            return const SizedBox();
                          }
                          final trx = transaksiList[index];
                          final namaKategori =
                              kategoriMap[trx.kategoriId] ?? 'Lain-lain';

                          final slideAnimation = Tween<Offset>(
                            begin: const Offset(0, -0.5),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOut,
                          ));

                          final shouldHighlight = _highlightIds.contains(trx.id);

                          Widget tile = Dismissible(
                            key: ValueKey(trx.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 24),
                              color: AppColors.signalCoral,
                              child: const Icon(
                                LucideIcons.trash2,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            confirmDismiss: (_) async {
                              return await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor: AppColors.ledgerCream,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: Text(
                                    'Hapus transaksi ini?',
                                    textAlign: TextAlign.center,
                                    style: AppTypography.displayMedium.copyWith(
                                      color: AppColors.inkNavy,
                                      fontSize: 18,
                                    ),
                                  ),
                                  content: Text(
                                    'Saldo berjalan akan dihitung ulang.',
                                    textAlign: TextAlign.center,
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.slateGrey,
                                    ),
                                  ),
                                  actionsAlignment: MainAxisAlignment.spaceEvenly,
                                  actions: [
                                    OutlinedButton(
                                      onPressed: () => Navigator.pop(ctx, false),
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
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(ctx, true),
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
                                  ],
                                ),
                              ) ?? false;
                            },
                            onDismissed: (_) {
                              ref.read(transaksiRepositoryProvider).hapusTransaksi(trx.id);
                            },
                            child: TransaksiTile(
                              transaksi: trx,
                              namaKategori: namaKategori,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  slideRoute(DetailTransaksiScreen(
                                    transaksi: trx,
                                    namaKategori: namaKategori,
                                  )),
                                );
                              },
                            ),
                          );

                          if (shouldHighlight) {
                            tile = _HighlightWrapper(
                              onComplete: () => _highlightIds.remove(trx.id),
                              child: tile,
                            );
                          }

                          return SlideTransition(
                            position: slideAnimation,
                            child: FadeTransition(
                              opacity: animation,
                              child: tile,
                            ),
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

class _HighlightWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onComplete;

  const _HighlightWrapper({required this.child, required this.onComplete});

  @override
  State<_HighlightWrapper> createState() => _HighlightWrapperState();
}

class _HighlightWrapperState extends State<_HighlightWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _colorAnimation = ColorTween(
      begin: const Color(0x3066BB6A),
      end: const Color(0x0066BB6A),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) => Container(
        color: _colorAnimation.value,
        child: child,
      ),
      child: widget.child,
    );
  }
}
