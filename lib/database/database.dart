import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:rep_records/database/dao/category_dao.dart';
import 'package:rep_records/database/schema/category.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rep_records/constants/common.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Category], daos: [CategoryDao])
class AppDatabase extends _$AppDatabase {

  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    });
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

