import 'package:flutter/material.dart';
import 'package:rep_records/theme/app_theme.dart';

class ExerciseCard extends StatelessWidget {
  final String name;
  final String equipment;
  final bool isSelected;
  final bool isDisabled;
  final bool displayCta;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  const ExerciseCard({
    super.key,
    required this.name,
    required this.equipment,
    this.isSelected = false,
    this.isDisabled = false,
    required this.displayCta,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: isDisabled ? () {} : onTap,
      child: Container(
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).extension<AppTheme>()!.background2,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
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
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      equipment,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (displayCta)
                Row(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: IconButton(
                        onPressed: () {
                          onEdit!();
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 20,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: IconButton(
                        onPressed: () {
                          onDelete!();
                        },
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
            ],
          ),
        ),
      ),
    );
  }
}
