import 'package:flutter/material.dart';
import 'package:rep_records/theme/app_theme.dart';

class ManageRoutinesScreen extends StatelessWidget {
  const ManageRoutinesScreen({super.key});

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
                      Text(
                        'Push Day',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      _buildExerciseCard(
                        context,
                        'Exercise 1',
                        'Chest',
                        Icons.fitness_center,
                        () {
                          // TODO: Handle exercise tap
                        },
                        () {
                          // TODO: Handle delete
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildExerciseCard(
                        context,
                        'Exercise 2',
                        'Chest',
                        Icons.fitness_center,
                        () {
                          // TODO: Handle exercise tap
                        },
                        () {
                          // TODO: Handle delete
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildExerciseCard(
                        context,
                        'Exercise 3',
                        'Chest',
                        Icons.fitness_center,
                        () {
                          // TODO: Handle exercise tap
                        },
                        () {
                          // TODO: Handle delete
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildExerciseCard(
                        context,
                        'Exercise 4',
                        'Triceps',
                        Icons.fitness_center,
                        () {
                          // TODO: Handle exercise tap
                        },
                        () {
                          // TODO: Handle delete
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildExerciseCard(
                        context,
                        'Exercise 5',
                        'Triceps',
                        Icons.fitness_center,
                        () {
                          // TODO: Handle exercise tap
                        },
                        () {
                          // TODO: Handle delete
                        },
                      ),
                      const SizedBox(height: 20),
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
    VoidCallback onDelete,
  ) {
    return Card(
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
              SizedBox(
                height: 40,
                width: 40,
                child: IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete,
                    size: 20,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
