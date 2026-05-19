import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

/// Тема застосунку TacMed з підтримкою Material 3.
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryRed,
        brightness: Brightness.light,
      ),
      // Поверхні
      scaffoldBackgroundColor: AppColors.darkBackground,
      canvasColor: AppColors.surfaceColor,
      cardColor: AppColors.cardColor,

      // Тема AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceColor,
        foregroundColor: AppColors.textPrimary,
        elevation: 1,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppDimensions.fontSize2xLarge,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Тема тексту
      textTheme: _buildTextTheme(),

      // Теми кнопок
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: AppColors.textPrimary,
          minimumSize: const Size(0, AppDimensions.buttonHeightLarge),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          ),
          textStyle: const TextStyle(
            fontSize: AppDimensions.fontSizeBase,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryRed,
          minimumSize: const Size(0, AppDimensions.buttonHeightLarge),
          side: const BorderSide(color: AppColors.primaryRed),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          ),
          textStyle: const TextStyle(
            fontSize: AppDimensions.fontSizeBase,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Тема полів введення
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLarge,
          vertical: AppDimensions.paddingMedium,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: const BorderSide(color: AppColors.primaryRed, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: const BorderSide(color: AppColors.errorRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
        ),
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppDimensions.fontSizeBase,
        ),
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppDimensions.fontSizeBase,
        ),
        helperStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppDimensions.fontSizeSmall,
        ),
        errorStyle: const TextStyle(
          color: AppColors.errorRed,
          fontSize: AppDimensions.fontSizeSmall,
        ),
      ),

      // Тема діалогів
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
      ),

      // Тема карток
      cardTheme: CardTheme(
        color: AppColors.cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        ),
        margin: const EdgeInsets.all(AppDimensions.paddingMedium),
      ),

      // Тема розділювачів
      dividerTheme: DividerThemeData(
        color: AppColors.dividerColor,
        thickness: 1,
        space: AppDimensions.spacerMedium,
      ),

      // Тема нижньої панелі
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceColor,
        elevation: 8,
      ),

      // Тема FloatingActionButton
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
      ),

      // Тема чипів
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.cardColor,
        selectedColor: AppColors.primaryRed,
        labelStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppDimensions.fontSizeBase,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
      ),

      // Інше
      primaryColor: AppColors.primaryRed,
      indicatorColor: AppColors.primaryRed,
      disabledColor: AppColors.textSecondary,
      focusColor: AppColors.primaryRed,
      hoverColor: AppColors.primaryRed.withValues(alpha: 0.1),
      highlightColor: AppColors.primaryRed.withValues(alpha: 0.2),
      splashColor: AppColors.primaryRed.withValues(alpha: 0.3),
    );
  }

  static ThemeData get darkTheme {
    return lightTheme;
  }

  static TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: AppDimensions.fontSize3xLarge,
        fontWeight: FontWeight.bold,
        height: AppDimensions.lineHeightSmall,
      ),
      displayMedium: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: AppDimensions.fontSize2xLarge,
        fontWeight: FontWeight.bold,
        height: AppDimensions.lineHeightSmall,
      ),
      displaySmall: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: AppDimensions.fontSizeXLarge,
        fontWeight: FontWeight.bold,
        height: AppDimensions.lineHeightSmall,
      ),
      headlineLarge: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: AppDimensions.fontSize2xLarge,
        fontWeight: FontWeight.bold,
        height: AppDimensions.lineHeightSmall,
      ),
      headlineMedium: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: AppDimensions.fontSizeLarge,
        fontWeight: FontWeight.bold,
        height: AppDimensions.lineHeightMedium,
      ),
      headlineSmall: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: AppDimensions.fontSizeBase,
        fontWeight: FontWeight.bold,
        height: AppDimensions.lineHeightMedium,
      ),
      titleLarge: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: AppDimensions.fontSizeLarge,
        fontWeight: FontWeight.w600,
        height: AppDimensions.lineHeightMedium,
      ),
      titleMedium: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: AppDimensions.fontSizeBase,
        fontWeight: FontWeight.w600,
        height: AppDimensions.lineHeightMedium,
      ),
      titleSmall: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: AppDimensions.fontSizeMedium,
        fontWeight: FontWeight.w600,
        height: AppDimensions.lineHeightMedium,
      ),
      bodyLarge: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: AppDimensions.fontSizeBase,
        fontWeight: FontWeight.normal,
        height: AppDimensions.lineHeightLarge,
      ),
      bodyMedium: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: AppDimensions.fontSizeMedium,
        fontWeight: FontWeight.normal,
        height: AppDimensions.lineHeightMedium,
      ),
      bodySmall: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: AppDimensions.fontSizeSmall,
        fontWeight: FontWeight.normal,
        height: AppDimensions.lineHeightMedium,
      ),
      labelLarge: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: AppDimensions.fontSizeBase,
        fontWeight: FontWeight.w600,
        height: AppDimensions.lineHeightSmall,
      ),
      labelMedium: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: AppDimensions.fontSizeMedium,
        fontWeight: FontWeight.w600,
        height: AppDimensions.lineHeightSmall,
      ),
      labelSmall: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: AppDimensions.fontSizeSmall,
        fontWeight: FontWeight.w600,
        height: AppDimensions.lineHeightSmall,
      ),
    );
  }
}
