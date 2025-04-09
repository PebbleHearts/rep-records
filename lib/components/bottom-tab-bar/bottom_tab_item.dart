import 'package:flutter/material.dart';
import 'package:rep_records/data-model/common.dart';
import 'package:rep_records/theme/app_theme.dart';

class BottomTabItem extends StatelessWidget {
  final CustomBottomTabItem tabItem;
  final bool isSelected;
  final VoidCallback onPress;
  const BottomTabItem({
    super.key,
    required this.tabItem,
    required this.isSelected,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Theme.of(context).extension<AppTheme>()!.background3,
        child: InkWell(
          onTap: onPress,
          highlightColor: Theme.of(context).extension<AppTheme>()!.background3.withAlpha(100),
          splashColor: Theme.of(context).extension<AppTheme>()!.background3.withAlpha(100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                tabItem.icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 22,
              ),
              Text(
                tabItem.label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
