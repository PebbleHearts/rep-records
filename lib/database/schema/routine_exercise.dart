import 'package:drift/drift.dart';
import 'package:rep_records/constants/common.dart';

class RoutineExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get routineId => integer()();
  IntColumn get exerciseId => integer()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
} 