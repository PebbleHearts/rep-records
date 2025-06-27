import 'package:drift/drift.dart';
import 'package:rep_records/database/database.dart';
import 'package:rep_records/database/schema/category.dart';
import 'package:rep_records/database/schema/exercise.dart';

part 'category_dao.g.dart';

class CategoryWithExercises {
  final String categoryId;
  final String categoryName;
  final List<ExerciseData> exercises;

  CategoryWithExercises({
    required this.categoryId,
    required this.categoryName,
    required this.exercises,
  });
}

@DriftAccessor(tables: [Category, Exercise])
class CategoryDao extends DatabaseAccessor<AppDatabase> with _$CategoryDaoMixin {
  CategoryDao(super.database);

  Future<void> updateSynced(List<String> categoryIds) async {
    await (update(category)..where((t) => t.id.isIn(categoryIds))).write(CategoryCompanion(synced: const Value(true)));
  }

  Stream<List<CategoryData>> watchAllCategories() {
    return (select(category)..where((t) => t.status.isNotValue('deleted'))).watch();
  }

  Future<List<CategoryData>> getAllCategories() async {
    return (select(category)..where((t) => t.status.isNotValue('deleted'))).get();
  }

  Future<List<CategoryData>> getAllUnSyncedCategories() async {
    return (select(category)..where((t) => t.synced.equals(false))).get();
  }

  Future<void> insertCategory(CategoryCompanion categoryData) async {
    await into(category).insert(categoryData);
  }

  Future<void> updateCategory(CategoryCompanion categoryData) async {
    await (update(category)..where((t) => t.id.equals(categoryData.id.value))).write(categoryData);
  }

  Future<void> deleteCategory(String id) async {
    await (update(category)..where((t) => t.id.equals(id))).write(CategoryCompanion(status: const Value('deleted'), synced: const Value(false)));
  }

  Future<List<CategoryWithExercises>> getCategoriesWithExercises() async {
    final query = select(category).join([
      leftOuterJoin(exercise, exercise.categoryId.equalsExp(category.id) & exercise.status.isNotValue('deleted')),
    ]);

    final rows = await query.get();
    final Map<String, CategoryWithExercises> result = {};
    
    for (final row in rows) {
      final categoryData = row.readTable(category);
      final exerciseData = row.readTableOrNull(exercise);
      
      if (!result.containsKey(categoryData.id)) {
        result[categoryData.id] = CategoryWithExercises(
          categoryId: categoryData.id,
          categoryName: categoryData.name,
          exercises: [],
        );
      }
      
      if (exerciseData != null) {
        result[categoryData.id]!.exercises.add(exerciseData);
      }
    }
    
    return result.values.toList();
  }

  Stream<List<CategoryWithExercises>> watchCategoriesWithExercises() {
    final query = (select(category)..where((t) => t.status.isNotValue('deleted'))).join([
      leftOuterJoin(exercise, exercise.categoryId.equalsExp(category.id) & exercise.status.isNotValue('deleted')),
    ]);

    return query.watch().map((rows) {
      final Map<String, CategoryWithExercises> result = {};
      
      for (final row in rows) {
        final categoryData = row.readTable(category);
        final exerciseData = row.readTableOrNull(exercise);

        print('categoryData: ${categoryData.id} ${categoryData.name} ${categoryData.status}');
        print('exerciseData: ${exerciseData?.id} ${exerciseData?.name} ${exerciseData?.status}');
        
        if (!result.containsKey(categoryData.id)) {
          result[categoryData.id] = CategoryWithExercises(
            categoryId: categoryData.id,
            categoryName: categoryData.name,
            exercises: [],
          );
        }
        
        if (exerciseData != null) {
          result[categoryData.id]!.exercises.add(exerciseData);
        }
      }
      
      return result.values.toList();
    });
  }
}
