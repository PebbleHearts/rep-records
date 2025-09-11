import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rep_records/theme/app_theme.dart';

class ExerciseCard extends StatelessWidget {
  final String exerciseName;
  final List<TextEditingController> weightControllers;
  final List<TextEditingController> repsControllers;
  final TextEditingController noteController;
  final VoidCallback onAddSet;
  final Function(int) onDeleteSet;
  final VoidCallback onDeleteExercise;

  const ExerciseCard({
    super.key,
    required this.exerciseName,
    required this.weightControllers,
    required this.repsControllers,
    required this.noteController,
    required this.onAddSet,
    required this.onDeleteSet,
    required this.onDeleteExercise,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;

    return Card(
      elevation: 0,
      color: theme.background2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.accent.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    exerciseName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.text,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _showDeleteDialog(context),
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red.withOpacity(0.7),
                    size: 20,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...List.generate(
              weightControllers.length,
              (index) => _buildSetRow(context, index),
            ),
            const SizedBox(height: 12),
            _buildAddSetButton(context),
            const SizedBox(height: 16),
            _buildNoteField(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSetRow(BuildContext context, int index) {
    final theme = Theme.of(context).extension<AppTheme>()!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.background3,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: theme.text.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: weightControllers[index],
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
              ],
              decoration: InputDecoration(
                hintText: 'Weight',
                hintStyle: TextStyle(color: theme.text.withOpacity(0.5)),
                filled: true,
                fillColor: theme.background3,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              style: TextStyle(color: theme.text),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: repsControllers[index],
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
              ],
              decoration: InputDecoration(
                hintText: 'Reps',
                hintStyle: TextStyle(color: theme.text.withOpacity(0.5)),
                filled: true,
                fillColor: theme.background3,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              style: TextStyle(color: theme.text),
            ),
          ),
          const SizedBox(width: 8),
          if (weightControllers.length > 1)
            IconButton(
              onPressed: () => onDeleteSet(index),
              icon: Icon(
                Icons.remove_circle_outline,
                color: Colors.red.withOpacity(0.7),
                size: 20,
              ),
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
              padding: EdgeInsets.zero,
            ),
        ],
      ),
    );
  }

  Widget _buildAddSetButton(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onAddSet,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: theme.accent.withOpacity(0.3)),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        icon: Icon(
          Icons.add,
          color: theme.accent,
          size: 18,
        ),
        label: Text(
          'Add Set',
          style: TextStyle(
            color: theme.accent,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildNoteField(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;

    return TextField(
      controller: noteController,
      maxLines: 3,
      minLines: 1,
      decoration: InputDecoration(
        hintText: 'Note',
        hintStyle: TextStyle(color: theme.text.withOpacity(0.5)),
        filled: true,
        fillColor: theme.background3,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      style: TextStyle(
        color: theme.text,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: theme.background2,
          title: Text(
            'Delete Exercise',
            style: TextStyle(color: theme.text),
          ),
          content: Text(
            'Are you sure you want to delete "$exerciseName" from this workout? This action cannot be undone.',
            style: TextStyle(color: theme.text.withOpacity(0.8)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: theme.text.withOpacity(0.6)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDeleteExercise();
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
} 