import 'package:flutter/material.dart';

@immutable
class AppTheme extends ThemeExtension<AppTheme> {
  final Color background;
  final Color background2;
  final Color background3;
  final Color accent;
  final Color accent2;
  final Color text;

  const AppTheme({
    required this.background,
    required this.background2,
    required this.background3,
    required this.accent,
    required this.accent2,
    required this.text,
  });

  @override
  AppTheme copyWith({
    Color? background,
    Color? background2,
    Color? background3,
    Color? accent,
    Color? accent2,
    Color? text,
  }) {
    return AppTheme(
      background: background ?? this.background,
      background2: background2 ?? this.background2,
      background3: background3 ?? this.background3,
      accent: accent ?? this.accent,
      accent2: accent2 ?? this.accent2,
      text: text ?? this.text,
    );
  }

  @override
  AppTheme lerp(covariant ThemeExtension<AppTheme>? other, double t) {
    if (other is! AppTheme) return this;
    return AppTheme(
      background: Color.lerp(background, other.background, t)!,
      background2: Color.lerp(background2, other.background2, t)!,
      background3: Color.lerp(background3, other.background3, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accent2: Color.lerp(accent2, other.accent2, t)!,
      text: Color.lerp(text, other.text, t)!,
    );
  }
}