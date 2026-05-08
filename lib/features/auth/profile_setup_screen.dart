import 'package:flutter/material.dart';

// ==========================================
// SAFE RELATIVE IMPORT
// ==========================================
import '../dashboard/home_screen.dart'; 
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

// ==========================================
// ULTRA-PREMIUM DESIGN TOKENS (GREEN THEME)
// ==========================================
const Color _ink = Color(0xFF1E293B); 
const Color _muted = Color(0xFF64748B);
const Color _primaryGreen = Color(0xFF10B981); 
const Color _hairline = Color(0xFFE2E8F0);
const Color _surfaceSoft = Color(0xFFF8FAFC); 

class ProfileSetupScreen extends StatefulWidget {
  final String role; // 'farmer' or 'industry'
  const ProfileSetupScreen({super.key, required this.role});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isLoading = false;

  void _completeSetup() {
    // Basic validation
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter your full name'),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        )
      );
      return;
    }

    setState(() => _isLoading = true);

    // Fake API Delay for premium feel
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);
      
      // Pro UX: Use pushAndRemoveUntil so they can't swipe back to the setup screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(role: widget.role)),
        (route) => false, 
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _businessNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFarmer = widget.role == 'farmer';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ---- HEADER ----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Container(
                    height: 48, width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      shape: BoxShape.circle, 
                      border: Border.all(color: _hairline),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _ink, size: 20),
                      onPressed: () => Navigator.pop(context), 
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: 0.8, // Shows almost complete
                      backgroundColor: _surfaceSoft,
                      valueColor: const AlwaysStoppedAnimation<Color>(_primaryGreen),
                      borderRadius: BorderRadius.circular(4),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(width: 24), // Balance spacing
                ],
              ),
            ),

            // ---- SCROLLABLE FORM ----
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Complete your profile', style: TextStyle(color: _ink, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -1)),
                    const SizedBox(height: 8),
                    const Text('Add your details to start using AgriConnect and connect with buyers & sellers.', style: TextStyle(color: _muted, fontSize: 15, height: 1.4)),
                    const SizedBox(height: 40),

                    // Premium Avatar Picker
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 100, height: 100,
                            decoration: BoxDecoration(
                              color: _surfaceSoft,
                              shape: BoxShape.circle,
                              border: Border.all(color: _hairline, width: 2),
                            ),
                            child: const Icon(Icons.person_rounded, size: 48, color: _muted),
                          ),
                          Positioned(
                            bottom: 0, right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _primaryGreen,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: [BoxShadow(color: _primaryGreen.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))],
                              ),
                              child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Form Fields
                    _buildInputField(label: 'Full Name', hint: 'e.g. Ali Ahmed', controller: _nameController, icon: Icons.person_outline_rounded),
                    const SizedBox(height: 24),
                    
                    _buildInputField(
                      label: isFarmer ? 'Farm Name (Optional)' : 'Company Name', 
                      hint: isFarmer ? 'e.g. Green Acres' : 'e.g. Ali Traders Pvt Ltd', 
                      controller: _businessNameController, 
                      icon: Icons.storefront_outlined
                    ),
                    const SizedBox(height: 24),

                    _buildInputField(label: 'City / Region', hint: 'e.g. Lahore, Punjab', controller: _locationController, icon: Icons.location_on_outlined),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),

            // ---- BOTTOM BUTTON ----
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: _hairline, width: 1)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, -4))],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _completeSetup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                    : const Text('Finish Setup', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: -0.2)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Premium Inputs
  Widget _buildInputField({required String label, required String hint, required TextEditingController controller, required IconData icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _ink)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: _surfaceSoft,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.transparent), 
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 16, color: _ink, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: _muted, size: 22),
              hintText: hint,
              hintStyle: TextStyle(color: _muted.withOpacity(0.7), fontSize: 15, fontWeight: FontWeight.w400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }
}