import 'package:drift/drift.dart';
import 'package:rep_records/database/database.dart';
import 'package:rep_records/database/schema/routine.dart';
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

  Stream<List<Routine>> watchAllRoutines() {
    return select(routines).watch();
  }

  Future<List<Routine>> getAllRoutines() async {
    return select(routines).get();
  }

  Future<void> createRoutine(RoutinesCompanion routineData) async {
    await into(routines).insert(routineData);
  }

  Future<void> deleteRoutine(int id) async {
    await (delete(routines)..where((t) => t.id.equals(id))).go();
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
      final Map<int, RoutineWithExercises> result = {};
      
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