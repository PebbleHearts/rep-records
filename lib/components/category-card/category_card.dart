import 'package:flutter/material.dart';
import 'package:rep_records/theme/app_theme.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final bool displayCta;
  const CategoryCard({
    super.key,
    required this.name,
    required this.onTap,
    this.onDelete,
    this.onEdit,
    required this.displayCta,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).extension<AppTheme>()!.background3,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 6, bottom: 6, right: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
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
                            icon: const Icon(Icons.edit, size: 17),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                          width: 32,
                          child: IconButton(
                            onPressed: () {
                              onDelete!();
                            },
                            icon: const Icon(Icons.delete, size: 17),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey.withOpacity(0.7),
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
