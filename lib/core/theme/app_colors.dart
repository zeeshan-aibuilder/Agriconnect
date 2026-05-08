import 'package:flutter/material.dart';

class AppColors {
  // Primary Green
  static const Color primary500 = Color(0xFF2E7D32);
  static const Color primary600 = Color(0xFF388E3C);
  static const Color primary700 = Color(0xFF1B5E20);

  // Accent Orange
  static const Color accent500 = Color(0xFFFF6F00);
  static const Color accent600 = Color(0xFFF57C00);
  static const Color accent700 = Color(0xFFE65100);

  // Neutrals (Whites & Grays)
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray900 = Color(0xFF111827);

  // Semantic Colors
  static const Color success500 = Color(0xFF10B981);
  static const Color error500 = Color(0xFFEF4444);
  static const Color warning500 = Color(0xFFF59E0B);
  static const Color info500 = Color(0xFF3B82F6);

  // Background Surfaces
  static const Color bgPrimary = Color(0xFFFFFFFF);
  static const Color bgSecondary = Color(0xFFF9FAFB);
  static const Color bgTertiary = Color(0xFFF3F4F6);

  // Gradients (Flutter uses LinearGradient instead of solid colors for this)
  static const LinearGradient gradientGreen = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2E7D32), Color(0xFF388E3C), Color(0xFF1B5E20)],
  );
}