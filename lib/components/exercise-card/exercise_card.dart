import 'package:flutter/material.dart';
import 'package:rep_records/theme/app_theme.dart';

class ExerciseCard extends StatelessWidget {
  final String name;
  final bool isSelected;
  final bool isDisabled;
  final bool displayCta;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  const ExerciseCard({
    super.key,
    required this.name,
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
      borderRadius: BorderRadius.circular(10),
      onTap: isDisabled ? () {} : onTap,
      child: Container(
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).extension<AppTheme>()!.background2,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 6, bottom: 6, right: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              if (displayCta)
                Row(
                  children: [
                    SizedBox(
                      height: 32,
                      width: 32,
                      child: IconButton(
                        onPressed: () {
                          onEdit!();
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 17,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 32,
                      width: 32,
                      child: IconButton(
                        onPressed: () {
                          onDelete!();
                        },
                        icon: const Icon(
                          Icons.delete,
                          size: 17,
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
