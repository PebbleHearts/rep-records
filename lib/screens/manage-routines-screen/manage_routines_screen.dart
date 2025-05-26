import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:rep_records/database/dao/category_dao.dart';
import 'package:rep_records/database/dao/routine_dao.dart';
import 'package:rep_records/database/dao/routine_exercise_dao.dart';
import 'package:rep_records/database/database.dart';
import 'package:rep_records/main.dart';
import 'package:rep_records/screens/routine-exercise-selection-screen/routine_exercise_selection_screen.dart';
import 'package:rep_records/theme/app_theme.dart';

class ManageRoutinesScreen extends StatelessWidget {
  ManageRoutinesScreen({super.key});

  // Dummy exercises for each routine
  final Map<String, List<Map<String, dynamic>>> _dummyExercises = {
    'Push Day': [
      {'name': 'Bench Press', 'category': 'Chest'},
      {'name': 'Overhead Press', 'category': 'Shoulders'},
      {'name': 'Tricep Pushdowns', 'category': 'Triceps'},
    ],
    'Pull Day': [
      {'name': 'Pull-ups', 'category': 'Back'},
      {'name': 'Barbell Rows', 'category': 'Back'},
      {'name': 'Bicep Curls', 'category': 'Biceps'},
    ],
    'Leg Day': [
      {'name': 'Squats', 'category': 'Legs'},
      {'name': 'Romanian Deadlifts', 'category': 'Legs'},
      {'name': 'Leg Press', 'category': 'Legs'},
    ],
    'Full Body': [
      {'name': 'Deadlifts', 'category': 'Full Body'},
      {'name': 'Push-ups', 'category': 'Chest'},
      {'name': 'Dumbbell Rows', 'category': 'Back'},
    ],
  };

  void _showAddRoutineBottomSheet(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).extension<AppTheme>()!.background,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add New Routine',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await RoutineDao(database).createRoutine(
                          RoutinesCompanion.insert(
                            name: _nameController.text,
                            status: 'active',
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Routine Name',
                    hintText: 'e.g., Push Day, Upper Body, etc.',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a routine name';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExerciseSelectionBottomSheet(BuildContext context, String routineName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Theme.of(context).extension<AppTheme>()!.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Exercise to $routineName',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
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
                        child: Text(
                          'No exercises available. Add some exercises first!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                category.categoryName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...category.exercises.map((exercise) => Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Text(exercise.name),
                                subtitle: Text(exercise.equipment),
                                onTap: () {
                                  // TODO: Add exercise to routine
                                  Navigator.pop(context);
                                },
                              ),
                            )).toList(),
                            const SizedBox(height: 16),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(
    BuildContext context,
    String title,
    String category,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).extension<AppTheme>()!.text.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.fitness_center,
                size: 24,
                color: Theme.of(context).extension<AppTheme>()!.text,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddRoutineBottomSheet(context),
        backgroundColor: Theme.of(context).extension<AppTheme>()!.text.withAlpha(100),
        foregroundColor: Theme.of(context).extension<AppTheme>()!.background,
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 100,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 60),
                        child: Center(
                          child: Text(
                            'My Routines',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      StreamBuilder<List<RoutineWithExercises>>(
                        stream: RoutineDao(database).watchAllRoutinesWithExercises(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }

                          final routines = snapshot.data ?? [];
                          
                          if (routines.isEmpty) {
                            return const Center(
                              child: Text(
                                'No routines yet. Add your first routine!',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: routines.map((routineWithExercises) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      routineWithExercises.routine.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            // TODO: Handle edit routine
                                          },
                                          icon: const Icon(Icons.edit, size: 20),
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.blue.withOpacity(0.1),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          onPressed: () async {
                                            await RoutineDao(database).deleteRoutine(routineWithExercises.routine.id);
                                          },
                                          icon: const Icon(Icons.delete, size: 20),
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.red.withOpacity(0.1),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Show exercises for this routine
                                ...routineWithExercises.exercises.map((exercise) => Column(
                                  children: [
                                    _buildExerciseCard(
                                      context,
                                      exercise.name,
                                      exercise.equipment,
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                )).toList(),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      final selectedExerciseIds = await Navigator.push<List<int>>(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RoutineExerciseSelectionScreen(
                                            routineId: routineWithExercises.routine.id,
                                            routineName: routineWithExercises.routine.name,
                                          ),
                                        ),
                                      );
                                      
                                      if (selectedExerciseIds != null && selectedExerciseIds.isNotEmpty) {
                                        final routineExerciseDao = RoutineExerciseDao(database);
                                        for (final exerciseId in selectedExerciseIds) {
                                          await routineExerciseDao.addExerciseToRoutine(
                                            RoutineExercisesCompanion(
                                              routineId: Value(routineWithExercises.routine.id),
                                              exerciseId: Value(exerciseId),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    icon: const Icon(Icons.add),
                                    label: const Text('Add Exercise'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            )).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
