import 'package:flutter/material.dart';

class AppColors {
  // 🔵 Primary: Royal Blue Theme (Trust & Corporate) - Replaces old Green
  static const Color primary500 = Color(0xFF2563EB); // Base Blue
  static const Color primary600 = Color(0xFF1D4ED8); // Deeper Blue
  static const Color primary700 = Color(0xFF1E3A8A); // Royal Blue (Core B2B)

  // 🟢 Accent: Emerald Green Theme (Action & Agriculture) - Replaces old Orange
  static const Color accent500 = Color(0xFF34D399); // Light Emerald
  static const Color accent600 = Color(0xFF10B981); // Core Emerald Green
  static const Color accent700 = Color(0xFF059669); // Dark Emerald

  // ⚪ Neutrals (Whites, Grays & Charcoal Black)
  static const Color white = Color(0xFFFFFFFF); // Pure White
  static const Color gray50 = Color(0xFFF8FAFC); // Off White (Surface Soft)
  static const Color gray100 = Color(0xFFF1F5F9);
  static const Color gray200 = Color(0xFFE2E8F0); // Hairline borders
  static const Color gray300 = Color(0xFFCBD5E1);
  static const Color gray400 = Color(0xFF94A3B8);
  static const Color gray500 = Color(0xFF64748B); // Slate Gray (Text Secondary)
  static const Color gray600 = Color(0xFF475569);
  static const Color gray700 = Color(0xFF334155);
  static const Color gray900 = Color(
    0xFF1E293B,
  ); // Charcoal Black (Text Primary / Ink)

  // 🚦 Semantic Colors (Action States)
  static const Color success500 = Color(0xFF10B981); // Emerald Green
  static const Color error500 = Color(0xFFDC2626); // Crimson Red
  static const Color warning500 = Color(0xFFF59E0B); // Amber / Golden Orange
  static const Color info500 = Color(0xFF3B82F6); // Info Blue

  // 🏢 Background Surfaces
  static const Color bgPrimary = Color(0xFFFFFFFF); // Pure White Surface
  static const Color bgSecondary = Color(0xFFF8FAFC); // Off White BG
  static const Color bgTertiary = Color(0xFFF1F5F9); // Light Muted BG

  // 🎨 Gradients
  // Variable name 'gradientGreen' same rakha hai taake errors na aayen,
  // lekin colors ab premium Emerald Green wale hain.
  static const LinearGradient gradientGreen = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF34D399), Color(0xFF10B981), Color(0xFF059669)],
  );

  // Ek naya gradient add kar diya hai in case UI mein Premium Blue feel deni ho
  static const LinearGradient gradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8), Color(0xFF1E3A8A)],
  );
}
