import 'package:drift/drift.dart';

class Exercise extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get status => text().withDefault(const Constant('created'))();
  TextColumn get equipment => text()();
  IntColumn get categoryId => integer()();
}