import 'package:flutter/material.dart';
import 'package:rep_records/screens/log-screen/components/log_set_item.dart';
import 'package:rep_records/theme/app_theme.dart';

class LogItem extends StatelessWidget {
  const LogItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.fitness_center,
                        size: 21,
                        color: Theme.of(context).extension<AppTheme>()!.text,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Exercise name',
                      style: TextStyle(
                        color: Theme.of(context).extension<AppTheme>()!.text,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            LogSetItem(),
            LogSetItem(),
            LogSetItem(),
          ],
        ),
      ),
    );
  }
}