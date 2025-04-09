import 'package:drift/drift.dart';
import 'package:rep_records/database/database.dart';
import 'package:rep_records/database/schema/category.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Category])
class CategoryDao extends DatabaseAccessor<AppDatabase> with _$CategoryDaoMixin {
  CategoryDao(super.database);

  Future<List<CategoryData>> getAllCategories() async {
    return select(category).get();
  }

  Future<void> insertCategory(CategoryData categoryData) async {
    await into(category).insert(categoryData);
  }
}
