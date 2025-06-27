import 'package:drift/drift.dart';
import 'package:rep_records/database/database.dart';
import 'package:rep_records/database/schema/exercise.dart';

part 'exercise_dao.g.dart';

@DriftAccessor(tables: [Exercise])
class ExerciseDao extends DatabaseAccessor<AppDatabase> with _$ExerciseDaoMixin {
  ExerciseDao(super.database);

  Stream<List<ExerciseData>> watchAllExercises() {
    return (select(exercise)..where((t) => t.status.isNotValue('deleted'))).watch();
  }

  Future<List<ExerciseData>> getAllExercises() async {
    return (select(exercise)..where((t) => t.status.isNotValue('deleted'))).get();
  }

  Future<List<ExerciseData>> getAllUnSyncedExercises() async {
    return (select(exercise)..where((t) => t.synced.equals(false))).get();
  }

  Future<List<ExerciseData>> getExercisesByCategory(String categoryId) async {
    return (select(exercise)..where((t) => t.categoryId.equals(categoryId) & t.status.isNotValue('deleted'))).get();
  }

  Future<void> insertExercise(ExerciseCompanion exerciseData) async {
    await into(exercise).insert(exerciseData);
  }

  Future<void> deleteExercise(String id) async {
    await (update(exercise)..where((t) => t.id.equals(id))).write(
      ExerciseCompanion(status: const Value('deleted'), synced: const Value(false))
    );
  }

  Future<void> updateExercise(ExerciseCompanion exerciseData) async {
    await (update(exercise)..where((t) => t.id.equals(exerciseData.id.value))).write(exerciseData);
  }

  Future<void> updateSynced(List<String> exerciseIds) async {
    await (update(exercise)..where((t) => t.id.isIn(exerciseIds))).write(ExerciseCompanion(synced: const Value(true)));
  }
} 