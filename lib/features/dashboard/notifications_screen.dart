import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.gray900,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Notifications', style: AppTextStyles.h3),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Mark all read',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary700,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'TODAY',
            style: AppTextStyles.caption.copyWith(
              letterSpacing: 1.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          _buildNotificationCard(
            icon: Icons.check_circle_rounded,
            color: AppColors.success500,
            title: 'Bid Accepted!',
            message:
                'Your bid for 50 Tons Wheat has been accepted by Chaudhry Farms.',
            time: '10 mins ago',
            isUnread: true,
          ),
          _buildNotificationCard(
            icon: Icons.account_balance_wallet_rounded,
            color: AppColors.info500,
            title: 'Payment Received',
            message:
                'Rs. 85,000 has been credited to your wallet for the recent trip.',
            time: '2 hours ago',
            isUnread: true,
          ),
          const SizedBox(height: 24),
          Text(
            'THIS WEEK',
            style: AppTextStyles.caption.copyWith(
              letterSpacing: 1.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          _buildNotificationCard(
            icon: Icons.warning_rounded,
            color: AppColors.warning500,
            title: 'Route Alert',
            message:
                'Heavy traffic reported on M-2 Motorway. Please expect a 45-minute delay.',
            time: '2 days ago',
            isUnread: false,
          ),
          _buildNotificationCard(
            icon: Icons.local_shipping_rounded,
            color: AppColors.primary700,
            title: 'New Load Available',
            message:
                'A new 20-ton Cherry load matching your route (Gilgit ➔ LHR) is available.',
            time: '3 days ago',
            isUnread: false,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color color,
    required String title,
    required String message,
    required String time,
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread
            ? AppColors.primary700.withValues(alpha: 0.05)
            : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUnread
              ? AppColors.primary700.withValues(alpha: 0.2)
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary700,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.gray600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(time, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
