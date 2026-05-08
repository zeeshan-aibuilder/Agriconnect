import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';

class RoleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s6), // 24px padding
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? activeColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Icon Container
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isSelected ? activeColor.withOpacity(0.1) : AppColors.gray50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 44, color: isSelected ? activeColor : AppColors.gray500),
            ),
            const SizedBox(height: AppSpacing.s4),
            
            // Text ko FittedBox mein wrap kiya taake lamba word chhota ho jaye, line break na kare
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                maxLines: 1, // Hamesha 1 line mein rahega
                style: AppTextStyles.h4.copyWith(
                  color: isSelected ? AppColors.gray900 : AppColors.gray500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}