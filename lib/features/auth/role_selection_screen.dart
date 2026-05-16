import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../core/theme/app_colors.dart';
import 'register_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: Stack(
        children: [
          // --- PRECISE AMBIENT GLOW BACKGROUND ---
          Positioned(
            top: -50,
            right: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFC7D2FE).withValues(alpha: 0.4),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFC7D2FE).withValues(alpha: 0.2),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFDE68A).withValues(alpha: 0.3),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFDE68A).withValues(alpha: 0.15),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          // --- MAIN CONTENT ---
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.grass_rounded,
                                color: Color(0xFF1E3A8A),
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Choose Your Role',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: AppColors.gray900,
                            letterSpacing: -1,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Select how you want to use AgriConnect to tailor your premium experience.',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.gray600,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Role Cards
                        _GlassyRoleCard(
                          title: 'I am a Supplier',
                          subtitle: 'Farmers & Growers listing excess produce.',
                          icon: Icons.agriculture_rounded,
                          color: const Color(0xFF4F46E5),
                          isSelected: selectedRole == 'supplier',
                          onTap: () =>
                              setState(() => selectedRole = 'supplier'),
                        ),
                        const SizedBox(height: 16),
                        _GlassyRoleCard(
                          title: 'I am a B2B Buyer',
                          subtitle: 'Factories & Mills posting bulk demands.',
                          icon: Icons.factory_rounded,
                          color: const Color(0xFFF59E0B),
                          isSelected: selectedRole == 'buyer',
                          onTap: () => setState(() => selectedRole = 'buyer'),
                        ),
                        const SizedBox(height: 16),
                        _GlassyRoleCard(
                          title: 'Logistics Partner',
                          subtitle: 'Provide transport and fleet tracking.',
                          icon: Icons.local_shipping_rounded,
                          color: const Color(0xFF10B981),
                          isSelected: selectedRole == 'transporter',
                          onTap: () =>
                              setState(() => selectedRole = 'transporter'),
                        ),

                        const Spacer(),
                        const SizedBox(height: 32),

                        // Premium Continue Button
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: selectedRole != null
                                ? [
                                    BoxShadow(
                                      color: _getRoleColor(
                                        selectedRole,
                                      ).withValues(alpha: 0.3),
                                      blurRadius: 24,
                                      offset: const Offset(0, 8),
                                    ),
                                  ]
                                : [],
                          ),
                          child: ElevatedButton(
                            onPressed: selectedRole == null
                                ? null
                                : () {
                                    HapticFeedback.mediumImpact();
                                    // 🔥 SENIOR FIX: Passing the selected role to RegisterScreen!
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterScreen(role: selectedRole!),
                                      ),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedRole != null
                                  ? _getRoleColor(selectedRole)
                                  : AppColors.gray300,
                              disabledBackgroundColor: Colors.white.withValues(
                                alpha: 0.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: selectedRole == null
                                        ? AppColors.gray400
                                        : Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 20,
                                  color: selectedRole == null
                                      ? AppColors.gray400
                                      : Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  Color _getRoleColor(String? role) {
    if (role == 'supplier') return const Color(0xFF4F46E5);
    if (role == 'buyer') return const Color(0xFFF59E0B);
    if (role == 'transporter') return const Color(0xFF10B981);
    return AppColors.primary700;
  }
}

class _GlassyRoleCard extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _GlassyRoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: isSelected ? 20 : 10,
            sigmaY: isSelected ? 20 : 10,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: 0.05)
                  : Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected ? color.withValues(alpha: 0.5) : Colors.white,
                width: isSelected ? 2 : 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 28, color: color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.gray900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.gray500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




