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
    return (select(exerciseLog)..where((t) => t.status.isNotValue('deleted'))).get();
  }

  Future<List<ExerciseLogData>> getAllUnSyncedExerciseLogs() async {
    return (select(exerciseLog)..where((t) => t.synced.equals(false))).get();
  }

  Future<void> deleteExerciseLog(String id) async {
    await (update(exerciseLog)..where((t) => t.id.equals(id))).write(
      ExerciseLogCompanion(status: const Value('deleted'), synced: const Value(false))
    );
  }

  Stream<List<ExerciseLogWithExercise>> watchLogsForDate(String date) {
    final query = (select(exerciseLog)..where((t) => exerciseLog.sessionDate.equals(date) & t.status.isNotValue('deleted'))).join([
      innerJoin(exercise, exercise.id.equalsExp(exerciseLog.exerciseId)),
    ]);

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
    String? note,
  }) async {
    final updatedSets = List.generate(weights.length, (index) {
      return SetData(
        setNumber: index + 1,
        weight: weights[index] ?? 0,
        reps: reps[index] ?? 0,
      );
    });

    final updatedLog = ExerciseLogCompanion(
      id: Value(logId),
      setsData: Value(ExerciseLogsSetData(sets: updatedSets)),
      notes: Value(note),
      updatedAt: Value(DateTime.now()),
      synced: const Value(false),
    );

    await (update(exerciseLog)..where((t) => t.id.equals(logId))).write(updatedLog);
  }

  Future<void> createLogsForRoutine(String routineId, String date) async {
    final query = select(routines).join([
      leftOuterJoin(
        routineExercises,
        routineExercises.routineId.equalsExp(routines.id),
      ),
    ])..where(routines.id.equals(routineId));

    final rows = await query.get();

    final exercises =
        rows
            .map((row) => row.readTableOrNull(routineExercises))
            .whereType<RoutineExercise>()
            .toList();

    for (final exercise in exercises) {
      // Get the latest log for this exercise to use as prefill data
      final latestLogQuery = select(exerciseLog)
        ..where((t) => t.exerciseId.equals(exercise.exerciseId) & t.status.isNotValue('deleted'))
        ..orderBy([(t) => OrderingTerm.desc(t.sessionDate)])
        ..limit(1);

      final latestLog = await latestLogQuery.getSingleOrNull();

      // Use the latest log's sets data if available, otherwise use default
      final setsData = latestLog?.setsData ?? ExerciseLogsSetData(
        sets: [
          SetData(setNumber: 1, reps: 0, weight: 0),
        ],
      );

      await into(exerciseLog).insert(
        ExerciseLogCompanion.insert(
          exerciseId: exercise.exerciseId,
          sessionDate: date,
          setsData: setsData,
        ),
      );
    }
  }

  Future<void> updateSynced(List<String> exerciseLogIds) async {
    await (update(exerciseLog)..where((t) => t.id.isIn(exerciseLogIds))).write(ExerciseLogCompanion(synced: const Value(true)));
  }
}
