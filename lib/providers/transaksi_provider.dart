import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import '../main.dart';
import '../repositories/transaksi_repository.dart';
import 'saldo_provider.dart';

final transaksiRepositoryProvider = Provider<TransaksiRepository>((ref) {
  return TransaksiRepository(ref.watch(databaseProvider));
});

final transaksiListProvider = StreamProvider<List<TransaksiData>>((ref) {
  return ref.watch(transaksiRepositoryProvider).watchSemuaTransaksi();
});

final kategoriListProvider = FutureProvider<List<KategoriData>>((ref) {
  return ref.watch(transaksiRepositoryProvider).ambilSemuaKategori();
});

final totalPemasukanProvider = Provider<double>((ref) {
  final list = ref.watch(transaksiListProvider).valueOrNull ?? [];
  return list.fold(0.0, (sum, t) => sum + t.pemasukan);
});

final totalPengeluaranProvider = Provider<double>((ref) {
  final list = ref.watch(transaksiListProvider).valueOrNull ?? [];
  return list.fold(0.0, (sum, t) => sum + t.pengeluaran);
});

final saldoBerjalanProvider = Provider<double?>((ref) {
  final list = ref.watch(transaksiListProvider).valueOrNull;
  if (list == null) return null;
  if (list.isEmpty) {
    final sesi = ref.watch(sesiAktifStreamProvider).valueOrNull;
    return sesi?.saldoMulai;
  }
  return list.first.saldoSetelah;
});
