import 'package:drift/drift.dart';
import 'package:rep_records/database/database.dart';
import 'package:rep_records/database/schema/exercise.dart';

part 'exercise_dao.g.dart';

@DriftAccessor(tables: [Exercise])
class ExerciseDao extends DatabaseAccessor<AppDatabase> with _$ExerciseDaoMixin {
  ExerciseDao(super.database);

  Stream<List<ExerciseData>> watchAllExercises() {
    return select(exercise).watch();
  }

  Future<List<ExerciseData>> getAllExercises() async {
    return select(exercise).get();
  }

  Future<List<ExerciseData>> getAllUnSyncedExercises() async {
    return (select(exercise)..where((t) => t.synced.equals(false))).get();
  }

  Future<List<ExerciseData>> getExercisesByCategory(int categoryId) async {
    return (select(exercise)..where((t) => t.categoryId.equals(categoryId))).get();
  }

  Future<void> insertExercise(ExerciseCompanion exerciseData) async {
    await into(exercise).insert(exerciseData);
  }

  Future<void> deleteExercise(int id) async {
    await (delete(exercise)..where((t) => t.id.equals(id))).go();
  }

  Future<void> updateExercise(ExerciseCompanion exerciseData) async {
    await (update(exercise)..where((t) => t.id.equals(exerciseData.id.value))).write(exerciseData);
  }

  Future<void> updateSynced(List<int> exerciseIds) async {
    await (update(exercise)..where((t) => t.id.isIn(exerciseIds))).write(ExerciseCompanion(synced: const Value(true)));
  }
} 