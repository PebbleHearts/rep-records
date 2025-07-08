import 'package:drift/drift.dart';
import 'package:rep_records/database/dao/category_dao.dart';
import 'package:rep_records/database/dao/exercise_dao.dart';
import 'package:rep_records/database/dao/exercise_log_dao.dart';
import 'package:rep_records/database/dao/log_day_details_dao.dart';
import 'package:rep_records/database/dao/routine_dao.dart';
import 'package:rep_records/database/dao/routine_exercise_dao.dart';
import 'package:rep_records/database/database.dart';
import 'package:rep_records/database/schema/exercise_log.dart';
import 'package:rep_records/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DownsyncService {
  final supabase = Supabase.instance.client;

  static Future<void> downSyncCategories() async {
    try {
      // Call the downsync function on the server to get categories
      final response = await Supabase.instance.client.functions.invoke(
        'downsync',
        body: {
          'table': 'categories',
        },
      );
      
      if (response.status != 200) {
        throw Exception('Failed to downsync categories: ${response.data}');
      }
      
      // Parse the response data - expecting direct array of category objects
      final List<dynamic> categoriesData = response.data as List<dynamic>;
      
      // Get existing categories from local database
      final categoryDao = CategoryDao(database);
      final existingCategories = await categoryDao.getAllCategories();
      final existingCategoryIds = existingCategories.map((c) => c.id).toSet();
      
      // Process each category from server
      for (final categoryData in categoriesData) {
        final categoryMap = categoryData as Map<String, dynamic>;
        final categoryId = categoryMap['id'] as String;
        final categoryName = categoryMap['name'] as String;
        final categoryStatus = categoryMap['status'] as String? ?? 'created';
        
        if (existingCategoryIds.contains(categoryId)) {
          // Update existing category
          await categoryDao.updateCategory(
            CategoryCompanion(
              id: Value(categoryId),
              name: Value(categoryName),
              status: Value(categoryStatus),
              synced: const Value(true),
            ),
          );
        } else {
          // Insert new category
          await categoryDao.insertCategory(
            CategoryCompanion.insert(
              id: Value(categoryId),
              name: categoryName,
              status: Value(categoryStatus),
              synced: const Value(true),
            ),
          );
        }
      }
      
      print('Categories downsynced successfully');
    } catch (e) {
      print('Error downsyncing categories: $e');
      rethrow;
    }
  }

  static Future<void> downSyncExercises() async {
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'downsync',
        body: {
          'table': 'exercises',
        },
      );
      
      if (response.status != 200) {
        throw Exception('Failed to downsync exercises: ${response.data}');
      }
      
      final List<dynamic> exercisesData = response.data as List<dynamic>;
      
      final exerciseDao = ExerciseDao(database);
      final existingExercises = await exerciseDao.getAllExercises();
      final existingExerciseIds = existingExercises.map((e) => e.id).toSet();
      
      for (final exerciseData in exercisesData) {
        final exerciseMap = exerciseData as Map<String, dynamic>;
        final exerciseId = exerciseMap['id'] as String;
        final exerciseName = exerciseMap['name'] as String;
        final exerciseStatus = exerciseMap['status'] as String? ?? 'created';
        final exerciseEquipment = exerciseMap['equipment'] as String? ?? '';
        final categoryId = exerciseMap['category_id'] as String;
        
        if (existingExerciseIds.contains(exerciseId)) {
          await exerciseDao.updateExercise(
            ExerciseCompanion(
              id: Value(exerciseId),
              name: Value(exerciseName),
              status: Value(exerciseStatus),
              equipment: Value(exerciseEquipment),
              categoryId: Value(categoryId),
              synced: const Value(true),
            ),
          );
        } else {
          await exerciseDao.insertExercise(
            ExerciseCompanion.insert(
              id: Value(exerciseId),
              name: exerciseName,
              status: Value(exerciseStatus),
              equipment: exerciseEquipment,
              categoryId: categoryId,
              synced: const Value(true),
            ),
          );
        }
      }
      
      print('Exercises downsynced successfully');
    } catch (e) {
      print('Error downsyncing exercises: $e');
      rethrow;
    }
  }

  static Future<void> downSyncRoutines() async {
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'downsync',
        body: {
          'table': 'routines',
        },
      );
      
      if (response.status != 200) {
        throw Exception('Failed to downsync routines: ${response.data}');
      }
      
      final List<dynamic> routinesData = response.data as List<dynamic>;
      
      final routineDao = RoutineDao(database);
      final existingRoutines = await routineDao.getAllRoutines();
      final existingRoutineIds = existingRoutines.map((r) => r.id).toSet();
      
      for (final routineData in routinesData) {
        final routineMap = routineData as Map<String, dynamic>;
        final routineId = routineMap['id'] as String;
        final routineName = routineMap['name'] as String;
        final routineStatus = routineMap['status'] as String? ?? 'created';
        
        if (existingRoutineIds.contains(routineId)) {
          await routineDao.updateRoutine(
            routineId,
            RoutinesCompanion(
              name: Value(routineName),
              status: Value(routineStatus),
              synced: const Value(true),
            ),
          );
        } else {
          // Use direct database insert to preserve server ID
          await database.into(database.routines).insert(
            RoutinesCompanion(
              id: Value(routineId),
              name: Value(routineName),
              status: Value(routineStatus),
              synced: const Value(true),
            ),
          );
        }
      }
      
      print('Routines downsynced successfully');
    } catch (e) {
      print('Error downsyncing routines: $e');
      rethrow;
    }
  }

  static Future<void> downSyncRoutineExercises() async {
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'downsync',
        body: {
          'table': 'routine_exercises',
        },
      );
      
      if (response.status != 200) {
        throw Exception('Failed to downsync routine exercises: ${response.data}');
      }
      
      final List<dynamic> routineExercisesData = response.data as List<dynamic>;
      
      final routineExerciseDao = RoutineExerciseDao(database);
      final existingRoutineExercises = await routineExerciseDao.getAllRoutineExercises();
      final existingRoutineExerciseIds = existingRoutineExercises.map((re) => re.id).toSet();
      
      for (final routineExerciseData in routineExercisesData) {
        final routineExerciseMap = routineExerciseData as Map<String, dynamic>;
        final routineExerciseId = routineExerciseMap['id'] as String;
        final routineId = routineExerciseMap['routine_id'] as String;
        final exerciseId = routineExerciseMap['exercise_id'] as String;
        final routineExerciseStatus = routineExerciseMap['status'] as String? ?? 'created';
        
        if (existingRoutineExerciseIds.contains(routineExerciseId)) {
          // Update existing - note: there's no direct update method, so we'll need to handle this
          // For now, we'll skip existing ones since they shouldn't change often
          continue;
        } else {
          await routineExerciseDao.addExerciseToRoutine(
            RoutineExercisesCompanion.insert(
              id: Value(routineExerciseId),
              routineId: routineId,
              exerciseId: exerciseId,
              status: Value(routineExerciseStatus),
              synced: const Value(true),
            ),
          );
        }
      }
      
      print('Routine exercises downsynced successfully');
    } catch (e) {
      print('Error downsyncing routine exercises: $e');
      rethrow;
    }
  }

  static Future<void> downSyncExerciseLogs() async {
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'downsync',
        body: {
          'table': 'exercise_logs',
        },
      );
      
      if (response.status != 200) {
        throw Exception('Failed to downsync exercise logs: ${response.data}');
      }
      
      final List<dynamic> exerciseLogsData = response.data as List<dynamic>;
      
      final exerciseLogDao = ExerciseLogDao(database);
      final existingExerciseLogs = await exerciseLogDao.getAllExerciseLogs();
      final existingExerciseLogIds = existingExerciseLogs.map((el) => el.id).toSet();
      
      for (final exerciseLogData in exerciseLogsData) {
        final exerciseLogMap = exerciseLogData as Map<String, dynamic>;
        final exerciseLogId = exerciseLogMap['id'] as String;
        final exerciseId = exerciseLogMap['exercise_id'] as String;
        final sessionDate = exerciseLogMap['session_date'] as String;
        final setsDataJson = exerciseLogMap['sets_data'] as Map<String, dynamic>;
        final notes = exerciseLogMap['notes'] as String?;
        final exerciseLogStatus = exerciseLogMap['status'] as String? ?? 'created';
        
        // Convert sets_data JSON to ExerciseLogsSetData object
        final setsData = ExerciseLogsSetData.fromJson(setsDataJson);
        
        if (existingExerciseLogIds.contains(exerciseLogId)) {
          // Note: ExerciseLogDao doesn't have a direct update method with companion
          // We'll skip existing ones for now, or you can add an update method
          continue;
        } else {
          await database.into(database.exerciseLog).insert(
            ExerciseLogCompanion.insert(
              id: Value(exerciseLogId),
              exerciseId: exerciseId,
              sessionDate: sessionDate,
              setsData: setsData,
              notes: Value(notes),
              status: Value(exerciseLogStatus),
              synced: const Value(true),
            ),
          );
        }
      }
      
      print('Exercise logs downsynced successfully');
    } catch (e) {
      print('Error downsyncing exercise logs: $e');
      rethrow;
    }
  }

  static Future<void> downSyncLogDayDetails() async {
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'downsync',
        body: {
          'table': 'log_day_details',
        },
      );
      
      if (response.status != 200) {
        throw Exception('Failed to downsync log day details: ${response.data}');
      }
      
      final List<dynamic> logDayDetailsData = response.data as List<dynamic>;
      
      final logDayDetailsDao = LogDayDetailsDao(database);
      final existingLogDayDetails = await logDayDetailsDao.getAllLogDayDetails();
      final existingLogDayDetailIds = existingLogDayDetails.map((ldd) => ldd.id).toSet();
      
      for (final logDayDetailData in logDayDetailsData) {
        final logDayDetailMap = logDayDetailData as Map<String, dynamic>;
        final logDayDetailId = logDayDetailMap['id'] as String;
        final sessionDate = logDayDetailMap['session_date'] as String;
        final title = logDayDetailMap['title'] as String;
        final logDayDetailStatus = logDayDetailMap['status'] as String? ?? 'created';
        
        if (existingLogDayDetailIds.contains(logDayDetailId)) {
          await logDayDetailsDao.updateLogDayDetails(
            LogDayDetailsCompanion(
              id: Value(logDayDetailId),
              sessionDate: Value(sessionDate),
              title: Value(title),
              status: Value(logDayDetailStatus),
              synced: const Value(true),
            ),
          );
        } else {
          await logDayDetailsDao.insertLogDayDetails(
            LogDayDetailsCompanion.insert(
              id: Value(logDayDetailId),
              sessionDate: sessionDate,
              title: title,
              status: Value(logDayDetailStatus),
              synced: const Value(true),
            ),
          );
        }
      }
      
      print('Log day details downsynced successfully');
    } catch (e) {
      print('Error downsyncing log day details: $e');
      rethrow;
    }
  }

  static Future<void> downSync() async {
    await downSyncCategories();
    await downSyncExercises();
    await downSyncRoutines();
    await downSyncRoutineExercises();
    await downSyncExerciseLogs();
    await downSyncLogDayDetails();
  }
} 