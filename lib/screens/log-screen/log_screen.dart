import 'package:flutter/material.dart';
import 'package:rep_records/components/horizontal-date-selector/horizontal_date_selector.dart';
import 'package:rep_records/screens/edit-log-screen/edit_log_screen.dart';
import 'package:rep_records/screens/log-screen/components/log_item.dart';
import 'package:rep_records/screens/log-screen/components/routine_selection_sheet.dart';
import 'package:rep_records/theme/app_theme.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  String _selectedDate = '21-03-2025'; // Default date in dd-mm-yyyy format

  void _showRoutineSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RoutineSelectionSheet(selectedDate: _selectedDate),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    // Sample data - in a real app, this would come from a database or API
    // final exercises = [
    //   LogExercise(
    //     name: 'Bench Press',
    //     sets: [
    //       LogSet(setNumber: 1, weight: 60, reps: 12),
    //       LogSet(setNumber: 2, weight: 65, reps: 10),
    //       LogSet(setNumber: 3, weight: 70, reps: 8),
    //     ],
    //   ),
    //   LogExercise(
    //     name: 'Squats',
    //     sets: [
    //       LogSet(setNumber: 1, weight: 80, reps: 10),
    //       LogSet(setNumber: 2, weight: 85, reps: 8),
    //       LogSet(setNumber: 3, weight: 90, reps: 6),
    //     ],
    //   ),
    //   LogExercise(
    //     name: 'Deadlift',
    //     sets: [
    //       LogSet(setNumber: 1, weight: 100, reps: 8),
    //       LogSet(setNumber: 2, weight: 110, reps: 6),
    //       LogSet(setNumber: 3, weight: 120, reps: 4),
    //     ],
    //   ),
    // ];
    final exercises = [];

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
                    routineId: -1,
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
              child: SingleChildScrollView(
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
                            ),
                          )).toList(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            HorizontalDateSelector(
              selectedDate: _selectedDate,
              onDateTap: (date) {
                setState(() {
                  _selectedDate = _formatDate(date);
                });
              },
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

  const LogExercise({
    required this.name,
    required this.sets,
  });
}
