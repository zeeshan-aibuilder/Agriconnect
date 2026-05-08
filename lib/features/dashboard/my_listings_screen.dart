import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class MyListingsScreen extends StatelessWidget {
  final String role;

  const MyListingsScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final isFarmer = role == 'farmer';
    final screenTitle = isFarmer ? 'My Listings' : 'My Demands';

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        // EXACT HOME SCREEN WALA BACKGROUND COLOR
        backgroundColor: AppColors.bgSecondary,
        
        // ---- PERFECTLY MATCHED HEADER ----
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          // Home screen ki tarah gol corners
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          // EXACT HOME SCREEN WALA GRADIENT
          flexibleSpace: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.gradientGreen, 
              ),
            ),
          ),
          title: Text(
            screenTitle, 
            style: AppTextStyles.h3.copyWith(color: AppColors.white)
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Container(
              padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.white.withOpacity(0.2)),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  labelColor: AppColors.primary500, // Text color when selected
                  unselectedLabelColor: AppColors.white.withOpacity(0.8), // Text color when unselected
                  labelStyle: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
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
            _buildPremiumList(isFarmer, 'Active', 3),
            _buildPremiumList(isFarmer, 'Pending', 1),
            _buildEmptyState(isFarmer),
          ],
        ),
        
        // ---- MATCHING ACTION BUTTON ----
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: AppColors.primary500, // Home Screen ka original primary color
          elevation: 6,
          icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.white),
          label: Text(
            isFarmer ? 'Sell Crop' : 'Post Demand',
            style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumList(bool isFarmer, String status, int count) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: count,
      itemBuilder: (context, index) {
        return _ModernListingCard(isFarmer: isFarmer, status: status);
      },
    );
  }

  Widget _buildEmptyState(bool isFarmer) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.primary500.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFarmer ? Icons.eco_outlined : Icons.inventory_2_outlined,
                size: 80,
                color: AppColors.primary500.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: 24),
            Text('No History Found', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Text(
              'Aapki purani listings yahan nazar aayengi.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.gray500),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModernListingCard extends StatelessWidget {
  final bool isFarmer;
  final String status;

  const _ModernListingCard({required this.isFarmer, required this.status});

  @override
  Widget build(BuildContext context) {
    bool isActive = status == 'Active';
    // Using Original AppColors for Badges
    Color badgeColor = isActive ? AppColors.success500 : AppColors.warning500;
    String badgeText = isActive ? 'LIVE' : 'REVIEW';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Image Placeholder
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.gray50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isFarmer ? Icons.grass_rounded : Icons.factory_rounded,
                    color: AppColors.primary500,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: badgeColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              badgeText,
                              style: AppTextStyles.caption.copyWith(
                                color: badgeColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Icon(Icons.more_horiz_rounded, color: AppColors.gray400),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isFarmer ? 'Sandal Bar Wheat' : 'Corn Requirement',
                        style: AppTextStyles.h4,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rs 4,500 / 40kg',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.primary500,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Action & Stats Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              color: AppColors.bgSecondary, // Original theme color
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildMiniStat(Icons.remove_red_eye_outlined, '1.2k'),
                    const SizedBox(width: 16),
                    _buildMiniStat(Icons.favorite_border_rounded, '45'),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gray200),
                  ),
                  child: Text(
                    'Edit Details',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.gray900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.gray500),
        const SizedBox(width: 4),
        Text(value, style: AppTextStyles.caption.copyWith(color: AppColors.gray500, fontWeight: FontWeight.bold)),
      ],
    );
  }
}