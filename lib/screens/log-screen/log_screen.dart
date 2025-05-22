import 'package:flutter/material.dart';
import 'package:rep_records/components/horizontal-date-selector/horizontal_date_selector.dart';
import 'package:rep_records/screens/edit-log-screen/edit_log_screen.dart';
import 'package:rep_records/screens/log-screen/components/log_item.dart';
import 'package:rep_records/theme/app_theme.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).extension<AppTheme>()!.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditLogScreen()));
            },
            icon: Icon(Icons.edit),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 200,
                        child: Center(
                          child: Text(
                            'Log',
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Column(
                        spacing: 20,
                        children: [
                          LogItem(),
                          LogItem(),
                          LogItem(),
                          LogItem(),
                          LogItem(),
                          LogItem(),
                          LogItem(),
                          LogItem()
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            HorizontalDateSelector(selectedDate: '2025-03-21', onDateTap: (date) { print(date); })
          ],
        ),
      ),
    );
  }
}
