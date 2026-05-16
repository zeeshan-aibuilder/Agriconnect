import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class DriverPublicProfile extends StatelessWidget {
  final String driverName;
  const DriverPublicProfile({super.key, required this.driverName});

  @override
  Widget build(BuildContext context) {
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
        title: Text('Transporter Profile', style: AppTextStyles.h4),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // --- 1. IDENTITY & TRUST HEADER ---
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.primary700.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary700,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            driverName[0],
                            style: AppTextStyles.h1.copyWith(
                              color: AppColors.primary700,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.success500,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified_user_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(driverName, style: AppTextStyles.h3),
                  Text(
                    'Independent Owner Operator',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- 2. RATING BREAKDOWN (INDRIVE STYLE) ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.gray200),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.warning500,
                        size: 32,
                      ),
                      const SizedBox(width: 8),
                      Text('4.9', style: AppTextStyles.h1),
                      const SizedBox(width: 8),
                      Text('(128 Reviews)', style: AppTextStyles.caption),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(height: 1),
                  ),
                  _buildRatingBar('Safety & Driving', 0.98),
                  const SizedBox(height: 8),
                  _buildRatingBar('Punctuality (On-time)', 0.95),
                  const SizedBox(height: 8),
                  _buildRatingBar('Behavior & Comms', 0.99),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- 3. TRUCK DETAILS ---
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'VEHICLE DETAILS',
                style: AppTextStyles.caption.copyWith(
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.gray900,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_shipping_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mazda 22 Wheeler (Flatbed)',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Capacity: 50 Tons',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Reg: LHR-9082',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- 4. VERIFICATIONS ---
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'VERIFICATIONS',
                style: AppTextStyles.caption.copyWith(
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.gray200),
              ),
              child: Column(
                children: [
                  _buildVerifyRow('CNIC Authenticated', true),
                  const Divider(height: 1),
                  _buildVerifyRow('Driving License Validated', true),
                  const Divider(height: 1),
                  _buildVerifyRow('Vehicle Fitness Certificate', true),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar(String label, double value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: AppColors.gray200,
              color: AppColors.warning500,
              minHeight: 8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyRow(String title, bool isVerified) {
    return ListTile(
      leading: const Icon(Icons.shield_rounded, color: AppColors.success500),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(
        Icons.check_circle_rounded,
        color: AppColors.success500,
        size: 20,
      ),
    );
  }
}
