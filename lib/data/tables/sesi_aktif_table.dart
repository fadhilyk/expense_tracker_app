import 'package:drift/drift.dart';

class SesiAktif extends Table {
  IntColumn get id => integer()();
  RealColumn get saldoAwalInput => real()();
  RealColumn get saldoMulai => real()();
  BoolColumn get sudahDiisi => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
