import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headings
  static TextStyle h1 = GoogleFonts.inter(
    fontSize: 40, fontWeight: FontWeight.w700, height: 1.2, letterSpacing: -0.5, color: AppColors.gray900);
  static TextStyle h2 = GoogleFonts.inter(
    fontSize: 32, fontWeight: FontWeight.w700, height: 1.25, letterSpacing: -0.4, color: AppColors.gray900);
  static TextStyle h3 = GoogleFonts.inter(
    fontSize: 24, fontWeight: FontWeight.w600, height: 1.33, letterSpacing: -0.2, color: AppColors.gray900);
  static TextStyle h4 = GoogleFonts.inter(
    fontSize: 20, fontWeight: FontWeight.w600, height: 1.4, letterSpacing: 0, color: AppColors.gray900);
  
  // Body Text
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 18, fontWeight: FontWeight.w400, height: 1.55, color: AppColors.gray700);
  static TextStyle bodyDefault = GoogleFonts.inter(
    fontSize: 16, fontWeight: FontWeight.w400, height: 1.5, color: AppColors.gray700);
  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 16, fontWeight: FontWeight.w500, height: 1.5, color: AppColors.gray900);
  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w400, height: 1.42, color: AppColors.gray700);
  
  // Captions & Buttons
  static TextStyle caption = GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w400, height: 1.33, color: AppColors.gray500);
  static TextStyle buttonText = GoogleFonts.inter(
    fontSize: 16, fontWeight: FontWeight.w500, height: 1.5, color: AppColors.white);
}