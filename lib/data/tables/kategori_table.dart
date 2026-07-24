import 'package:drift/drift.dart';

class Kategori extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nama => text()();
}
