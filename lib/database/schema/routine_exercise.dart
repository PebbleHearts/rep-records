import 'package:drift/drift.dart';
import 'package:rep_records/constants/common.dart';

@DataClassName('RoutineExercise')
class RoutineExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get routineId => integer()();
  IntColumn get exerciseId => integer()();
} 