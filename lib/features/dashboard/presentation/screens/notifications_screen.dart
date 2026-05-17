import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> alerts = [
      {
        'title': 'New high-paying job near you!',
        'time': '2 mins ago',
        'type': 'job',
        'read': false,
      },
      {
        'title': 'Payment of Rs. 42,500 processed.',
        'time': 'Yesterday',
        'type': 'payment',
        'read': true,
      },
      {
        'title': 'Your vehicle documents are verified.',
        'time': '3 days ago',
        'type': 'system',
        'read': true,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.gray900,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Notifications', style: AppTextStyles.h4),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: alerts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final alert = alerts[index];
          final bool isUnread = !alert['read'];

          IconData icon;
          Color color;

          if (alert['type'] == 'job') {
            icon = Icons.local_shipping_rounded;
            color = AppColors.primary700;
          } else if (alert['type'] == 'payment') {
            icon = Icons.account_balance_wallet_rounded;
            color = AppColors.success500;
          } else {
            icon = Icons.admin_panel_settings_rounded;
            color = AppColors.warning500;
          }

          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isUnread ? Colors.white : AppColors.bgSecondary,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isUnread
                    ? AppColors.primary700.withValues(alpha: 0.3)
                    : AppColors.gray200,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert['title'],
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: isUnread
                              ? FontWeight.w800
                              : FontWeight.w600,
                          color: AppColors.gray900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        alert['time'],
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.gray500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isUnread)
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.primary700,
                      shape: BoxShape.circle,
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
