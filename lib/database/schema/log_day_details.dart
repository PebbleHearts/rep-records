import 'package:drift/drift.dart';
import 'package:rep_records/constants/common.dart';

class LogDayDetails extends Table {
  TextColumn get id => text().clientDefault(() => uuidInstance.v4())();
  TextColumn get sessionDate => text()();
  TextColumn get title => text()();
  TextColumn get status => text().withDefault(const Constant('created'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
} 