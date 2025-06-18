import 'package:flutter/material.dart';
import 'package:rep_records/theme/app_theme.dart';

class LogSetItem extends StatelessWidget {
  final int setNumber;
  final double weight;
  final int reps;

  const LogSetItem({
    super.key,
    required this.setNumber,
    required this.weight,
    required this.reps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).extension<AppTheme>()!.background2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'Set $setNumber',
              style: TextStyle(
                color: Theme.of(context).extension<AppTheme>()!.text,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$weight Kg",
                  style: TextStyle(
                    color: Theme.of(context).extension<AppTheme>()!.text,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Reps: $reps",
                  style: TextStyle(
                    color: Theme.of(context).extension<AppTheme>()!.text,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
