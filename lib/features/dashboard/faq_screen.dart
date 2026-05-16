import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqs = [
      {
        "question": "AgriConnect par account kaise verify karein?",
        "answer":
            "Account verify karne ke liye Settings > Account & Privacy mein jayen aur apna CNIC aur Farm ki details submit karein. 24 ghantay mein verification ho jayegi.",
      },
      {
        "question": "Kya AgriConnect istemal karna free hai?",
        "answer":
            "Ji bilkul! Kisanon ke liye AgriConnect ka istemal 100% free hai. Hum koi commission nahi lete.",
      },
      {
        "question": "Buyers se direct rabta kaise karein?",
        "answer":
            "Dashboard par mojood 'Active Demands' par click karein, aur kisi bhi buyer ki demand par 'Message' ka button daba kar direct chat shuru karein.",
      },
      {
        "question": "Apni crop ki ad (listing) kaise lagayen?",
        "answer":
            "Neechay mojood '+' (Plus) button par click karein, crop ki tasweer, wazan aur qeemat darj karein aur 'Post' daba dein.",
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        backgroundColor: const Color(0xFF022C22),
        title: Text(
          'FAQs & Help',
          style: AppTextStyles.h3.copyWith(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gray200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                ),
              ],
            ),
            child: ExpansionTile(
              iconColor: AppColors.primary500,
              collapsedIconColor: AppColors.gray500,
              title: Text(faqs[index]["question"]!, style: AppTextStyles.h4),
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  child: Text(
                    faqs[index]["answer"]!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.gray600,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
