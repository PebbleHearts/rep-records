import 'package:drift/drift.dart';
import 'package:rep_records/database/database.dart';
import 'package:rep_records/database/schema/exercise.dart';
import 'package:rep_records/database/schema/exercise_log.dart';
import 'package:rep_records/database/schema/routine_exercise.dart';
import 'package:rep_records/database/schema/routine_schema.dart';

part 'exercise_log_dao.g.dart';

class ExerciseLogWithExercise {
  final ExerciseLogData log;
  final ExerciseData exercise;

  ExerciseLogWithExercise({required this.log, required this.exercise});
}

@DriftAccessor(tables: [ExerciseLog, Exercise, Routines, RoutineExercises])
class ExerciseLogDao extends DatabaseAccessor<AppDatabase>
    with _$ExerciseLogDaoMixin {
  ExerciseLogDao(super.database);

  Stream<List<ExerciseLogWithExercise>> watchLogsForDate(String date) {
    final query = select(exerciseLog).join([
      innerJoin(exercise, exercise.id.equalsExp(exerciseLog.exerciseId)),
    ])..where(exerciseLog.sessionDate.equals(date));

    return query.watch().map((rows) {
      final List<ExerciseLogWithExercise> result = [];

      for (final row in rows) {
        final logData = row.readTable(exerciseLog);
        final exerciseData = row.readTableOrNull(exercise);

        if (exerciseData != null) {
          result.add(
            ExerciseLogWithExercise(log: logData, exercise: exerciseData),
          );
        }
      }

      return result;
    });
  }

  Future<void> createLogsForRoutine(int routineId, String date) async {
    print('inside createLogsForRoutine');
    final query = select(routines).join([
      leftOuterJoin(
        routineExercises,
        routineExercises.routineId.equalsExp(routines.id),
      ),
    ])..where(routines.id.equals(routineId));
    print('inside createLogsForRoutine 2');

    final rows = await query.get();

    if (rows.isEmpty) {
      print('inside createLogsForRoutine 3');
    }

    final exercises =
        rows
            .map((row) => row.readTableOrNull(routineExercises))
            .whereType<RoutineExercise>()
            .toList();
    print('inside createLogsForRoutine 4');
    print(rows);
    print(exercises);

    for (final exercise in exercises) {
      print('Creating log for exercise ${exercise.id}');
      await into(exerciseLog).insert(
        ExerciseLogCompanion.insert(
          exerciseId: exercise.id,
          sessionDate: date,
          setsData: ExerciseLogsSetData(
            sets: [
              SetData(setNumber: 1, reps: 0, weight: 0),
              SetData(setNumber: 2, reps: 0, weight: 0),
              SetData(setNumber: 3, reps: 0, weight: 0),
            ],
          ),
        ),
      );
    }
  }
}
