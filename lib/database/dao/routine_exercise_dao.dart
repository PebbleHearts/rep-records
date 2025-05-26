import 'package:drift/drift.dart';
import 'package:rep_records/database/database.dart';
import 'package:rep_records/database/schema/routine_exercise.dart';

part 'routine_exercise_dao.g.dart';

@DriftAccessor(tables: [RoutineExercises])
class RoutineExerciseDao extends DatabaseAccessor<AppDatabase> with _$RoutineExerciseDaoMixin {
  RoutineExerciseDao(super.database);

  Future<List<RoutineExercise>> getExercisesForRoutine(int routineId) =>
      (select(routineExercises)..where((r) => r.routineId.equals(routineId))).get();
  
  Future<int> addExerciseToRoutine(RoutineExercisesCompanion exercise) =>
      into(routineExercises).insert(exercise);
} 