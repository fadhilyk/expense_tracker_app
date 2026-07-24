import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import '../main.dart';
import '../repositories/saldo_repository.dart';

final saldoRepositoryProvider = Provider<SaldoRepository>((ref) {
  return SaldoRepository(ref.watch(databaseProvider));
});

final sesiAktifStreamProvider = StreamProvider<SesiAktifData>((ref) {
  return ref.watch(saldoRepositoryProvider).watchSesiAktif();
});

final saldoAkhirTerakhirProvider = FutureProvider<double>((ref) {
  return ref.watch(saldoRepositoryProvider).ambilSaldoAkhirTerakhir();
});
