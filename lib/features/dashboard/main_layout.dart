import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'home_screen.dart';
import 'my_listings_screen.dart';
import 'messages_screen.dart';

class MainLayout extends StatefulWidget {
  final String role;

  const MainLayout({super.key, required this.role});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        role: widget.role,
      ), // WARNING: Is file se BottomNavigationBar hata dena!
      MyListingsScreen(role: widget.role),
      MessagesScreen(role: widget.role),
      Center(child: Text('PROFILE', style: AppTextStyles.h3)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: const Border(
            top: BorderSide(color: AppColors.gray200, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05), // Warning fixed
              blurRadius: 6,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(icon: Icons.home_filled, label: 'Home', index: 0),
            _buildNavItem(
              icon: Icons.inventory_2_rounded,
              label: 'Listings',
              index: 1,
            ),
            _buildNavItem(
              icon: Icons.chat_bubble_rounded,
              label: 'Messages',
              index: 2,
            ),
            _buildNavItem(
              icon: Icons.person_rounded,
              label: 'Profile',
              index: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 60,
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFF0F9F4) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? AppColors.primary500 : AppColors.gray400,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w500,
                color: isActive ? AppColors.primary500 : AppColors.gray400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
