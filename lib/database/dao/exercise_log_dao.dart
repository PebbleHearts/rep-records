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

  Future<List<ExerciseLogData>> getAllExerciseLogs() async {
    return select(exerciseLog).get();
  }

  Future<List<ExerciseLogData>> getAllUnSyncedExerciseLogs() async {
    return (select(exerciseLog)..where((t) => t.synced.equals(false))).get();
  }

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

  Future<List<ExerciseLogData>> getLogsForDate(String date) async {
    final query = select(exerciseLog)..where((t) => t.sessionDate.equals(date));
    return query.get();
  }

  Future<void> updateLog(
    String logId, {
    required List<double?> weights,
    required List<int?> reps,
  }) async {
    final log = await (select(exerciseLog)..where((t) => t.id.equals(logId))).getSingle();

    print('updating log ${log.id} with weights $weights and reps $reps');
    
    final updatedSets = List.generate(3, (index) {
      return SetData(
        setNumber: index + 1,
        weight: weights[index] ?? 0,
        reps: reps[index] ?? 0,
      );
    });

    final updatedLog = ExerciseLogCompanion(
      id: Value(logId),
      setsData: Value(ExerciseLogsSetData(sets: updatedSets)),
      updatedAt: Value(DateTime.now()),
    );

    await (update(exerciseLog)..where((t) => t.id.equals(logId))).write(updatedLog);
  }

  Future<void> createLogsForRoutine(String routineId, String date) async {
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
          exerciseId: exercise.exerciseId,
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

  Future<void> updateSynced(List<String> exerciseLogIds) async {
    await (update(exerciseLog)..where((t) => t.id.isIn(exerciseLogIds))).write(ExerciseLogCompanion(synced: const Value(true)));
  }
}
