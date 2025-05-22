import 'package:flutter/material.dart';
import 'package:rep_records/components/exercise-card/exercise_card.dart';
import 'package:rep_records/theme/app_theme.dart';

class ManageExercisesScreen extends StatelessWidget {
  const ManageExercisesScreen({super.key});

  void _showAddCategoryBottomSheet(BuildContext context) {
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
                    'Add New Category',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO: Save the category
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
                        labelText: 'Category Name',
                        hintText: 'e.g., Chest, Back, Legs, etc.',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a category name';
                        }
                        return null;
                      },
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

  Widget _buildCategoryHeader(BuildContext context, String categoryName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            categoryName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              SizedBox(
                height: 32,
                width: 32,
                child: IconButton(
                  onPressed: () {
                    // TODO: Handle edit category
                  },
                  icon: const Icon(
                    Icons.edit,
                    size: 20,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 32,
                width: 32,
                child: IconButton(
                  onPressed: () {
                    // TODO: Handle delete category
                  },
                  icon: const Icon(
                    Icons.delete,
                    size: 20,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddExerciseButton(BuildContext context, String categoryName) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        width: double.infinity,
        child: TextButton.icon(
          onPressed: () {
            // TODO: Handle add exercise to category
          },
          icon: const Icon(Icons.add),
          label: Text('Add Exercise to $categoryName'),
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).extension<AppTheme>()!.background,
            foregroundColor: Theme.of(context).extension<AppTheme>()!.text,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
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
        onPressed: () => _showAddCategoryBottomSheet(context),
        backgroundColor: Theme.of(context).extension<AppTheme>()!.text.withAlpha(150),
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
                            'Exercises',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      _buildCategoryHeader(context, 'Chest'),
                      Dismissible(
                        key: const Key('bench-press'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        onDismissed: (direction) {
                          // TODO: Handle exercise deletion
                        },
                        child: ExerciseCard(
                          name: 'Bench Press',
                          equipment: 'Barbell',
                          onTap: () {},
                          onDelete: () {},
                          onEdit: () {},
                          displayCta: false,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Dismissible(
                        key: const Key('incline-dumbbell-press'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        onDismissed: (direction) {
                          // TODO: Handle exercise deletion
                        },
                        child: ExerciseCard(
                          name: 'Incline Dumbbell Press',
                          equipment: 'Dumbbells',
                          onTap: () {},
                          onDelete: () {},
                          onEdit: () {},
                          displayCta: false,
                        ),
                      ),
                      _buildAddExerciseButton(context, 'Chest'),
                      const SizedBox(height: 20),
                      _buildCategoryHeader(context, 'Back'),
                      Dismissible(
                        key: const Key('pull-ups'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        onDismissed: (direction) {
                          // TODO: Handle exercise deletion
                        },
                        child: ExerciseCard(
                          name: 'Pull-ups',
                          equipment: 'Bodyweight',
                          onTap: () {},
                          onDelete: () {},
                          onEdit: () {},
                          displayCta: false,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Dismissible(
                        key: const Key('barbell-rows'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        onDismissed: (direction) {
                          // TODO: Handle exercise deletion
                        },
                        child: ExerciseCard(
                          name: 'Barbell Rows',
                          equipment: 'Barbell',
                          onTap: () {},
                          onDelete: () {},
                          onEdit: () {},
                          displayCta: false,
                        ),
                      ),
                      _buildAddExerciseButton(context, 'Back'),
                      const SizedBox(height: 20),
                      _buildCategoryHeader(context, 'Legs'),
                      Dismissible(
                        key: const Key('squats'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        onDismissed: (direction) {
                          // TODO: Handle exercise deletion
                        },
                        child: ExerciseCard(
                          name: 'Squats',
                          equipment: 'Barbell',
                          onTap: () {},
                          onDelete: () {},
                          onEdit: () {},
                          displayCta: false,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Dismissible(
                        key: const Key('deadlifts'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        onDismissed: (direction) {
                          // TODO: Handle exercise deletion
                        },
                        child: ExerciseCard(
                          name: 'Deadlifts',
                          equipment: 'Barbell',
                          onTap: () {},
                          onDelete: () {},
                          onEdit: () {},
                          displayCta: false,
                        ),
                      ),
                      _buildAddExerciseButton(context, 'Legs'),
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
}