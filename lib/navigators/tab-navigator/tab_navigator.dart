import 'package:flutter/material.dart';
import 'package:rep_records/components/bottom-tab-bar/bottom_tab_bar.dart';
import 'package:rep_records/screens/manage-routines-screen/manage_routines_screen.dart';
import 'package:rep_records/screens/log-screen/log_screen.dart';
import 'package:rep_records/screens/manage-screen/manage_screen.dart';
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
    const ManageScreen(),
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
