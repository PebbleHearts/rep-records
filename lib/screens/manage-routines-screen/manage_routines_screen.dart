import 'package:flutter/material.dart';
import 'package:rep_records/theme/app_theme.dart';

class ManageRoutinesScreen extends StatelessWidget {
  ManageRoutinesScreen({super.key});

  // Sample routine data
  final List<Map<String, dynamic>> _routines = [
    {
      'name': 'Push Day',
      'exercises': [
        {'name': 'Bench Press', 'category': 'Chest', 'icon': Icons.fitness_center},
        {'name': 'Overhead Press', 'category': 'Shoulders', 'icon': Icons.fitness_center},
        {'name': 'Tricep Pushdowns', 'category': 'Triceps', 'icon': Icons.fitness_center},
        {'name': 'Lateral Raises', 'category': 'Shoulders', 'icon': Icons.fitness_center},
        {'name': 'Incline Bench Press', 'category': 'Chest', 'icon': Icons.fitness_center},
        {'name': 'Skull Crushers', 'category': 'Triceps', 'icon': Icons.fitness_center},
      ],
    },
    {
      'name': 'Pull Day',
      'exercises': [
        {'name': 'Pull-ups', 'category': 'Back', 'icon': Icons.fitness_center},
        {'name': 'Barbell Rows', 'category': 'Back', 'icon': Icons.fitness_center},
        {'name': 'Bicep Curls', 'category': 'Biceps', 'icon': Icons.fitness_center},
        {'name': 'Face Pulls', 'category': 'Shoulders', 'icon': Icons.fitness_center},
        {'name': 'Lat Pulldowns', 'category': 'Back', 'icon': Icons.fitness_center},
        {'name': 'Hammer Curls', 'category': 'Biceps', 'icon': Icons.fitness_center},
        {'name': 'Seated Cable Rows', 'category': 'Back', 'icon': Icons.fitness_center},
      ],
    },
    {
      'name': 'Leg Day',
      'exercises': [
        {'name': 'Squats', 'category': 'Legs', 'icon': Icons.fitness_center},
        {'name': 'Romanian Deadlifts', 'category': 'Legs', 'icon': Icons.fitness_center},
        {'name': 'Leg Press', 'category': 'Legs', 'icon': Icons.fitness_center},
        {'name': 'Calf Raises', 'category': 'Legs', 'icon': Icons.fitness_center},
        {'name': 'Leg Extensions', 'category': 'Legs', 'icon': Icons.fitness_center},
        {'name': 'Leg Curls', 'category': 'Legs', 'icon': Icons.fitness_center},
        {'name': 'Walking Lunges', 'category': 'Legs', 'icon': Icons.fitness_center},
      ],
    },
    {
      'name': 'Full Body',
      'exercises': [
        {'name': 'Deadlifts', 'category': 'Full Body', 'icon': Icons.fitness_center},
        {'name': 'Push-ups', 'category': 'Chest', 'icon': Icons.fitness_center},
        {'name': 'Dumbbell Rows', 'category': 'Back', 'icon': Icons.fitness_center},
        {'name': 'Shoulder Press', 'category': 'Shoulders', 'icon': Icons.fitness_center},
        {'name': 'Goblet Squats', 'category': 'Legs', 'icon': Icons.fitness_center},
        {'name': 'Plank', 'category': 'Core', 'icon': Icons.fitness_center},
      ],
    },
    {
      'name': 'Upper Body',
      'exercises': [
        {'name': 'Bench Press', 'category': 'Chest', 'icon': Icons.fitness_center},
        {'name': 'Pull-ups', 'category': 'Back', 'icon': Icons.fitness_center},
        {'name': 'Overhead Press', 'category': 'Shoulders', 'icon': Icons.fitness_center},
        {'name': 'Barbell Rows', 'category': 'Back', 'icon': Icons.fitness_center},
        {'name': 'Tricep Pushdowns', 'category': 'Triceps', 'icon': Icons.fitness_center},
        {'name': 'Bicep Curls', 'category': 'Biceps', 'icon': Icons.fitness_center},
        {'name': 'Lateral Raises', 'category': 'Shoulders', 'icon': Icons.fitness_center},
      ],
    },
  ];

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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO: Save the routine
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
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
                    const SizedBox(height: 24),
                    const Text(
                      'Add Exercises',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Show exercise selection dialog
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Exercise'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ],
                ),
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
                      ..._routines.map((routine) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                routine['name'],
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
                                    onPressed: () {
                                      // TODO: Handle delete routine
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
                          const SizedBox(height: 5),
                          ...routine['exercises'].map<Widget>((exercise) => Column(
                            children: [
                              _buildExerciseCard(
                                context,
                                exercise['name'],
                                exercise['category'],
                                exercise['icon'],
                                () {
                                  // TODO: Handle exercise tap
                                },
                              ),
                              const SizedBox(height: 10),
                            ],
                          )).toList(),
                          const SizedBox(height: 20),
                        ],
                      )).toList(),
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

  Widget _buildExerciseCard(
    BuildContext context,
    String title,
    String category,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Dismissible(
      key: Key(title),
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
      onDismissed: (direction) {
        // TODO: Handle exercise deletion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title removed from routine'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                // TODO: Handle undo deletion
              },
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).extension<AppTheme>()!.text.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 32,
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
                          fontSize: 18,
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
        ),
      ),
    );
  }
}
