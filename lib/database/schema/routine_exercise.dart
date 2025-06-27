import 'package:drift/drift.dart';
import 'package:rep_records/constants/common.dart';

class RoutineExercises extends Table {
  TextColumn get id => text().clientDefault(() => uuidInstance.v4())();
  TextColumn get routineId => text()();
  TextColumn get exerciseId => text()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  TextColumn get status => text().withDefault(const Constant('created'))();
} 