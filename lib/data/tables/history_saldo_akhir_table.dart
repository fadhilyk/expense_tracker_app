import 'package:drift/drift.dart';

class HistorySaldoAkhir extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get tanggalPeriode => dateTime()();
  RealColumn get saldoAkhir => real()();
  DateTimeColumn get dicatatPada => dateTime()();
}
