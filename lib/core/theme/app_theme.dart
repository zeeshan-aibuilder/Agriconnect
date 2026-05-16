import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.bgSecondary,
      primaryColor: AppColors.primary700,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary700,
        secondary: AppColors.accent600,
        surface: AppColors.white,
        error: AppColors.error500,
      ),
      cardColor: AppColors.white,
      dividerColor: AppColors.gray200,
      textTheme: TextTheme(
        displayLarge: AppTextStyles.h1,
        displayMedium: AppTextStyles.h2,
        titleLarge: AppTextStyles.h4,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.gray900),
        titleTextStyle: AppTextStyles.h4,
      ),
    );
  }

  // Dark Theme config can be added here for future scaling
}
