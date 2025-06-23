import 'package:drift/drift.dart';
import 'package:rep_records/constants/common.dart';

class Category extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get status => text().withDefault(const Constant('created'))();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}