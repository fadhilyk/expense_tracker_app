import 'package:drift/drift.dart';
import 'kategori_table.dart';

class Transaksi extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get tanggal => dateTime()();
  IntColumn get kategoriId => integer().references(Kategori, #id)();
  TextColumn get uraian => text()();
  RealColumn get pemasukan => real().withDefault(const Constant(0))();
  RealColumn get pengeluaran => real().withDefault(const Constant(0))();
  RealColumn get saldoSetelah => real()();
  DateTimeColumn get dibuatPada => dateTime()();
}
