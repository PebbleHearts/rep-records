import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:rep_records/database/dao/exercise_log_dao.dart';
import 'package:rep_records/database/dao/log_day_details_dao.dart';
import 'package:rep_records/database/dao/routine_dao.dart';
import 'package:rep_records/database/database.dart';
import 'package:rep_records/main.dart';
import 'package:rep_records/screens/edit-log-screen/components/exercise_card.dart';
import 'package:rep_records/theme/app_theme.dart';

class EditLogScreen extends StatefulWidget {
  final String routineId;
  final String date;
  final String? routineName;

  const EditLogScreen({
    super.key,
    required this.routineId,
    required this.date,
    this.routineName,
  });

  @override
  State<EditLogScreen> createState() => _EditLogScreenState();
}

class _EditLogScreenState extends State<EditLogScreen> {
  late Stream<List<ExerciseLogWithExercise>> _logsStream;
  final Map<String, List<TextEditingController>> _weightControllers = {};
  final Map<String, List<TextEditingController>> _repsControllers = {};
  final Map<String, TextEditingController> _noteControllers = {};
  final _titleController = TextEditingController();
  final _exerciseLogDao = ExerciseLogDao(database);
  final _logDayDetailsDao = LogDayDetailsDao(database);

  @override
  void initState() {
    super.initState();
    if (widget.routineId.isNotEmpty) {
      // Create logs for the routine
      print('Creating logs for routine ${widget.routineId} on date ${widget.date}');
      _exerciseLogDao.createLogsForRoutine(widget.routineId, widget.date);
    }
    _loadLogs();
    _loadLogDayDetails();
    _createLogDayDetailsIfNeeded();
  }

  void _loadLogs() {
    _logsStream = _exerciseLogDao.watchLogsForDate(widget.date);
  }

  Future<void> _loadLogDayDetails() async {
    final existingLogDay = await _logDayDetailsDao.getLogDayDetailsByDate(widget.date);
    if (existingLogDay != null) {
      _titleController.text = existingLogDay.title;
    } else if (widget.routineName != null && widget.routineName!.isNotEmpty) {
      // Set routine name as default title if no existing log day details
      _titleController.text = widget.routineName!;
    }
  }

  Future<void> _createLogDayDetailsIfNeeded() async {
    if (widget.routineName != null && widget.routineName!.isNotEmpty) {
      final existingLogDay = await _logDayDetailsDao.getLogDayDetailsByDate(widget.date);
      if (existingLogDay == null) {
        // Create new log day details with routine name as title
        await _logDayDetailsDao.insertLogDayDetails(
          LogDayDetailsCompanion.insert(
            sessionDate: widget.date,
            title: widget.routineName!,
          ),
        );
      }
    }
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
    for (final controller in _noteControllers.values) {
      controller.dispose();
    }
    _titleController.dispose();
    super.dispose();
  }

  void _initializeControllers(String exerciseId, ExerciseLogData? log) {
    if (!_weightControllers.containsKey(exerciseId)) {
      // Initialize with at least 1 set, or based on existing log data
      int initialSetCount = 1;
      if (log != null && log.setsData.sets.isNotEmpty) {
        initialSetCount = log.setsData.sets.length;
      }
      
      _weightControllers[exerciseId] = List.generate(
        initialSetCount,
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
      // Initialize with same count as weight controllers
      int initialSetCount = _weightControllers[exerciseId]!.length;
      
      _repsControllers[exerciseId] = List.generate(
        initialSetCount,
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
    if (!_noteControllers.containsKey(exerciseId)) {
      final controller = TextEditingController();
      if (log != null && log.notes != null) {
        controller.text = log.notes!;
      }
      _noteControllers[exerciseId] = controller;
    }
  }

  void _addSet(String exerciseId) {
    setState(() {
      _weightControllers[exerciseId]?.add(TextEditingController());
      _repsControllers[exerciseId]?.add(TextEditingController());
    });
  }

  void _deleteSet(String exerciseId, int index) {
    setState(() {
      if (_weightControllers[exerciseId]!.length > 1) {
        _weightControllers[exerciseId]![index].dispose();
        _weightControllers[exerciseId]!.removeAt(index);
        _repsControllers[exerciseId]![index].dispose();
        _repsControllers[exerciseId]!.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        title: Text(widget.date),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Tap to add a title...',
                      hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.4),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                    ),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ...logs.map((logWithExercise) {
                  final exerciseId = logWithExercise.log.exerciseId;
                  _initializeControllers(exerciseId, logWithExercise.log);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ExerciseCard(
                      exerciseName: logWithExercise.exercise.name,
                      weightControllers: _weightControllers[exerciseId]!,
                      repsControllers: _repsControllers[exerciseId]!,
                      noteController: _noteControllers[exerciseId]!,
                      onAddSet: () => _addSet(exerciseId),
                      onDeleteSet: (index) => _deleteSet(exerciseId, index),
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
        final noteController = _noteControllers[exerciseId]!;
        
        // Get the values from controllers (now dynamic length)
        final weights = weightControllers.map((controller) {
          final value = controller.text.trim();
          return value.isEmpty ? null : double.tryParse(value);
        }).toList();
        
        final reps = repsControllers.map((controller) {
          final value = controller.text.trim();
          return value.isEmpty ? null : int.tryParse(value);
        }).toList();

        final note = noteController.text.trim();
        
        // Update the log in database
        await _exerciseLogDao.updateLog(
          log.id,
          weights: weights,
          reps: reps,
          note: note.isEmpty ? null : note,
        );
      }

      // Update the log day details if title has changed
      final title = _titleController.text.trim();
      final existingLogDay = await _logDayDetailsDao.getLogDayDetailsByDate(widget.date);
      if (existingLogDay != null && title != existingLogDay.title) {
        // Update existing log day details (including empty title)
        await _logDayDetailsDao.updateLogDayDetails(
          LogDayDetailsCompanion(
            id: drift.Value(existingLogDay.id),
            title: drift.Value(title),
          ),
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