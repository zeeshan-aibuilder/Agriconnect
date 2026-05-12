import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../dashboard/main_layout.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'widgets/auth_widgets.dart'; // Import Reusable Widgets

class LoginScreen extends StatefulWidget {
  final String? role;
  const LoginScreen({super.key, this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _phoneError;
  String? _passError;

  @override
  void initState() {
    super.initState();
    _phoneFocus.addListener(() => setState(() {}));
    _passFocus.addListener(() => setState(() {}));
    _phoneController.addListener(() {
      if (_phoneError != null) setState(() => _phoneError = null);
    });
    _passController.addListener(() {
      if (_passError != null) setState(() => _passError = null);
    });
  }

  void _validateAndLogin() async {
    final phone = _phoneController.text.trim();
    final pass = _passController.text.trim();
    bool isValid = true;

    setState(() {
      _phoneError = null;
      _passError = null;
    });

    if (!RegExp(r'^3\d{9}$').hasMatch(phone)) {
      _phoneError = "Enter a valid 10-digit number (e.g. 3001234567)";
      isValid = false;
    }
    if (pass.length < 6) {
      _passError = "Password must be at least 6 characters";
      isValid = false;
    }

    if (!isValid) {
      HapticFeedback.heavyImpact();
      return;
    }

    _phoneFocus.unfocus();
    _passFocus.unfocus();
    setState(() => _isLoading = true);

    // MOCK API CALL
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);
      HapticFeedback.heavyImpact();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainLayout(role: widget.role ?? 'supplier'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: _isLoading, // Locks entire UI when loading
      child: Scaffold(
        backgroundColor: AppColors.bgSecondary,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset('assets/images/logo.png', height: 80),
                ),
                const SizedBox(height: 40),
                const Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.gray900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Login to access your B2B dashboard.",
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.gray500,
                    fontWeight: FontWeight.w500,
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
                  label: "Password",
                  hint: "Enter your password",
                  controller: _passController,
                  focusNode: _passFocus,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.gray500,
                  ),
                  errorText: _passError,
                  onToggleVisibility: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  onSubmitted: (_) => _validateAndLogin(),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    ),
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: AppColors.primary700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                PrimaryButton(
                  text: "Continue",
                  isLoading: _isLoading,
                  onPressed: _validateAndLogin,
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "New to AgriConnect?",
                      style: TextStyle(
                        color: AppColors.gray500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      ),
                      child: const Text(
                        "Register",
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
