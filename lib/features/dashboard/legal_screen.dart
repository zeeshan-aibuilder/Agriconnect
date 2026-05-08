import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class LegalScreen extends StatelessWidget {
  final String title;
  const LegalScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        backgroundColor: const Color(0xFF022C22),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Last Updated: April 2026', style: AppTextStyles.caption),
            const SizedBox(height: 24),
            Text(
              '1. Introduction\n'
              'AgriConnect is committed to providing a transparent platform for farmers. By using this app, you agree to our policies.\n\n'
              '2. Data Usage\n'
              'We collect minimal data required to connect you with buyers. Your location is used only for logistics accuracy.\n\n'
              '3. User Conduct\n'
              'Any fraudulent activity or misinformation about crops will lead to immediate account suspension.',
              style: AppTextStyles.bodyMedium.copyWith(height: 1.8),
            ),
          ],
        ),
      ),
    );
  }
}