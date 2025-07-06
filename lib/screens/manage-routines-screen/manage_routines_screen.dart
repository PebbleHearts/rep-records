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
  const ManageRoutinesScreen({super.key});

  void _showAddRoutineBottomSheet(BuildContext context, {Routine? routineToEdit}) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: routineToEdit?.name);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
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
                    Text(
                      routineToEdit != null ? 'Edit Routine' : 'Add New Routine',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (routineToEdit != null) {
                            await RoutineDao(database).updateRoutine(
                              routineToEdit.id,
                              RoutinesCompanion(
                                name: Value(_nameController.text),
                                status: Value(routineToEdit.status),
                                synced: const Value(false),
                              ),
                            );
                          } else {
                            await RoutineDao(database).createRoutine(
                              RoutinesCompanion.insert(
                                name: _nameController.text,
                                status: 'active',
                              ),
                            );
                          }
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
                                            _showAddRoutineBottomSheet(
                                              context,
                                              routineToEdit: routineWithExercises.routine,
                                            );
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
                                            final shouldDelete = await showDialog<bool>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Confirm Deletion'),
                                                  content: Text('Are you sure you want to delete the routine "${routineWithExercises.routine.name}"? This action cannot be undone.'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () => Navigator.of(context).pop(false),
                                                      child: const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => Navigator.of(context).pop(true),
                                                      style: TextButton.styleFrom(
                                                        foregroundColor: Colors.red,
                                                      ),
                                                      child: const Text('Delete'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            if (shouldDelete == true) {
                                              await RoutineDao(database).deleteRoutine(routineWithExercises.routine.id);
                                            }
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
                                    Dismissible(
                                      key: Key('${routineWithExercises.routine.id}-${exercise.id}'),
                                      direction: DismissDirection.endToStart,
                                      background: Container(
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.only(right: 20),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                      confirmDismiss: (direction) async {
                                        return await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Confirm Deletion'),
                                              content: Text('Are you sure you want to remove ${exercise.name} from this routine?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(false),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(true),
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      onDismissed: (direction) async {
                                        await RoutineExerciseDao(database).deleteExerciseFromRoutine(
                                          routineWithExercises.routine.id,
                                          exercise.id,
                                        );
                                      },
                                      child: _buildExerciseCard(
                                        context,
                                        exercise.name,
                                        exercise.equipment,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                )).toList(),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      final selectedExerciseIds = await Navigator.push<List<String>>(
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
