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

  Future<void> resetPeriode() async {
    await _db.transaction(() async {
      // 1. Get last transaction
      final query = _db.select(_db.transaksi)
        ..orderBy([(t) => OrderingTerm.desc(t.dibuatPada)])
        ..limit(1);
      final lastRows = await query.get();

      double saldoAkhirFinal;
      DateTime tanggalPeriode;

      if (lastRows.isNotEmpty) {
        saldoAkhirFinal = lastRows.first.saldoSetelah;
        tanggalPeriode = lastRows.first.tanggal;
      } else {
        final sesi = await ambilSesiAktif();
        saldoAkhirFinal = sesi.saldoMulai;
        tanggalPeriode = DateTime.now();
      }

      // 2. Insert to history_saldo_akhir
      await _db.into(_db.historySaldoAkhir).insert(
        HistorySaldoAkhirCompanion.insert(
          tanggalPeriode: tanggalPeriode,
          saldoAkhir: saldoAkhirFinal,
          dicatatPada: DateTime.now(),
        ),
      );

      // 3. Delete all transactions
      await _db.delete(_db.transaksi).go();

      // 4. Reset sesi_aktif
      await (_db.update(_db.sesiAktif)..where((t) => t.id.equals(1))).write(
        const SesiAktifCompanion(
          saldoAwalInput: Value(0),
          saldoMulai: Value(0),
          sudahDiisi: Value(false),
        ),
      );
    });
  }

  Stream<List<HistorySaldoAkhirData>> watchHistory() {
    return (_db.select(_db.historySaldoAkhir)
          ..orderBy([(t) => OrderingTerm.desc(t.dicatatPada)]))
        .watch();
  }
}
