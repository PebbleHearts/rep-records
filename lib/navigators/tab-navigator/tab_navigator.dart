import 'package:flutter/material.dart';
import 'package:rep_records/components/bottom-tab-bar/bottom_tab_bar.dart';
import 'package:rep_records/screens/categories-screen/categories_screen.dart';
import 'package:rep_records/screens/log-screen/log_screen.dart';
import 'package:rep_records/screens/profile-screen/profile_screen.dart';
class TabNavigator extends StatefulWidget {
  const TabNavigator({super.key});

  @override
  State<TabNavigator> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  int _currentIndex = 0;

  final _pages = [
    const LogScreen(),
    const CategoriesScreen(),
    const Placeholder(child: Text('Routines screen'),),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomTabBar(
          currentIndex: _currentIndex,
          handleIndexChange: (index) {
            setState(() {
              _currentIndex = index;
            });
          }),
    );
  }
}
