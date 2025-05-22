import 'package:flutter/material.dart';
import 'package:rep_records/theme/app_theme.dart';

class LogSetItem extends StatelessWidget {
  const LogSetItem({super.key});

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
              'Set 1',
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
                  "10 Kg",
                  style: TextStyle(
                    color: Theme.of(context).extension<AppTheme>()!.text,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Reps: 10",
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
