import 'package:flutter/material.dart';
import 'package:rep_records/database/dao/exercise_log_dao.dart';
import 'package:rep_records/database/dao/routine_dao.dart';
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

  void _initializeControllers(int exerciseId) {
    if (!_weightControllers.containsKey(exerciseId)) {
      _weightControllers[exerciseId] = List.generate(
        3,
        (index) => TextEditingController(),
      );
    }
    if (!_repsControllers.containsKey(exerciseId)) {
      _repsControllers[exerciseId] = List.generate(
        3,
        (index) => TextEditingController(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).extension<AppTheme>()!.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        title: Text('Edit Log - ${widget.date}'),
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
                  _initializeControllers(logWithExercise.log.exerciseId);
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
}