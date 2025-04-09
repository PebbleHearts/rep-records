import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_records/providers/theme_provider.dart';
import 'package:rep_records/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      backgroundColor: Theme.of(context).extension<AppTheme>()!.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Dark Mode'),
                          Switch(value: themeProvider.themeMode == ThemeMode.dark, onChanged: (value) {
                            print('value: $value');
                            themeProvider.toggleTheme();
                          }),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
