import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_records/navigators/tab-navigator/tab_navigator.dart';
import 'package:rep_records/providers/theme_provider.dart';
import 'package:rep_records/theme/themes.dart';
import 'package:rep_records/database/database.dart';

late AppDatabase database;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('Initializing database...');
  database = AppDatabase();
  
  print('Waiting for database to be ready...');
  await database.beforeOpen;
  print('Database is ready');
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'RepRecords',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      home: const TabNavigator(),
    );
  }
}