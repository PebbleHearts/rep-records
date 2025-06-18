import 'package:flutter/material.dart';
import 'package:rep_records/screens/log-screen/components/log_set_item.dart';
import 'package:rep_records/theme/app_theme.dart';

class LogItem extends StatelessWidget {
  final String exerciseName;
  final List<LogSet> sets;

  const LogItem({
    super.key,
    required this.exerciseName,
    required this.sets,
  });

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
                      exerciseName,
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
            ...sets.map((set) => LogSetItem(
              setNumber: set.setNumber,
              weight: set.weight,
              reps: set.reps,
            )),
          ],
        ),
      ),
    );
  }
}

class LogSet {
  final int setNumber;
  final double weight;
  final int reps;

  const LogSet({
    required this.setNumber,
    required this.weight,
    required this.reps,
  });
}