import 'package:flutter/material.dart';
import 'package:rep_records/theme/app_theme.dart';

class LogSetItem extends StatelessWidget {
  const LogSetItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(flex: 1, child: Text('Set ${1}')),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "10 Kg",
                      style: TextStyle(
                        color: Theme.of(context).extension<AppTheme>()!.text,
                      ),
                    ),
                    Text(
                      "Reps: 10",
                      style: TextStyle(
                        color: Theme.of(context).extension<AppTheme>()!.text,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (true) Divider(height: 1, color: Theme.of(context).extension<AppTheme>()!.text.withAlpha(30),),
      ],
    );
    ;
  }
}
