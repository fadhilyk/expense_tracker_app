import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:expense_tracker_app/data/database.dart';
import 'package:expense_tracker_app/repositories/saldo_repository.dart';
import 'package:expense_tracker_app/widgets/rupiah_input_formatter.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('seed 9 kategori on create', () async {
    final rows = await db.select(db.kategori).get();
    expect(rows.length, 9);
    expect(rows.first.nama, 'K - Operasional');
    expect(rows.last.nama, 'Pantry');
  });

  test('seed sesi_aktif with id=1, sudahDiisi=false', () async {
    final rows = await db.select(db.sesiAktif).get();
    expect(rows.length, 1);
    expect(rows.first.id, 1);
    expect(rows.first.saldoAwalInput, 0);
    expect(rows.first.saldoMulai, 0);
    expect(rows.first.sudahDiisi, false);
  });

  test('transaksi table exists and is empty', () async {
    final rows = await db.select(db.transaksi).get();
    expect(rows, isEmpty);
  });

  test('history_saldo_akhir table exists and is empty', () async {
    final rows = await db.select(db.historySaldoAkhir).get();
    expect(rows, isEmpty);
  });

  group('SaldoRepository', () {
    late SaldoRepository repo;

    setUp(() {
      repo = SaldoRepository(db);
    });

    test('saldoAkhirTerakhir returns 0 when no history', () async {
      expect(await repo.ambilSaldoAkhirTerakhir(), 0);
    });

    test('mulaiPeriodeBaru sets sesi_aktif correctly (first run)', () async {
      await repo.mulaiPeriodeBaru(5000000);
      final sesi = await repo.ambilSesiAktif();
      expect(sesi.saldoAwalInput, 5000000);
      expect(sesi.saldoMulai, 5000000);
      expect(sesi.sudahDiisi, true);
    });

    test('mulaiPeriodeBaru with negative history (signed addition)', () async {
      await db.into(db.historySaldoAkhir).insert(
        HistorySaldoAkhirCompanion.insert(
          tanggalPeriode: DateTime(2026, 7, 14),
          saldoAkhir: -1246000,
          dicatatPada: DateTime(2026, 7, 14),
        ),
      );

      await repo.mulaiPeriodeBaru(5000000);
      final sesi = await repo.ambilSesiAktif();
      expect(sesi.saldoAwalInput, 5000000);
      expect(sesi.saldoMulai, 3754000);
      expect(sesi.sudahDiisi, true);
    });

    test('mulaiPeriodeBaru with positive history', () async {
      await db.into(db.historySaldoAkhir).insert(
        HistorySaldoAkhirCompanion.insert(
          tanggalPeriode: DateTime(2026, 7, 14),
          saldoAkhir: 500000,
          dicatatPada: DateTime(2026, 7, 14),
        ),
      );

      await repo.mulaiPeriodeBaru(5000000);
      final sesi = await repo.ambilSesiAktif();
      expect(sesi.saldoMulai, 5500000);
    });
  });

  group('RupiahInputFormatter.parse', () {
    test('parses formatted string', () {
      expect(RupiahInputFormatter.parse('Rp5.000.000'), 5000000);
    });

    test('parses empty string as 0', () {
      expect(RupiahInputFormatter.parse(''), 0);
    });

    test('parses plain digits', () {
      expect(RupiahInputFormatter.parse('1234567'), 1234567);
    });
  });
}
