import 'package:drift/drift.dart';
import 'package:rep_records/database/database.dart';
import 'package:rep_records/database/schema/routine_exercise.dart';

part 'routine_exercise_dao.g.dart';

@DriftAccessor(tables: [RoutineExercises])
class RoutineExerciseDao extends DatabaseAccessor<AppDatabase> with _$RoutineExerciseDaoMixin {
  RoutineExerciseDao(super.database);

  Future<List<RoutineExercise>> getExercisesForRoutine(int routineId) =>
      (select(routineExercises)..where((r) => r.routineId.equals(routineId))).get();

  Future<List<RoutineExercise>> getAllRoutineExercises() =>
      (select(routineExercises)).get();

  Future<List<RoutineExercise>> getAllUnSyncedRoutineExercises() =>
      (select(routineExercises)..where((t) => t.synced.equals(false))).get();
  
  Future<int> addExerciseToRoutine(RoutineExercisesCompanion exercise) =>
      into(routineExercises).insert(exercise);

  Future<void> deleteExerciseFromRoutine(int routineId, int exerciseId) async {
    await (delete(routineExercises)
      ..where((t) => t.routineId.equals(routineId) & t.exerciseId.equals(exerciseId)))
      .go();
  }
} 