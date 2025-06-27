import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rep_records/theme/app_theme.dart';

class ExerciseCard extends StatelessWidget {
  final String exerciseName;
  final List<TextEditingController> weightControllers;
  final List<TextEditingController> repsControllers;
  final TextEditingController noteController;

  const ExerciseCard({
    super.key,
    required this.exerciseName,
    required this.weightControllers,
    required this.repsControllers,
    required this.noteController,
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
            Text(
              exerciseName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.text,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(3, (index) => _buildSetRow(context, index)),
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
        ],
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
} 