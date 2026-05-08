import 'package:flutter/material.dart';
import 'dart:async';
import '../auth/role_selection_screen.dart'; 

// ==========================================
// ULTRA-PREMIUM DESIGN TOKENS 
// ==========================================
const Color _primaryGreen = Color(0xFF10B981); 
const Color _darkGreen = Color(0xFF064E3B); // Deep rich green for immersive gradient
const Color _surfaceSoft = Color(0xFFF8FAFC); 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  
  // Animation Controllers
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // ---- UX: CHOREOGRAPHED ANIMATIONS ----
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800), // Smooth 1.8s entry
    );

    // Elastic bounce effect for the logo
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut), // Bouncy scale
      ),
    );

    // Delayed fade-in for the text
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn), // Soft fade
      ),
    );

    // Start the animation
    _animationController.forward();

    // Navigate to next screen after delay
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      // ---- UX: CINEMATIC FADE TRANSITION ----
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800), // Slow, premium fade
          pageBuilder: (context, animation, secondaryAnimation) => const RoleSelectionScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          // Immersive Premium Gradient
          gradient: LinearGradient(
            colors: [_primaryGreen, _darkGreen],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ---- ANIMATED LOGO ----
            ScaleTransition(
              scale: _scaleAnimation,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Glow Ring
                  Container(
                    width: 120, height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  // Inner Core Logo
                  Container(
                    width: 88, height: 88,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28), // Premium Squircle
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.eco_rounded, size: 48, color: _primaryGreen),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // ---- ANIMATED TYPOGRAPHY ----
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  const Text(
                    'AgriConnect', 
                    style: TextStyle(
                      fontSize: 36, 
                      fontWeight: FontWeight.w800, 
                      color: Colors.white, 
                      letterSpacing: -1
                    )
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Farmer to Industry Marketplace', 
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.w500, 
                      color: Colors.white.withOpacity(0.8),
                      letterSpacing: 0.5
                    )
                  ),
                ],
              ),
            ),
            
            // Removed the generic loading spinner for a cleaner look!
          ],
        ),
      ),
    );
  }
}