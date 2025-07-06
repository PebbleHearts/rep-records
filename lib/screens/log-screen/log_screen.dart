import 'package:flutter/material.dart';
import 'package:rep_records/components/horizontal-date-selector/horizontal_date_selector.dart';
import 'package:rep_records/main.dart';
import 'package:rep_records/screens/edit-log-screen/edit_log_screen.dart';
import 'package:rep_records/screens/log-screen/components/log_item.dart';
import 'package:rep_records/screens/log-screen/components/routine_selection_sheet.dart';
import 'package:rep_records/screens/log-screen/components/calendar_selection_sheet.dart';
import 'package:rep_records/theme/app_theme.dart';
import 'package:rep_records/database/database.dart';
import 'package:rep_records/database/dao/exercise_log_dao.dart';
import 'package:rep_records/database/dao/log_day_details_dao.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  late String _selectedDate;
  late ExerciseLogDao _exerciseLogDao;
  late LogDayDetailsDao _logDayDetailsDao;

  @override
  void initState() {
    super.initState();
    // Initialize with current date
    _selectedDate = _formatDate(DateTime.now());
    _exerciseLogDao = database.exerciseLogDao;
    _logDayDetailsDao = database.logDayDetailsDao;
  }

  @override
  void dispose() {
    database.close();
    super.dispose();
  }

  Future<void> _showRoutineSelectionSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RoutineSelectionSheet(selectedDate: _selectedDate),
    );
  }

  Future<void> _showPeriodSelectionSheet(BuildContext context) async {
    // Parse the current selected date string to DateTime
    final parts = _selectedDate.split('-');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);
    final currentSelectedDate = DateTime(year, month, day);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CalendarSelectionSheet(
        initialSelectedDate: currentSelectedDate,
        onDateSelected: (selectedDate) {
          setState(() {
            _selectedDate = _formatDate(selectedDate);
          });
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  LogExercise _convertToLogExercise(ExerciseLogWithExercise logWithExercise) {
    final sets = logWithExercise.log.setsData.sets.map((setData) => LogSet(
      setNumber: setData.setNumber,
      weight: setData.weight,
      reps: setData.reps,
    )).toList();

    return LogExercise(
      name: logWithExercise.exercise.name,
      sets: sets,
      note: logWithExercise.log.notes,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).extension<AppTheme>()!.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditLogScreen(
                    routineId: '',
                    date: _selectedDate,
                  ),
                ),
              );
            },
            icon: Icon(Icons.edit),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<ExerciseLogWithExercise>>(
                stream: _exerciseLogDao.watchLogsForDate(_selectedDate),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  
                  final logsWithExercises = snapshot.data ?? [];
                  final exercises = logsWithExercises.map(_convertToLogExercise).toList();
                  
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 200,
                            child: Center(
                              child: Text(
                                'Log',
                                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          FutureBuilder<LogDayDetail?>(
                            future: _logDayDetailsDao.getLogDayDetailsByDate(_selectedDate),
                            builder: (context, titleSnapshot) {
                              final title = titleSnapshot.data?.title;
                              if (title != null && title.isNotEmpty) {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 16, left: 5),
                                    child: Text(
                                      title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).extension<AppTheme>()?.text.withOpacity(0.7),
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          if (exercises.isEmpty)
                            Column(
                              children: [
                                const SizedBox(height: 40),
                                ElevatedButton(
                                  onPressed: () {
                                    // TODO: Implement start random exercise
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Start Random Exercise',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => _showRoutineSelectionSheet(context),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Start a Routine',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            )
                          else
                            Column(
                              children: exercises.map((exercise) => Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: LogItem(
                                  exerciseName: exercise.name,
                                  sets: exercise.sets,
                                  note: exercise.note,
                                ),
                              )).toList(),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            HorizontalDateSelector(
              selectedDate: _selectedDate,
              onDateTap: (date) {
                setState(() {
                  _selectedDate = _formatDate(date);
                });
              },
              onPeriodLabel: () => _showPeriodSelectionSheet(context),
            )
          ],
        ),
      ),
    );
  }
}

class LogExercise {
  final String name;
  final List<LogSet> sets;
  final String? note;

  const LogExercise({
    required this.name,
    required this.sets,
    this.note,
  });
}
