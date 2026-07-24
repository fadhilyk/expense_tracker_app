import 'package:drift/drift.dart';
import '../data/database.dart';

class SaldoRepository {
  final AppDatabase _db;

  SaldoRepository(this._db);

  Future<double> ambilSaldoAkhirTerakhir() async {
    final query = _db.select(_db.historySaldoAkhir)
      ..orderBy([(t) => OrderingTerm.desc(t.dicatatPada)])
      ..limit(1);
    final rows = await query.get();
    return rows.isEmpty ? 0 : rows.first.saldoAkhir;
  }

  Future<SesiAktifData> ambilSesiAktif() async {
    final rows = await _db.select(_db.sesiAktif).get();
    return rows.first;
  }

  Stream<SesiAktifData> watchSesiAktif() {
    return (_db.select(_db.sesiAktif)
          ..where((t) => t.id.equals(1)))
        .watchSingle();
  }

  Future<void> mulaiPeriodeBaru(double saldoAwalInput) async {
    final saldoAkhirTerakhir = await ambilSaldoAkhirTerakhir();
    final saldoMulai = saldoAwalInput + saldoAkhirTerakhir;

    await (_db.update(_db.sesiAktif)..where((t) => t.id.equals(1))).write(
      SesiAktifCompanion(
        saldoAwalInput: Value(saldoAwalInput),
        saldoMulai: Value(saldoMulai),
        sudahDiisi: const Value(true),
      ),
    );
  }
}
