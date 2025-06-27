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
    final exercises = await ExerciseDao(database).getAllUnSyncedExercises();
    
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'upsync',
        body: {
          'table': 'exercises',
          'tableData': exercises.map((exercise) => {
            'id': exercise.id,
            'name': exercise.name,
            'status': exercise.status,
            'equipment': exercise.equipment,
            'category_id': exercise.categoryId,
          }).toList(),
        },
      );
      
      if (response.status != 200) {
        throw Exception('Failed to sync exercises: ${response.data}');
      }
      
      await ExerciseDao(database).updateSynced(exercises.map((exercise) => exercise.id).toList());
      print('Exercises synced successfully');
    } catch (e) {
      print('Error syncing exercises: $e');
      rethrow;
    }
  }

  static Future<void> upSyncRoutines() async {
    final routines = await RoutineDao(database).getAllUnSyncedRoutines();
    
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'upsync',
        body: {
          'table': 'routines',
          'tableData': routines.map((routine) => {
            'id': routine.id,
            'name': routine.name,
            'status': routine.status,
          }).toList(),
        },
      );
      
      if (response.status != 200) {
        throw Exception('Failed to sync routines: ${response.data}');
      }
      
      await RoutineDao(database).updateSynced(routines.map((routine) => routine.id).toList());
      print('Routines synced successfully');
    } catch (e) {
      print('Error syncing routines: $e');
      rethrow;
    }
  }

  static Future<void> upSyncRoutineExercises() async {
    final routineExercises = await RoutineExerciseDao(database).getAllUnSyncedRoutineExercises();
    
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'upsync',
        body: {
          'table': 'routine_exercises',
          'tableData': routineExercises.map((routineExercise) => {
            'id': routineExercise.id,
            'routine_id': routineExercise.routineId,
            'exercise_id': routineExercise.exerciseId,
            'status': routineExercise.status,
          }).toList(),
        },
      );
      
      if (response.status != 200) {
        throw Exception('Failed to sync routine exercises: ${response.data}');
      }
      
      await RoutineExerciseDao(database).updateSynced(routineExercises.map((routineExercise) => routineExercise.id).toList());
      print('Routine exercises synced successfully');
    } catch (e) {
      print('Error syncing routine exercises: $e');
      rethrow;
    }
  }

  static Future<void> upSyncExerciseLogs() async {
    final exerciseLogs = await ExerciseLogDao(database).getAllUnSyncedExerciseLogs();
    
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'upsync',
        body: {
          'table': 'exercise_logs',
          'tableData': exerciseLogs.map((exerciseLog) => {
            'id': exerciseLog.id,
            'exercise_id': exerciseLog.exerciseId,
            'session_date': exerciseLog.sessionDate,
            'sets_data': exerciseLog.setsData.toJson(),
            'notes': exerciseLog.notes,
            'status': exerciseLog.status,
          }).toList(),
        },
      );
      
      if (response.status != 200) {
        throw Exception('Failed to sync exercise logs: ${response.data}');
      }
      
      await ExerciseLogDao(database).updateSynced(exerciseLogs.map((exerciseLog) => exerciseLog.id).toList());
      print('Exercise logs synced successfully');
    } catch (e) {
      print('Error syncing exercise logs: $e');
      rethrow;
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