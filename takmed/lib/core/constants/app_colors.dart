import 'package:flutter/material.dart';

/// Кольорова палітра TacMed.
/// Тактичний стиль: темний фон, тривожно-червоні акценти, military green.
class AppColors {
  // Основні кольори
  static const primaryRed = Color(0xFFD32F2F);
  static const darkBackground = Color(0xFF0D1117);
  static const surfaceColor = Color(0xFF161B22);
  static const cardColor = Color(0xFF21262D);
  static const accentGreen = Color(0xFF3FB950);

  // Текст
  static const textPrimary = Color(0xFFF0F6FC);
  static const textSecondary = Color(0xFF8B949E);

  // Статуси
  static const warningOrange = Color(0xFFF97316);
  static const infoBue = Color(0xFF60A5FA);
  static const successGreen = Color(0xFF10B981);
  static const errorRed = Color(0xFFEF4444);

  // Додаткові
  static const borderColor = Color(0xFF30363D);
  static const dividerColor = Color(0xFF21262D);
  static const backgroundColor = darkBackground;
  static const transparent = Color(0x00000000);

  // Градієнти
  static const gradientStart = Color(0xFFD32F2F);
  static const gradientEnd = Color(0xFF3FB950);
}
