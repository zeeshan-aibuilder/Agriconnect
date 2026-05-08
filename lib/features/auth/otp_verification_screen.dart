import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async'; 
import 'profile_setup_screen.dart'; 

// ==========================================
// ULTRA-PREMIUM DESIGN TOKENS (GREEN THEME)
// ==========================================
const Color _ink = Color(0xFF1E293B); 
const Color _muted = Color(0xFF64748B);
const Color _primaryGreen = Color(0xFF10B981); 
const Color _hairline = Color(0xFFE2E8F0);
const Color _surfaceSoft = Color(0xFFF8FAFC); 

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String role;
  
  const OtpVerificationScreen({super.key, required this.phoneNumber, required this.role});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  
  bool _isVerifying = false;
  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Add listener to rebuild the 4 boxes when typing
    _otpController.addListener(() {
      setState(() {});
      if (_otpController.text.length == 4) { 
        _verifyOTP();
      }
    });
    // Auto focus with a slight delay for smooth entry
    Future.delayed(const Duration(milliseconds: 300), () => _otpFocusNode.requestFocus());
  }

  void _startTimer() {
    setState(() => _secondsRemaining = 30);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  void _resendOTP() {
    _startTimer();
    _otpController.clear();
    _otpFocusNode.requestFocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('New 4-digit code sent! 📲', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: _ink,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      )
    );
  }

  void _verifyOTP() {
    if (_otpController.text.length < 4) return; 
    
    setState(() => _isVerifying = true);
    _otpFocusNode.unfocus();
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isVerifying = false);
        Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (context) => ProfileSetupScreen(role: widget.role)), 
          (route) => false 
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String currentOtp = _otpController.text;
    bool isAllFilled = currentOtp.length == 4; 

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ---- 1. AMBIENT GLOW BACKGROUND ----
          Positioned(
            top: -150, left: -100, 
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
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back Button
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
                              // Icon
                              Container(
                                width: 88, height: 88,
                                decoration: BoxDecoration(
                                  color: _primaryGreen.withOpacity(0.1), 
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(color: _primaryGreen.withOpacity(0.2)),
                                ),
                                child: const Center(child: Icon(Icons.mark_email_read_rounded, size: 40, color: _primaryGreen)),
                              ),
                              const SizedBox(height: 24),
                              
                              // Typography
                              const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Verification Code', 
                                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: _ink, letterSpacing: -1)
                                ),
                              ),
                              const SizedBox(height: 12),
                              
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: const TextStyle(fontSize: 15, color: _muted, height: 1.5, fontWeight: FontWeight.w500, fontFamily: 'Roboto'),
                                  children: [
                                    const TextSpan(text: 'Enter the 4-digit code sent to\n'),
                                    TextSpan(text: '+92 ${widget.phoneNumber}', style: const TextStyle(fontWeight: FontWeight.w800, color: _ink)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 48),
                        
                        // ---- UX: PIXEL-PERFECT EQUAL 4-BOX OTP FIELD ----
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 320), 
                            child: SizedBox(
                              width: double.infinity, 
                              height: 72, 
                              child: Stack(
                                fit: StackFit.expand, 
                                children: [
                                  // Visual Boxes (Behind)
                                  Row(
                                    // 7 items: 4 boxes + 3 gaps (SizedBox)
                                    children: List.generate(7, (index) {
                                      // If odd, it's a gap
                                      if (index.isOdd) {
                                        return const SizedBox(width: 16); // Fixed exact spacing
                                      }
                                      
                                      // If even, it's a box
                                      int boxIndex = index ~/ 2;
                                      bool isFocused = _otpFocusNode.hasFocus && currentOtp.length == boxIndex;
                                      bool isFilled = boxIndex < currentOtp.length;
                                      
                                      return Expanded(
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          curve: Curves.easeOutCubic,
                                          decoration: BoxDecoration(
                                            color: isFocused ? Colors.white : _surfaceSoft,
                                            borderRadius: BorderRadius.circular(16), 
                                            border: Border.all(
                                              color: isAllFilled ? _primaryGreen : (isFocused ? _primaryGreen : _hairline),
                                              width: isFocused || isAllFilled ? 2 : 1,
                                            ),
                                            boxShadow: isFocused 
                                                ? [BoxShadow(color: _primaryGreen.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 4))]
                                                : [],
                                          ),
                                          child: Center(
                                            child: Text(
                                              isFilled ? currentOtp[boxIndex] : '',
                                              style: TextStyle(
                                                fontSize: 28, 
                                                fontWeight: FontWeight.w800, 
                                                color: isAllFilled ? _primaryGreen : _ink
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                  
                                  // Invisible Actual TextField (On Top)
                                  Positioned.fill(
                                    child: Opacity(
                                      opacity: 0.0, 
                                      child: TextField(
                                        controller: _otpController,
                                        focusNode: _otpFocusNode,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                                        autofocus: true,
                                        showCursor: false,
                                        decoration: const InputDecoration(border: InputBorder.none),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Resend Logic
                        Center(
                          child: _secondsRemaining > 0
                              ? Text(
                                  'Resend code in 00:${_secondsRemaining.toString().padLeft(2, '0')}', 
                                  style: const TextStyle(color: _muted, fontSize: 14, fontWeight: FontWeight.w600)
                                )
                              : GestureDetector(
                                  onTap: _resendOTP, 
                                  child: const Text(
                                    'Resend Code', 
                                    style: TextStyle(color: _primaryGreen, fontSize: 14, fontWeight: FontWeight.w800, decoration: TextDecoration.underline)
                                  )
                                ),
                        ),
                        
                        const Spacer(),
                        const SizedBox(height: 32),
                        
                        // Premium Action Button
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            boxShadow: [
                              if (isAllFilled && !_isVerifying)
                                BoxShadow(color: _primaryGreen.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))
                            ]
                          ),
                          child: ElevatedButton(
                            onPressed: (_isVerifying || !isAllFilled) ? null : _verifyOTP,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryGreen,
                              disabledBackgroundColor: _primaryGreen.withOpacity(0.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                            ),
                            child: _isVerifying 
                              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)) 
                              : const Text('Verify & Proceed', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
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