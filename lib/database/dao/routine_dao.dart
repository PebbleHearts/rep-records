import 'package:drift/drift.dart';
import 'package:rep_records/database/database.dart';
import 'package:rep_records/database/schema/routine_schema.dart';
import 'package:rep_records/database/schema/routine_exercise.dart';
import 'package:rep_records/database/schema/exercise.dart';

part 'routine_dao.g.dart';

class RoutineWithExercises {
  final Routine routine;
  final List<ExerciseData> exercises;

  RoutineWithExercises({
    required this.routine,
    required this.exercises,
  });
}

@DriftAccessor(tables: [Routines, RoutineExercises, Exercise])
class RoutineDao extends DatabaseAccessor<AppDatabase> with _$RoutineDaoMixin {
  RoutineDao(super.database);

  Future<void> updateSynced(List<String> routineIds) async {
    await (update(routines)..where((t) => t.id.isIn(routineIds))).write(RoutinesCompanion(synced: const Value(true)));
  }

  Stream<List<Routine>> watchAllRoutines() {
    return select(routines).watch();
  }

  Future<List<Routine>> getAllRoutines() async {
    return select(routines).get();
  }

  Future<List<Routine>> getAllUnSyncedRoutines() async {
    return (select(routines)..where((t) => t.synced.equals(false))).get();
  }

  Future<void> createRoutine(RoutinesCompanion routineData) async {
    await into(routines).insert(routineData);
  }

  Future<void> deleteRoutine(String id) async {
    await (delete(routines)..where((t) => t.id.equals(id))).go();
  }

  Future<void> updateRoutine(String id, RoutinesCompanion routineData) async {
    await (update(routines)..where((t) => t.id.equals(id))).write(routineData);
  }

  Future<RoutineWithExercises?> getRoutineWithExercises(String routineId) async {
    final query = select(routines).join([
      leftOuterJoin(
        routineExercises,
        routineExercises.routineId.equalsExp(routines.id),
      ),
      leftOuterJoin(
        exercise,
        exercise.id.equalsExp(routineExercises.exerciseId),
      ),
    ])
      ..where(routines.id.equals(routineId));

    final rows = await query.get();
    
    if (rows.isEmpty) {
      return null;
    }

    final routineData = rows.first.readTable(routines);
    final exercises = rows
        .map((row) => row.readTableOrNull(exercise))
        .whereType<ExerciseData>()
        .toList();

    return RoutineWithExercises(
      routine: routineData,
      exercises: exercises,
    );
  }

  Stream<List<RoutineWithExercises>> watchAllRoutinesWithExercises() {
    final query = select(routines).join([
      leftOuterJoin(
        routineExercises,
        routineExercises.routineId.equalsExp(routines.id),
      ),
      leftOuterJoin(
        exercise,
        exercise.id.equalsExp(routineExercises.exerciseId),
      ),
    ]);

    return query.watch().map((rows) {
      final Map<String, RoutineWithExercises> result = {};
      
      for (final row in rows) {
        final routineData = row.readTable(routines);
        final exerciseData = row.readTableOrNull(exercise);
        
        if (!result.containsKey(routineData.id)) {
          result[routineData.id] = RoutineWithExercises(
            routine: routineData,
            exercises: [],
          );
        }
        
        if (exerciseData != null) {
          result[routineData.id]!.exercises.add(exerciseData);
        }
      }
      
      return result.values.toList();
    });
  }
} 