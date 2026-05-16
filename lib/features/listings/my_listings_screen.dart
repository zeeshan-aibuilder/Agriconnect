import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class MyListingsScreen extends StatelessWidget {
  final String role;
  const MyListingsScreen({super.key, required this.role});

  Map<String, dynamic> _getRoleData() {
    switch (role.toLowerCase()) {
      case 'supplier':
      case 'farmer':
        return {
          'title': 'My Listings',
          'icon': Icons.eco_outlined,
          'btn': 'Sell Crop',
        };
      case 'buyer':
      case 'industry':
        return {
          'title': 'My Demands',
          'icon': Icons.factory_outlined,
          'btn': 'Post Demand',
        };
      case 'transporter':
        return {
          'title': 'My Fleet',
          'icon': Icons.local_shipping_outlined,
          'btn': 'Add Vehicle',
        };
      default:
        return {
          'title': 'Workspace',
          'icon': Icons.inventory_2_outlined,
          'btn': 'Create New',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleData = _getRoleData();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.bgSecondary,
        appBar: AppBar(
          backgroundColor: AppColors.primary700,
          elevation: 0,
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          title: Text(
            roleData['title'],
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Container(
              padding: const EdgeInsets.only(bottom: 20, left: 24, right: 24),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  labelColor: AppColors.primary700,
                  unselectedLabelColor: Colors.white.withValues(alpha: 0.8),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                  tabs: const [
                    Tab(text: 'Active'),
                    Tab(text: 'Pending'),
                    Tab(text: 'Closed'),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildEmptyState(roleData['title'], roleData['icon']),
            _buildEmptyState(roleData['title'], roleData['icon']),
            _buildEmptyState(roleData['title'], roleData['icon']),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary700.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 60,
              color: AppColors.primary700.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No $title Found',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the + button below to create one.',
            style: TextStyle(
              color: AppColors.gray500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
