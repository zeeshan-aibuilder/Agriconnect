import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import 'otp_verification_screen.dart';
import 'login_screen.dart';
import 'widgets/auth_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  final FocusNode _confirmPassFocus = FocusNode();

  String? _phoneError;
  String? _passError;
  String? _confirmPassError;

  bool _isLoading = false;
  bool _obscurePass = true;
  bool _obscureConfirmPass = true;

  @override
  void initState() {
    super.initState();
    _phoneFocus.addListener(() => setState(() {}));
    _passFocus.addListener(() => setState(() {}));
    _confirmPassFocus.addListener(() => setState(() {}));

    _phoneController.addListener(() {
      if (_phoneError != null) setState(() => _phoneError = null);
    });
    _passController.addListener(() {
      if (_passError != null) setState(() => _passError = null);
    });
    _confirmPassController.addListener(() {
      if (_confirmPassError != null) setState(() => _confirmPassError = null);
    });
  }

  void _sendOtp() async {
    final phone = _phoneController.text.trim();
    final pass = _passController.text.trim();
    final confirmPass = _confirmPassController.text.trim();
    bool isValid = true;

    setState(() {
      _phoneError = null;
      _passError = null;
      _confirmPassError = null;
    });

    if (!RegExp(r'^3\d{9}$').hasMatch(phone)) {
      _phoneError = "Enter a valid 10-digit number (e.g. 3001234567)";
      isValid = false;
    }
    if (pass.length < 6) {
      _passError = "Password must be at least 6 characters";
      isValid = false;
    }
    if (pass != confirmPass) {
      _confirmPassError = "Passwords do not match";
      isValid = false;
    }

    if (!isValid) {
      HapticFeedback.heavyImpact();
      return;
    }

    _phoneFocus.unfocus();
    _passFocus.unfocus();
    _confirmPassFocus.unfocus();
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1)); // Mock API delay

    if (mounted) {
      setState(() => _isLoading = false);
      HapticFeedback.mediumImpact();

      // Navigate to OTP, passing isRegister = true
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OtpVerificationScreen(phoneNumber: '0$phone', isRegister: true),
        ),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    _phoneFocus.dispose();
    _passFocus.dispose();
    _confirmPassFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: _isLoading,
      child: Scaffold(
        backgroundColor: AppColors.bgSecondary,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset('assets/images/logo.png', height: 80),
                ),
                const SizedBox(height: 40),
                const Text(
                  "Join AgriConnect",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.gray900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Create your account to start buying and selling in bulk.",
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.gray500,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 40),

                AppTextField(
                  label: "Mobile Number",
                  hint: "300 1234567",
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Text(
                      "🇵🇰 +92",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.gray900,
                      ),
                    ),
                  ),
                  errorText: _phoneError,
                  onClear: () => _phoneController.clear(),
                ),
                const SizedBox(height: 24),

                AppTextField(
                  label: "Create Password",
                  hint: "Minimum 6 characters",
                  controller: _passController,
                  focusNode: _passFocus,
                  isPassword: true,
                  obscureText: _obscurePass,
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.gray500,
                  ),
                  errorText: _passError,
                  onToggleVisibility: () =>
                      setState(() => _obscurePass = !_obscurePass),
                ),
                const SizedBox(height: 24),

                AppTextField(
                  label: "Confirm Password",
                  hint: "Repeat your password",
                  controller: _confirmPassController,
                  focusNode: _confirmPassFocus,
                  isPassword: true,
                  obscureText: _obscureConfirmPass,
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.gray500,
                  ),
                  errorText: _confirmPassError,
                  onToggleVisibility: () => setState(
                    () => _obscureConfirmPass = !_obscureConfirmPass,
                  ),
                  onSubmitted: (_) => _sendOtp(),
                ),
                const SizedBox(height: 40),

                PrimaryButton(
                  text: "Verify Number",
                  isLoading: _isLoading,
                  onPressed: _sendOtp,
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: AppColors.gray500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: AppColors.primary700,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
