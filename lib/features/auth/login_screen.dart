import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'otp_verification_screen.dart';

// ==========================================
// ULTRA-PREMIUM DESIGN TOKENS (GREEN THEME)
// ==========================================
const Color _ink = Color(0xFF1E293B); 
const Color _muted = Color(0xFF64748B);
const Color _primaryGreen = Color(0xFF10B981); 
const Color _hairline = Color(0xFFE2E8F0);
const Color _surfaceSoft = Color(0xFFF8FAFC); 

class LoginScreen extends StatefulWidget {
  // ---- CHAIN LINK 1: Role Receive Kiya ----
  final String role;
  
  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Re-build UI when input is focused to trigger animations
    _phoneFocusNode.addListener(() {
      setState(() {});
    });
  }

  void _sendOTP() {
    final phone = _phoneController.text.trim();
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a valid 10-digit number', style: TextStyle(fontWeight: FontWeight.w600)), 
          backgroundColor: const Color(0xFFEF4444), // Premium Red
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        )
      );
      return;
    }

    setState(() => _isLoading = true);
    _phoneFocusNode.unfocus(); 

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        // ---- CHAIN LINK 2: Role aage OTP screen ko bhej diya ----
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => OtpVerificationScreen(phoneNumber: phone, role: widget.role))
        );
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Capitalize first letter of role for UI
    final displayRole = widget.role[0].toUpperCase() + widget.role.substring(1);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ---- 1. AMBIENT GLOW BACKGROUND ----
          Positioned(
            top: -150, right: -100,
            child: Container(
              width: 400, height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _primaryGreen.withOpacity(0.04),
                boxShadow: [BoxShadow(color: _primaryGreen.withOpacity(0.08), blurRadius: 100, spreadRadius: 50)],
              ),
            ),
          ),

          // ---- 2. MAIN CONTENT ----
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false, // Prevents overflow when keyboard pops up
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back Button (Left Aligned)
                        Container(
                          height: 48, width: 48,
                          decoration: BoxDecoration(
                            color: Colors.white, 
                            shape: BoxShape.circle, 
                            border: Border.all(color: _hairline),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4))],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _ink, size: 20),
                            onPressed: () => Navigator.pop(context), 
                          ),
                        ),
                        
                        const SizedBox(height: 32),

                        // ---- CENTERED HERO SECTION ----
                        Center(
                          child: Column(
                            children: [
                              // Logo / Icon
                              Container(
                                width: 88, height: 88,
                                decoration: BoxDecoration(
                                  color: _primaryGreen.withOpacity(0.1), 
                                  borderRadius: BorderRadius.circular(28), // Premium Squircle
                                  border: Border.all(color: _primaryGreen.withOpacity(0.2)),
                                ),
                                child: const Center(child: Icon(Icons.eco_rounded, size: 44, color: _primaryGreen)), 
                              ),
                              const SizedBox(height: 24),
                              
                              // Catchy Single-Line Typography
                              const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Join AgriConnect', 
                                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: _ink, letterSpacing: -1)
                                ),
                              ),
                              const SizedBox(height: 12),
                              
                              // Contextual Centered Subtitle
                              Text(
                                'Enter your phone number to\ncontinue as a $displayRole.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 15, color: _muted, height: 1.4, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 48),
                        
                        // Input Label (Left Aligned for readability)
                        const Text('Mobile Number', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _ink)),
                        const SizedBox(height: 10),
                        
                        // ---- UX: ANIMATED PREMIUM INPUT FIELD ----
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 64, 
                          decoration: BoxDecoration(
                            color: _phoneFocusNode.hasFocus ? Colors.white : _surfaceSoft,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _phoneFocusNode.hasFocus ? _primaryGreen : Colors.transparent, 
                              width: _phoneFocusNode.hasFocus ? 2 : 1
                            ),
                            boxShadow: _phoneFocusNode.hasFocus 
                                ? [BoxShadow(color: _primaryGreen.withOpacity(0.15), blurRadius: 16, offset: const Offset(0, 8))]
                                : [],
                          ),
                          child: Row(
                            children: [
                              // Country Code Block
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  border: Border(right: BorderSide(color: _phoneFocusNode.hasFocus ? _hairline : _hairline.withOpacity(0.5))),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('🇵🇰', style: TextStyle(fontSize: 22)),
                                    SizedBox(width: 8),
                                    Text('+92', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _ink)),
                                  ],
                                ),
                              ),
                              
                              // Text Field
                              Expanded(
                                child: TextField(
                                  controller: _phoneController,
                                  focusNode: _phoneFocusNode,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                                  style: const TextStyle(fontSize: 18, letterSpacing: 2, fontWeight: FontWeight.w700, color: _ink),
                                  decoration: InputDecoration(
                                    hintText: '300 1234567',
                                    hintStyle: TextStyle(color: _muted.withOpacity(0.5), letterSpacing: 2, fontWeight: FontWeight.w600, fontSize: 18),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16), 
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const Spacer(), // Pushes button to bottom
                        const SizedBox(height: 32),
                        
                        // Authentic fine-print text
                        Center(
                          child: Text(
                            'By continuing, you agree to our Terms & Privacy Policy.',
                            style: TextStyle(fontSize: 12, color: _muted.withOpacity(0.8)),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Premium Action Button
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          height: 56, 
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: _primaryGreen.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))
                            ]
                          ),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _sendOTP,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryGreen,
                              disabledBackgroundColor: _primaryGreen.withOpacity(0.7),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                            ),
                            child: _isLoading 
                              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                              : const Text('Send OTP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.5)),
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