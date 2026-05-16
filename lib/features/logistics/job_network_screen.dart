import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_card.dart';

class JobNetworkScreen extends StatelessWidget {
  const JobNetworkScreen({super.key});

  void _showBidBottomSheet(BuildContext context, String type, String route) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Submit Bid for $type', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Text(
              'Route: $route',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.gray500,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              keyboardType: TextInputType.number,
              style: AppTextStyles.h4,
              decoration: InputDecoration(
                labelText: 'Your Offer (PKR)',
                prefixText: 'Rs. ',
                filled: true,
                fillColor: AppColors.gray50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Message to Shipper (Optional)',
                hintText: 'E.g. I have a chilled container ready.',
                filled: true,
                fillColor: AppColors.gray50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'Submit Binding Offer',
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Bid submitted! Shipper will review your profile.',
                    ),
                    backgroundColor: AppColors.success500,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter Loads', style: AppTextStyles.h3),
            const SizedBox(height: 24),
            Text('Cargo Type', style: AppTextStyles.caption),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('Flatbed'),
                  selected: true,
                  onSelected: (_) {},
                  selectedColor: AppColors.primary700.withValues(alpha: 0.1),
                  checkmarkColor: AppColors.primary700,
                ),
                FilterChip(
                  label: const Text('Chilled Container'),
                  selected: false,
                  onSelected: (_) {},
                ),
                FilterChip(
                  label: const Text('Tanker'),
                  selected: false,
                  onSelected: (_) {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'Apply Filters',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Available Loads'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildJobCard(
            context,
            'Premium Wheat',
            '50 Tons',
            'Sargodha ➔ Lahore',
            'Rs. 85,000',
            shipperName: 'Chaudhry Farms',
            rating: '4.8',
            isVerified: true,
            isUrgent: true,
          ),
          _buildJobCard(
            context,
            'Export Quality Cherries',
            '12 Tons',
            'Gilgit ➔ Islamabad',
            'Rs. 1,40,000',
            shipperName: 'Gilgit Organics',
            rating: '5.0',
            isVerified: true,
            isUrgent: false,
          ),
          _buildJobCard(
            context,
            'Cotton Bales',
            '100 Tons',
            'Bahawalpur ➔ Karachi',
            'Rs. 2,10,000',
            shipperName: 'XYZ Textiles',
            rating: '4.2',
            isVerified: false,
            isUrgent: false,
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(
    BuildContext context,
    String type,
    String weight,
    String route,
    String price, {
    required String shipperName,
    required String rating,
    required bool isVerified,
    required bool isUrgent,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (isVerified)
                            const Icon(
                              Icons.verified_rounded,
                              color: AppColors.info500,
                              size: 18,
                            ),
                          if (isVerified) const SizedBox(width: 4),
                          Text(
                            type,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary700,
                            ),
                          ),
                        ],
                      ),
                      if (isUrgent)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error500.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'URGENT',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.error500,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.local_shipping_outlined,
                        color: AppColors.gray500,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        route,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.scale_rounded,
                        color: AppColors.gray500,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(weight, style: AppTextStyles.bodySmall),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(height: 1),
                  ),
                  // TRUST SIGNALS
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.gray200,
                        child: Icon(
                          Icons.person,
                          size: 14,
                          color: AppColors.gray500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        shipperName,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.warning500,
                        size: 14,
                      ),
                      Text(
                        rating,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: AppColors.gray50,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Est. Payment', style: AppTextStyles.caption),
                      Text(
                        price,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => _showBidBottomSheet(context, type, route),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gray900,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Bid Now'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
