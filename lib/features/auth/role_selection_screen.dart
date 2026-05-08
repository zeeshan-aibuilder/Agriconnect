import 'package:flutter/material.dart';
import 'dart:ui'; // For Glassmorphism blur effects
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'login_screen.dart';

// ==========================================
// ULTRA-PREMIUM DESIGN TOKENS
// ==========================================
const Color _ink = Color(0xFF1E293B); 
const Color _muted = Color(0xFF64748B);
const Color _primaryGreen = Color(0xFF10B981); 
const Color _accentOrange = Color(0xFFF59E0B);
const Color _surfaceSoft = Color(0xFFF8FAFC); 
const Color _hairline = Color(0xFFE2E8F0);

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? selectedRole; // 'farmer' ya 'industry'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ---- 1. BACKGROUND GLOW EFFECTS (Apple/Microsoft Style) ----
          Positioned(
            top: -100, right: -50,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _primaryGreen.withOpacity(0.05),
                boxShadow: [BoxShadow(color: _primaryGreen.withOpacity(0.1), blurRadius: 100, spreadRadius: 50)],
              ),
            ),
          ),
          Positioned(
            bottom: -50, left: -50,
            child: Container(
              width: 250, height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _accentOrange.withOpacity(0.05),
                boxShadow: [BoxShadow(color: _accentOrange.withOpacity(0.1), blurRadius: 100, spreadRadius: 50)],
              ),
            ),
          ),

          // ---- 2. MAIN CONTENT ----
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo or Brand Icon Area
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _surfaceSoft,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: _hairline),
                          ),
                          child: const Icon(Icons.grass_rounded, color: _primaryGreen, size: 32),
                        ),
                        const SizedBox(height: 32),
                        
                        // Hero Typography
                        const Text(
                          'Choose Your Role', 
                          style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: _ink, letterSpacing: -1, height: 1.1)
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Select how you want to use AgriConnect to tailor your experience.', 
                          style: TextStyle(fontSize: 16, color: _muted, height: 1.5, fontWeight: FontWeight.w500)
                        ),
                        const SizedBox(height: 48),
                        
                        // Premium Interactive Role Cards
                        _PremiumRoleCard(
                          title: 'I am a Farmer',
                          subtitle: 'Sell crops, buy machinery, and get market updates.',
                          icon: Icons.agriculture_rounded,
                          color: _primaryGreen,
                          isSelected: selectedRole == 'farmer',
                          onTap: () => setState(() => selectedRole = 'farmer'),
                        ),
                        const SizedBox(height: 20),
                        _PremiumRoleCard(
                          title: 'I am an Industry Partner',
                          subtitle: 'Procure bulk crops and contract with verified farmers.',
                          icon: Icons.factory_rounded,
                          color: _accentOrange,
                          isSelected: selectedRole == 'industry',
                          onTap: () => setState(() => selectedRole = 'industry'),
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
                                ? [BoxShadow(color: (selectedRole == 'farmer' ? _primaryGreen : _accentOrange).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))]
                                : [],
                          ),
                          child: ElevatedButton(
                            onPressed: selectedRole == null 
                                ? null 
                                : () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(role: selectedRole!)));
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedRole == 'farmer' ? _primaryGreen : (selectedRole == 'industry' ? _accentOrange : _surfaceSoft),
                              disabledBackgroundColor: _surfaceSoft,
                              foregroundColor: Colors.white,
                              disabledForegroundColor: _muted,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Continue', 
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: -0.2, color: selectedRole == null ? _muted : Colors.white)
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.arrow_forward_rounded, size: 20, color: selectedRole == null ? _muted : Colors.white),
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
}

// ==========================================
// UX: MICRO-INTERACTIVE ROLE CARD
// ==========================================
class _PremiumRoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _PremiumRoleCard({
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? color : _hairline,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected) 
              BoxShadow(color: color.withOpacity(0.15), blurRadius: 24, offset: const Offset(0, 8))
            else 
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Floating 3D-like Icon Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isSelected 
                      ? [color.withOpacity(0.2), color.withOpacity(0.05)]
                      : [_surfaceSoft, Colors.white],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? color.withOpacity(0.5) : _hairline),
              ),
              child: Icon(icon, size: 32, color: isSelected ? color : _ink),
            ),
            const SizedBox(width: 20),
            
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                      color: _ink,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: _muted,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            // Selection Radio Indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(top: 10),
              width: 24, height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? color : Colors.white,
                border: Border.all(color: isSelected ? color : _hairline, width: 2),
              ),
              child: isSelected 
                  ? const Icon(Icons.check_rounded, size: 14, color: Colors.white) 
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}