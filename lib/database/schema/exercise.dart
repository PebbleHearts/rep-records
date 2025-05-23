import 'package:drift/drift.dart';
import 'package:rep_records/constants/common.dart';

class Exercise extends Table {
  TextColumn get id => text().clientDefault(() => uuidInstance.v4())();
  TextColumn get name => text()();
  TextColumn get status => text().withDefault(const Constant('created'))();
  TextColumn get equipment => text()();
  TextColumn get categoryId => text()();
}