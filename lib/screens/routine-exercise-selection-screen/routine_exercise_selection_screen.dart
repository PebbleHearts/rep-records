import 'package:flutter/material.dart';
import 'package:rep_records/database/dao/category_dao.dart';
import 'package:rep_records/main.dart';

class RoutineExerciseSelectionScreen extends StatefulWidget {
  final String routineId;
  final String routineName;

  const RoutineExerciseSelectionScreen({
    super.key,
    required this.routineId,
    required this.routineName,
  });

  @override
  State<RoutineExerciseSelectionScreen> createState() => _RoutineExerciseSelectionScreenState();
}

class _RoutineExerciseSelectionScreenState extends State<RoutineExerciseSelectionScreen> {
  final Set<String> selectedExerciseIds = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        title: Text(
          'Add Exercise to ${widget.routineName}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                        selected: selectedExerciseIds.contains(exercise.id),
                        trailing: selectedExerciseIds.contains(exercise.id)
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : null,
                        onTap: () {
                          setState(() {
                            if (selectedExerciseIds.contains(exercise.id)) {
                              selectedExerciseIds.remove(exercise.id);
                            } else {
                              selectedExerciseIds.add(exercise.id);
                            }
                          });
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: selectedExerciseIds.isEmpty
                ? null
                : () {
                    Navigator.pop(context, selectedExerciseIds.toList());
                  },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Add ${selectedExerciseIds.length} Exercise${selectedExerciseIds.length == 1 ? '' : 's'}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
} 