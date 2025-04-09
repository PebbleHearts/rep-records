import 'package:flutter/material.dart';
import 'package:rep_records/components/bottom-tab-bar/bottom_tab_item.dart';
import 'package:rep_records/data-model/common.dart';
import 'package:rep_records/theme/app_theme.dart';

class BottomTabBar extends StatelessWidget {
  final int currentIndex;
  final Function handleIndexChange;
  BottomTabBar({
    super.key,
    required this.currentIndex,
    required this.handleIndexChange,
  });

  final _tabs = [
    CustomBottomTabItem(icon: Icons.history, label: 'Log'),
    CustomBottomTabItem(icon: Icons.category, label: 'Exercises'),
    CustomBottomTabItem(icon: Icons.group_work, label: 'Routines'),
    CustomBottomTabItem(icon: Icons.person, label: 'Profile')
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).extension<AppTheme>()!.background3,
      child: SafeArea(
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _tabs
                .asMap()
                .entries
                .map(
                  (entry) => BottomTabItem(
                    tabItem: entry.value,
                    isSelected: currentIndex == entry.key,
                    onPress: () => handleIndexChange(entry.key),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
