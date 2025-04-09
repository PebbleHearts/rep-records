import 'package:flutter/material.dart';
import 'package:rep_records/theme/app_theme.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  extensions: <ThemeExtension<AppTheme>>[
    const AppTheme(
      background: Color(0xFFfefbff), // Custom light background
      background2: Color(0xFFf8f2f6),
      background3: Color(0xFFf2ecee),
      accent: Color(0xFFf1d3f9), // Custom light accent
      accent2: Color(0xFF6442d6),
      text: Color(0xFF212121), // Custom light text color
    ),
  ],
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  extensions: <ThemeExtension<AppTheme>>[
    const AppTheme(
      background: Color(0xFF141314), // Custom dark background
      background2: Color(0xFF1c1b1d),
      background3: Color(0xFF211f21),
      accent: Color(0xFF553f5d), // Custom dark accent
      accent2: Color(0xFF9f86ff),
      text: Color(0xFFE0E0E0), // Custom dark text color
    ),
  ],
);