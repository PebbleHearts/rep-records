import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:rep_records/database/dao/category_dao.dart';
import 'package:rep_records/database/dao/exercise_dao.dart';
import 'package:rep_records/database/schema/category.dart';
import 'package:rep_records/database/schema/exercise.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rep_records/constants/common.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Category, Exercise], daos: [CategoryDao, ExerciseDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  // IMPORTANT: Increment this version number whenever you:
  // 1. Add a new table
  // 2. Add a new column to an existing table
  // 3. Remove a column from a table
  // 4. Change a column's type
  // 5. Add or modify constraints
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      // onUpgrade: (Migrator m, int from, int to) async {
      //   if (from < 2) {
      //     // Add equipment column to exercise table
      //     await m.addColumn(exercise, exercise.equipment);
      //   }
      // },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'rep_records_db',
      native: const DriftNativeOptions(
        // By default, `driftDatabase` from `package:drift_flutter` stores the
        // database files in `getApplicationDocumentsDirectory()`.
        databaseDirectory: getApplicationSupportDirectory,
      ),
      // If you need web support, see https://drift.simonbinder.eu/platforms/web/
    );
  }
}
