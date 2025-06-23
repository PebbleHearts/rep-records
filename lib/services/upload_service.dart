import 'package:rep_records/database/dao/category_dao.dart';
import 'package:rep_records/database/dao/exercise_dao.dart';
import 'package:rep_records/database/dao/exercise_log_dao.dart';
import 'package:rep_records/database/dao/routine_dao.dart';
import 'package:rep_records/database/dao/routine_exercise_dao.dart';
import 'package:rep_records/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadService {
  final supabase = Supabase.instance.client;

  static Future<void> upSyncCategories() async {
    final categories = await CategoryDao(database).getAllUnSyncedCategories();
    
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'upsync',
        body: {
          'table': 'categories',
          'tableData': categories.map((category) => {
            'id': category.id,
            'name': category.name,
            'status': category.status,
          }).toList(),
        },
      );
      
      if (response.status != 200) {
        throw Exception('Failed to sync categories: ${response.data}');
      }
      
      await CategoryDao(database).updateSynced(categories.map((category) => category.id).toList());
      print('Categories synced successfully');
    } catch (e) {
      print('Error syncing categories: $e');
      rethrow;
    }
  }

  static Future<void> upSyncExercises() async {
    final exercises = await ExerciseDao(database).getAllExercises();

    for (var exercise in exercises) {
      print(exercise.name);
    }
  }

  static Future<void> upSyncRoutines() async {
    final routines = await RoutineDao(database).getAllRoutines();

    for (var routine in routines) {
      print(routine.name);
    }
  }

  static Future<void> upSyncRoutineExercises() async {
    final routineExercises = await RoutineExerciseDao(database).getAllRoutineExercises();

    for (var routineExercise in routineExercises) {
      print(routineExercise.exerciseId);
    }
  }

  static Future<void> upSyncExerciseLogs() async {
    final exerciseLogs = await ExerciseLogDao(database).getAllExerciseLogs();

    for (var exerciseLog in exerciseLogs) {
      print(exerciseLog.sessionDate);
    }
  }

  static Future<void> upSync() async {
    await upSyncCategories();
    await upSyncExercises();
    await upSyncRoutines();
    await upSyncRoutineExercises();
    await upSyncExerciseLogs();
  }
}