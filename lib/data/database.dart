import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/kategori_table.dart';
import 'tables/transaksi_table.dart';
import 'tables/history_saldo_akhir_table.dart';
import 'tables/sesi_aktif_table.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Kategori, Transaksi, HistorySaldoAkhir, SesiAktif])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _seedKategori();
          await _seedSesiAktif();
        },
      );

  Future<void> _seedKategori() async {
    const daftarKategori = [
      'K - Operasional',
      'K - Material',
      'Listrik',
      'Keperluan kantor',
      'Keperluan mess',
      'ATK',
      'Perlengkapan Kantor',
      'Perawatan Kendaraan',
      'Pantry',
    ];
    for (final nama in daftarKategori) {
      await into(kategori).insert(
        KategoriCompanion.insert(nama: nama),
      );
    }
  }

  Future<void> _seedSesiAktif() async {
    await into(sesiAktif).insert(
      SesiAktifCompanion.insert(
        id: const Value(1),
        saldoAwalInput: 0,
        saldoMulai: 0,
      ),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'expense_tracker.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
