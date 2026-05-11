import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import 'presentation/providers/auth_provider.dart';
import 'profile_setup_screen.dart'; // Navigation fix

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String role;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.role,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _otpFocusNode.addListener(() => setState(() {}));
    _otpController.addListener(
      () => setState(() {
        if (_errorText != null) _errorText = null;
      }),
    );
  }

  void _verifyLogin() async {
    HapticFeedback.lightImpact();

    final otpCode = _otpController.text.trim();
    if (otpCode.length < 4) {
      setState(() => _errorText = "Please enter the complete 4-digit code");
      return;
    }

    _otpFocusNode.unfocus();

    // 🔥 --- DEVELOPMENT BYPASS --- 🔥
    // Asal API call abhi comment out ki hui hai
    /*
    final authState = ref.read(authStateProvider);
    if (authState.isLoading) return;
    
    final success = await ref
        .read(authStateProvider.notifier)
        .verifyOtp(widget.phoneNumber, otpCode, widget.role);
    */

    const success = true; // Hamesha verify pass karega
    // 🔥 --------------------------- 🔥

    if (success && mounted) {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login Bypassed Successfully!"),
          backgroundColor: AppColors.success500,
        ),
      );

      // Move to Profile Setup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileSetupScreen(role: widget.role),
        ),
      );
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.gray900,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.success500.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.message_rounded,
                  color: AppColors.success500,
                  size: 32,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Verify your number",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.gray900,
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  text: "We sent a secure code to ",
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.gray500,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: widget.phoneNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _errorText != null
                        ? AppColors.error500
                        : (_otpFocusNode.hasFocus
                              ? AppColors.primary700
                              : AppColors.gray200),
                    width: _otpFocusNode.hasFocus || _errorText != null ? 2 : 1,
                  ),
                  boxShadow: _otpFocusNode.hasFocus
                      ? [
                          BoxShadow(
                            color: AppColors.primary700.withValues(alpha: 0.1),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: TextField(
                    controller: _otpController,
                    focusNode: _otpFocusNode,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    style: const TextStyle(
                      fontSize: 32,
                      letterSpacing: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.gray900,
                    ),
                    onSubmitted: (_) => _verifyLogin(),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '••••',
                      hintStyle: TextStyle(
                        color: AppColors.gray300,
                        letterSpacing: 24,
                      ),
                    ),
                  ),
                ),
              ),
              if (_errorText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 4),
                  child: Text(
                    _errorText!,
                    style: const TextStyle(
                      color: AppColors.error500,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              Center(
                child: TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                  },
                  child: const Text(
                    "Didn't receive the code? Resend",
                    style: TextStyle(
                      color: AppColors.primary700,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              const SizedBox(height: 24),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success500.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed:
                      _verifyLogin, // Loading lock bypass ke liye hata diya hai
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Verify & Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
