import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;

    return Container(
      height: 56, // Specs ke mutabiq exact height
      width: double.infinity, // Full width by default
      decoration: BoxDecoration(
        // Agar disabled hai toh gray, warna gradient green
        gradient: isDisabled ? null : AppColors.gradientGreen,
        color: isDisabled ? AppColors.gray300 : null,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDisabled 
            ? [] 
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style: AppTextStyles.buttonText.copyWith(
                color: isDisabled ? AppColors.gray500 : AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}