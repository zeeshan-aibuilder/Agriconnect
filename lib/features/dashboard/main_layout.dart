import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../core/theme/app_colors.dart';

import 'home_screen.dart';
import '../listings/my_listings_screen.dart';
import '../chat/messages_screen.dart';
import 'user_profile_screen.dart';
import '../listings/add_listing_screen.dart';
import '../logistics/presentation/screens/command_center_screen.dart';

class MainLayout extends StatefulWidget {
  final String role;
  final String userName;

  const MainLayout({
    super.key,
    required this.role,
    this.userName = 'Verified User',
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _setupRoleBasedScreens();
  }

  void _setupRoleBasedScreens() {
    if (widget.role == 'transporter') {
      _screens = [
        const CommandCenterScreen(),
        MyListingsScreen(role: widget.role),
        MessagesScreen(role: widget.role), // 🔥 ERROR FIXED
        UserProfileScreen(
          userName: widget.userName,
          role: widget.role,
        ), // 🔥 ERROR FIXED
      ];
    } else {
      _screens = [
        HomeScreen(role: widget.role),
        MyListingsScreen(role: widget.role),
        MessagesScreen(role: widget.role), // 🔥 ERROR FIXED
        UserProfileScreen(
          userName: widget.userName,
          role: widget.role,
        ), // 🔥 ERROR FIXED
      ];
    }
  }

  void _handleTabChanged(int index) {
    HapticFeedback.selectionClick();
    setState(() => _currentIndex = index);
  }

  void _handleFabAction() {
    HapticFeedback.mediumImpact();
    if (widget.role == 'transporter') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vehicle Registration coming in Phase 2! 🚚'),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddListingScreen(role: widget.role),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _MainLayoutUI(
      currentIndex: _currentIndex,
      screens: _screens,
      userRole: widget.role,
      onTabChanged: _handleTabChanged,
      onFabPressed: _handleFabAction,
    );
  }
}

class _MainLayoutUI extends StatelessWidget {
  final int currentIndex;
  final List<Widget> screens;
  final String userRole;
  final ValueChanged<int> onTabChanged;
  final VoidCallback onFabPressed;

  const _MainLayoutUI({
    required this.currentIndex,
    required this.screens,
    required this.userRole,
    required this.onTabChanged,
    required this.onFabPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.bgSecondary,
      body: IndexedStack(index: currentIndex, children: screens),
      floatingActionButton: _CenterActionButton(
        onPressed: onFabPressed,
        role: userRole,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _GlassySpotlightNavBar(
        currentIndex: currentIndex,
        role: userRole,
        onTap: onTabChanged,
      ),
    );
  }
}

class _CenterActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String role;

  const _CenterActionButton({required this.onPressed, required this.role});

  @override
  Widget build(BuildContext context) {
    final IconData fabIcon = role == 'transporter'
        ? Icons.local_shipping_rounded
        : Icons.add_rounded;
    return Container(
      height: 60,
      width: 60,
      margin: const EdgeInsets.only(top: 36),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary700.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        backgroundColor: AppColors.primary700,
        elevation: 0,
        shape: const CircleBorder(),
        onPressed: onPressed,
        child: Icon(fabIcon, color: Colors.white, size: 32),
      ),
    );
  }
}

class _GlassySpotlightNavBar extends StatelessWidget {
  final int currentIndex;
  final String role;
  final Function(int) onTap;

  const _GlassySpotlightNavBar({
    required this.currentIndex,
    required this.role,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final IconData homeIcon = role == 'transporter'
        ? Icons.dashboard_rounded
        : Icons.home_filled;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          height: 75,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.6),
                width: 1.5,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            bottom: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavItem(
                  icon: homeIcon,
                  index: 0,
                  current: currentIndex,
                  onTap: onTap,
                ),
                _NavItem(
                  icon: Icons.storefront_rounded,
                  index: 1,
                  current: currentIndex,
                  onTap: onTap,
                ),
                const SizedBox(width: 64),
                _NavItem(
                  icon: Icons.chat_bubble_rounded,
                  index: 2,
                  current: currentIndex,
                  onTap: onTap,
                  hasBadge: true,
                ),
                _NavItem(
                  icon: Icons.person_rounded,
                  index: 3,
                  current: currentIndex,
                  onTap: onTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final int index, current;
  final Function(int) onTap;
  final bool hasBadge;

  const _NavItem({
    required this.icon,
    required this.index,
    required this.current,
    required this.onTap,
    this.hasBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = current == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        height: 75,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isActive)
              Positioned(
                top: 8,
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary700.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 1.0, end: isActive ? 1.15 : 1.0),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  builder: (context, scale, child) => Transform.scale(
                    scale: scale,
                    child: Icon(
                      icon,
                      size: 26,
                      color: isActive
                          ? AppColors.primary700
                          : AppColors.gray400,
                    ),
                  ),
                ),
                if (hasBadge)
                  Positioned(
                    top: -2,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.error500,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            if (isActive)
              Positioned(
                bottom: 12,
                child: Container(
                  height: 4,
                  width: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.primary700,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
