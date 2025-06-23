import 'package:flutter/material.dart';
import 'package:rep_records/database/dao/exercise_log_dao.dart';
import 'package:rep_records/database/dao/routine_dao.dart';
import 'package:rep_records/database/database.dart';
import 'package:rep_records/main.dart';
import 'package:rep_records/screens/edit-log-screen/components/exercise_card.dart';
import 'package:rep_records/theme/app_theme.dart';

class EditLogScreen extends StatefulWidget {
  final int routineId;
  final String date;

  const EditLogScreen({
    super.key,
    required this.routineId,
    required this.date,
  });

  @override
  State<EditLogScreen> createState() => _EditLogScreenState();
}

class _EditLogScreenState extends State<EditLogScreen> {
  late Stream<List<ExerciseLogWithExercise>> _logsStream;
  final Map<int, List<TextEditingController>> _weightControllers = {};
  final Map<int, List<TextEditingController>> _repsControllers = {};
  final _exerciseLogDao = ExerciseLogDao(database);

  @override
  void initState() {
    super.initState();
    if (widget.routineId != -1) {
      // Create logs for the routine
      print('Creating logs for routine ${widget.routineId} on date ${widget.date}');
      _exerciseLogDao.createLogsForRoutine(widget.routineId, widget.date);
    }
    _loadLogs();
  }

  void _loadLogs() {
    _logsStream = _exerciseLogDao.watchLogsForDate(widget.date);
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (final controllers in _weightControllers.values) {
      for (final controller in controllers) {
        controller.dispose();
      }
    }
    for (final controllers in _repsControllers.values) {
      for (final controller in controllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void _initializeControllers(int exerciseId, ExerciseLogData? log) {
    if (!_weightControllers.containsKey(exerciseId)) {
      _weightControllers[exerciseId] = List.generate(
        3,
        (index) {
          final controller = TextEditingController();
          if (log != null && index < log.setsData.sets.length) {
            final weight = log.setsData.sets[index].weight;
            if (weight > 0) {
              controller.text = weight.toString();
            }
          }
          return controller;
        },
      );
    }
    if (!_repsControllers.containsKey(exerciseId)) {
      _repsControllers[exerciseId] = List.generate(
        3,
        (index) {
          final controller = TextEditingController();
          if (log != null && index < log.setsData.sets.length) {
            final reps = log.setsData.sets[index].reps;
            if (reps > 0) {
              controller.text = reps.toString();
            }
          }
          return controller;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        title: Text('Edit Log - ${widget.date}'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveLogs,
        backgroundColor: theme.accent,
        icon: const Icon(Icons.save),
        label: const Text('Save'),
      ),
      body: StreamBuilder<List<ExerciseLogWithExercise>>(
        stream: _logsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading logs: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final logs = snapshot.data ?? [];

          if (logs.isEmpty) {
            return const Center(
              child: Text('No logs found for this date'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exercise Logs',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ...logs.map((logWithExercise) {
                  _initializeControllers(logWithExercise.log.exerciseId, logWithExercise.log);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ExerciseCard(
                      exerciseName: logWithExercise.exercise.name,
                      weightControllers: _weightControllers[logWithExercise.log.exerciseId]!,
                      repsControllers: _repsControllers[logWithExercise.log.exerciseId]!,
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _saveLogs() async {
    try {
      final logs = await _exerciseLogDao.getLogsForDate(widget.date);
      
      for (final log in logs) {
        final exerciseId = log.exerciseId;
        final weightControllers = _weightControllers[exerciseId]!;
        final repsControllers = _repsControllers[exerciseId]!;
        
        // Get the values from controllers
        final weights = weightControllers.map((controller) {
          final value = controller.text.trim();
          return value.isEmpty ? null : double.tryParse(value);
        }).toList();
        
        final reps = repsControllers.map((controller) {
          final value = controller.text.trim();
          return value.isEmpty ? null : int.tryParse(value);
        }).toList();
        // Update the log in database
        await _exerciseLogDao.updateLog(
          log.id,
          weights: weights,
          reps: reps,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logs saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving logs: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}