import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../../core/theme/app_colors.dart';
import 'role_selection_screen.dart';
import 'create_password_screen.dart'; // 🔥 Yahan Import Add Kiya Hai!
import 'widgets/auth_widgets.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final bool isRegister;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    this.isRegister = false,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocus = FocusNode();

  bool _isLoading = false;
  String? _errorText;
  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _otpController.addListener(() {
      if (_errorText != null) setState(() => _errorText = null);
      if (_otpController.text.length == 4) _verifyOtp();
      setState(() {});
    });
    Future.delayed(
      const Duration(milliseconds: 500),
      () => _otpFocus.requestFocus(),
    );
  }

  void _startTimer() {
    _secondsRemaining = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  void _verifyOtp() async {
    if (_otpController.text.length < 4) {
      setState(() => _errorText = "Enter complete 4-digit code");
      HapticFeedback.heavyImpact();
      return;
    }

    _otpFocus.unfocus();
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1)); // Mock API

    if (mounted) {
      setState(() => _isLoading = false);
      HapticFeedback.heavyImpact();

      // 🔥 LOGIC FIX: Ab yeh flow 100% complete hai!
      if (widget.isRegister) {
        // Registration Flow -> Role Select karega
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
        );
      } else {
        // Forgot Password Flow -> Naya Password Banayega
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CreatePasswordScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _otpFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: _isLoading,
      child: Scaffold(
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

                Stack(
                  children: [
                    Opacity(
                      opacity: 0.0,
                      child: TextField(
                        controller: _otpController,
                        focusNode: _otpFocus,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(4, (index) {
                        String char = _otpController.text.length > index
                            ? _otpController.text[index]
                            : "";
                        bool isFocused =
                            _otpFocus.hasFocus &&
                            _otpController.text.length == index;
                        bool hasError = _errorText != null;

                        return GestureDetector(
                          onTap: () => _otpFocus.requestFocus(),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 64,
                            height: 72,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: hasError
                                    ? AppColors.error500
                                    : (isFocused
                                          ? AppColors.primary700
                                          : AppColors.gray200),
                                width: isFocused || hasError ? 2 : 1,
                              ),
                              boxShadow: isFocused && !hasError
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary700.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 16,
                                        offset: const Offset(0, 8),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Center(
                              child: Text(
                                char,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.gray900,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
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
                  child: _secondsRemaining > 0
                      ? Text(
                          "Resend code in 00:${_secondsRemaining.toString().padLeft(2, '0')}",
                          style: const TextStyle(
                            color: AppColors.gray500,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        )
                      : TextButton(
                          onPressed: _startTimer,
                          child: const Text(
                            "Resend Code",
                            style: TextStyle(
                              color: AppColors.primary700,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                ),
                const Spacer(),
                PrimaryButton(
                  text: "Verify & Continue",
                  isLoading: _isLoading,
                  onPressed: _verifyOtp,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
