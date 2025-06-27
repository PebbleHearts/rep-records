import 'package:flutter/material.dart';
import 'package:rep_records/components/exercise-card/exercise_card.dart';
import 'package:rep_records/database/dao/category_dao.dart';
import 'package:rep_records/database/dao/exercise_dao.dart';
import 'package:rep_records/database/database.dart';
import 'package:rep_records/main.dart';
import 'package:rep_records/theme/app_theme.dart';
import 'package:drift/drift.dart' show Value;

class ExerciseItem {
  final String name;
  final String equipment;
  final String category;

  const ExerciseItem({
    required this.name,
    required this.equipment,
    required this.category,
  });
}

class ManageExercisesScreen extends StatefulWidget {
  const ManageExercisesScreen({super.key});

  @override
  State<ManageExercisesScreen> createState() => _ManageExercisesScreenState();
}

class _ManageExercisesScreenState extends State<ManageExercisesScreen> {

  void _showAddCategoryBottomSheet(BuildContext context, {String? existingCategoryName, String? categoryId}) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: existingCategoryName);

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
                  Text(
                    existingCategoryName != null ? 'Edit Category' : 'Add New Category',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          if (existingCategoryName != null && categoryId != null) {
                            // Update existing category
                            await CategoryDao(database).updateCategory(
                              CategoryCompanion(
                                id: Value(categoryId),
                                name: Value(_nameController.text),
                                synced: const Value(false),
                              ),
                            );
                          } else {
                            // Create new category
                            await CategoryDao(database).insertCategory(
                              CategoryCompanion.insert(
                                name: _nameController.text,
                              ),
                            );
                          }
                          Navigator.pop(context);
                        } catch (e) {
                          print('Error ${existingCategoryName != null ? 'updating' : 'creating'} category: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error ${existingCategoryName != null ? 'updating' : 'creating'} category: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
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

  Widget _buildCategoryHeader(BuildContext context, String categoryName, String categoryId) {
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
                    _showAddCategoryBottomSheet(
                      context,
                      existingCategoryName: categoryName,
                      categoryId: categoryId,
                    );
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
                  onPressed: () async {
                    final shouldDelete = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Deletion'),
                          content: Text('Are you sure you want to delete the category "$categoryName"? This will also delete all exercises in this category. This action cannot be undone.'),
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
                      try {
                        await CategoryDao(database).deleteCategory(categoryId);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Category "$categoryName" deleted successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        print('Error deleting category: $e');
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error deleting category: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
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
            _showAddExerciseBottomSheet(context, categoryName);
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

  void _showAddExerciseBottomSheet(
    BuildContext context,
    String categoryName, {
    ExerciseData? existingExercise,
  }) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: existingExercise?.name);
    final _equipmentController = TextEditingController(text: existingExercise?.equipment);

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
                  Text(
                    existingExercise != null ? 'Edit Exercise' : 'Add Exercise to $categoryName',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          if (existingExercise != null) {
                            // Update existing exercise
                            await ExerciseDao(database).updateExercise(
                              ExerciseCompanion(
                                id: Value(existingExercise.id),
                                name: Value(_nameController.text),
                                equipment: Value(_equipmentController.text),
                                categoryId: Value(existingExercise.categoryId),
                                synced: const Value(false),
                              ),
                            );
                          } else {
                            // Find the category ID based on the category name
                            final categories = await CategoryDao(database).getAllCategories();
                            final category = categories.firstWhere(
                              (c) => c.name == categoryName,
                              orElse: () => throw Exception('Category not found: $categoryName'),
                            );

                            // Create new exercise
                            await ExerciseDao(database).insertExercise(
                              ExerciseCompanion.insert(
                                name: _nameController.text,
                                equipment: _equipmentController.text,
                                categoryId: category.id,
                              ),
                            );
                          }
                          Navigator.pop(context);
                        } catch (e) {
                          print('Error ${existingExercise != null ? 'updating' : 'creating'} exercise: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error ${existingExercise != null ? 'updating' : 'creating'} exercise: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
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
                        labelText: 'Exercise Name',
                        hintText: 'e.g., Bench Press, Squat, etc.',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an exercise name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _equipmentController,
                      decoration: const InputDecoration(
                        labelText: 'Equipment',
                        hintText: 'e.g., Barbell, Dumbbell, etc.',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the equipment';
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
              child: StreamBuilder<List<CategoryWithExercises>>(
                stream: CategoryDao(database).watchCategoriesWithExercises(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final categories = snapshot.data ?? [];

                  return SingleChildScrollView(
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
                          ...categories.expand((category) => [
                            _buildCategoryHeader(context, category.categoryName, category.categoryId),
                            ...category.exercises.map((exercise) => Column(
                              children: [
                                Dismissible(
                                  key: Key('${exercise.id}'),
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
                                  confirmDismiss: (direction) async {
                                    return await showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Delete Exercise'),
                                          content: Text('Are you sure you want to delete "${exercise.name}"?'),
                                          actions: [
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
                                    ) ?? false;
                                  },
                                  onDismissed: (direction) async {
                                    try {
                                      await ExerciseDao(database).deleteExercise(exercise.id);
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('${exercise.name} deleted successfully'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      print('Error deleting exercise: $e');
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Error deleting exercise: $e'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: ExerciseCard(
                                    name: exercise.name,
                                    equipment: exercise.equipment,
                                    onTap: () {
                                      _showAddExerciseBottomSheet(
                                        context,
                                        category.categoryName,
                                        existingExercise: exercise,
                                      );
                                    },
                                    onDelete: () {},
                                    onEdit: () {},
                                    displayCta: false,
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            )).toList(),
                            _buildAddExerciseButton(context, category.categoryName),
                            const SizedBox(height: 20),
                          ]).toList(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}