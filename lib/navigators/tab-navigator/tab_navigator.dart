import 'package:flutter/material.dart';
import 'package:rep_records/components/bottom-tab-bar/bottom_tab_bar.dart';
import 'package:rep_records/components/sync-down-bottom-sheetd/sync_down_bottom_sheet.dart';
import 'package:rep_records/screens/manage-routines-screen/manage_routines_screen.dart';
import 'package:rep_records/screens/log-screen/log_screen.dart';
import 'package:rep_records/screens/manage-screen/manage_screen.dart';
import 'package:rep_records/screens/profile-screen/profile_screen.dart';
import 'package:rep_records/services/downsync_service.dart';
class TabNavigator extends StatefulWidget {
  final bool isLoggedInNow;
  
  const TabNavigator({super.key, this.isLoggedInNow = false});

  @override
  State<TabNavigator> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    
    // Check if user just logged in and trigger backup restore dialog
    if (widget.isLoggedInNow) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkAndShowBackupDialog();
      });
    }
  }

  final _pages = [
    const LogScreen(),
    const ManageScreen(),
    const ProfileScreen(),
  ];

  Future<void> _checkAndShowBackupDialog() async {
    // Wait a moment for navigation to complete
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!mounted) return;
    
    try {
      final shouldOfferRestore = await DownsyncService.shouldOfferBackupRestore();
      
      if (shouldOfferRestore && mounted) {
        _showBackupRestoreDialog();
      }
    } catch (error) {
      print('Error checking backup data: $error');
    }
  }

  void _showBackupRestoreDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SyncDownBottomSheet(),
    );
  }

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
