import 'package:flutter/material.dart';
import 'package:rep_records/components/exercise-card/exercise_card.dart';
import 'package:rep_records/database/dao/category_dao.dart';
import 'package:rep_records/database/database.dart';
import 'package:rep_records/main.dart';
import 'package:rep_records/screens/edit-log-screen/edit_log_screen.dart';
import 'package:rep_records/theme/app_theme.dart';

class ExerciseSelectionScreen extends StatefulWidget {
  final String selectedDate;

  const ExerciseSelectionScreen({
    super.key,
    required this.selectedDate,
  });

  @override
  State<ExerciseSelectionScreen> createState() => _ExerciseSelectionScreenState();
}

class _ExerciseSelectionScreenState extends State<ExerciseSelectionScreen> {
  final Set<String> _selectedExerciseIds = <String>{};

  Widget _buildCategoryHeader(String categoryName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 10),
      child: Text(
        categoryName,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _toggleExerciseSelection(ExerciseData exercise) {
    setState(() {
      if (_selectedExerciseIds.contains(exercise.id)) {
        _selectedExerciseIds.remove(exercise.id);
      } else {
        _selectedExerciseIds.add(exercise.id);
      }
    });
  }

  void _startSelectedExercises() {
    if (_selectedExerciseIds.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditLogScreen(
          routineId: '',
          date: widget.selectedDate,
          selectedExerciseIds: _selectedExerciseIds.toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).extension<AppTheme>()!.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        title: Text(
          _selectedExerciseIds.isEmpty 
            ? 'Select Exercise'
            : 'Selected ${_selectedExerciseIds.length} exercise${_selectedExerciseIds.length > 1 ? 's' : ''}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: _selectedExerciseIds.isNotEmpty
        ? FloatingActionButton.extended(
            onPressed: _startSelectedExercises,
            backgroundColor: Theme.of(context).extension<AppTheme>()!.accent,
            foregroundColor: Theme.of(context).extension<AppTheme>()!.background,
            icon: const Icon(Icons.play_arrow),
            label: const Text(
              'Start',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : null,
      body: SafeArea(
        child: FutureBuilder<List<CategoryWithExercises>>(
          future: CategoryDao(database).getCategoriesWithExercises(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final categories = snapshot.data ?? [];

            if (categories.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No exercises available. Add some exercises in the Manage section first!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  bottom: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    ...categories.expand((category) => [
                      if (category.exercises.isNotEmpty) ...[
                        _buildCategoryHeader(category.categoryName),
                        ...category.exercises.map((exercise) => Column(
                          children: [
                            Stack(
                              children: [
                                ExerciseCard(
                                  name: exercise.name,
                                  equipment: exercise.equipment,
                                  displayCta: false,
                                  isSelected: _selectedExerciseIds.contains(exercise.id),
                                  onTap: () => _toggleExerciseSelection(exercise),
                                ),
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: AnimatedOpacity(
                                    opacity: _selectedExerciseIds.contains(exercise.id) ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        )).toList(),
                        const SizedBox(height: 10),
                      ],
                    ]).toList(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
