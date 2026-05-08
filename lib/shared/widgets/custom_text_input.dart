import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class CustomTextInput extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isPassword;

  const CustomTextInput({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56, // Specs ke mutabiq exact height
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword,
        style: AppTextStyles.bodyDefault.copyWith(color: AppColors.gray900),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.bodyDefault.copyWith(color: AppColors.gray400),
          prefixIcon: prefixIcon != null 
              ? Icon(prefixIcon, size: 20, color: AppColors.gray400) 
              : null,
          filled: true,
          fillColor: AppColors.white,
          // Normal state border
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.gray200, width: 2),
          ),
          // Focus hone par border green
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary500, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}