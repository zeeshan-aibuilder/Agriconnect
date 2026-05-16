import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class LegalScreen extends StatelessWidget {
  final String title;
  const LegalScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.primary700,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: -0.5)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppColors.primary700.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: const Text('LAST UPDATED: APRIL 2026', style: TextStyle(color: AppColors.primary700, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.gray200), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 10))]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('1. Introduction'),
                  _buildSectionText('AgriConnect is committed to providing a transparent platform for farmers, buyers, and transporters. By using this app, you agree to our B2B ecosystem policies.'),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Divider(height: 1, color: AppColors.gray200)),
                  
                  _buildSectionTitle('2. Data Usage & Security'),
                  _buildSectionText('We collect minimal data required to connect you with verified buyers. Your location is used strictly for logistics accuracy. Your phone numbers are masked by our AI system during negotiations to prevent direct bypassing and ensure safety.'),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Divider(height: 1, color: AppColors.gray200)),
                  
                  _buildSectionTitle('3. User Conduct & Fraud'),
                  _buildSectionText('Any fraudulent activity, false listings, or misinformation about crop quality (e.g., claiming Grade A for a Grade C crop) will lead to immediate account suspension. All transactions should be transparent and documented within the Deal Room.'),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.gray900, letterSpacing: -0.3));
  }

  Widget _buildSectionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Text(text, style: const TextStyle(fontSize: 15, color: AppColors.gray600, height: 1.6, fontWeight: FontWeight.w500)),
    );
  }
}