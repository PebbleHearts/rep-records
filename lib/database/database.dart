import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:rep_records/database/dao/category_dao.dart';
import 'package:rep_records/database/dao/exercise_dao.dart';
import 'package:rep_records/database/dao/exercise_log_dao.dart';
import 'package:rep_records/database/dao/routine_dao.dart';
import 'package:rep_records/database/dao/routine_exercise_dao.dart';
import 'package:rep_records/database/schema/category.dart';
import 'package:rep_records/database/schema/exercise.dart';
import 'package:rep_records/database/schema/exercise_log.dart';
import 'package:rep_records/database/schema/routine_exercise.dart';
import 'package:rep_records/database/schema/routine_schema.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [Routines, Category, Exercise, RoutineExercises, ExerciseLog],
  daos: [CategoryDao, ExerciseDao, RoutineDao, RoutineExerciseDao, ExerciseLogDao]
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  // IMPORTANT: Increment this version number whenever you:
  // 1. Add a new table
  // 2. Add a new column to an existing table
  // 3. Remove a column from a table
  // 4. Change a column's type
  // 5. Add or modify constraints
  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Add migration logic here when needed
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    print('Database file: ${file.path}');
    return NativeDatabase(file);
  });
}
