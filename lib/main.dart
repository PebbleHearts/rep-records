import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rep_records/navigators/tab-navigator/tab_navigator.dart';
import 'package:rep_records/providers/theme_provider.dart';
import 'package:rep_records/theme/themes.dart';
import 'package:rep_records/database/database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rep_records/configs/constants.dart';
import 'package:rep_records/screens/onboarding-screen/onboarding_screen.dart';

late AppDatabase database;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isOnboardingCompleted = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isCompleted = prefs.getBool('onboarding_completed') ?? false;
      
      if (mounted) {
        setState(() {
          _isOnboardingCompleted = isCompleted;
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isOnboardingCompleted = false;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'RepRecords',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      home: _isLoading
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : _isOnboardingCompleted
              ? const TabNavigator()
              : const OnboardingScreen(),
    );
  }
}