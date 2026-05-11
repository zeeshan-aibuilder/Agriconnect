import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import 'otp_verification_screen.dart';
import 'presentation/providers/auth_provider.dart';


class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    if (text.length > 3) {
      final formatted = '${text.substring(0, 3)} ${text.substring(3)}';
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    return newValue;
  }
}

class LoginScreen extends ConsumerStatefulWidget {
  final String role;

  const LoginScreen({super.key, required this.role});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _phoneFocusNode.addListener(() => setState(() {}));
    _phoneController.addListener(
      () => setState(() {
        if (_errorText != null) _errorText = null;
      }),
    );
  }

  void _processLogin() async {
    HapticFeedback.lightImpact();

    final rawPhone = _phoneController.text.replaceAll(' ', '');

    final regex = RegExp(r'^3\d{9}$');
    if (!regex.hasMatch(rawPhone)) {
      setState(() => _errorText = "Please enter a valid 10-digit number");
      return;
    }

    _phoneFocusNode.unfocus();
    final fullNumber = '0$rawPhone';

    // 🔥 --- DEVELOPMENT BYPASS --- 🔥
    // Asal API call abhi comment out ki hui hai taake testing chalti rahay
    /*
    final authState = ref.read(authStateProvider);
    if (authState.isLoading) return; 
    
    final success = await ref
        .read(authStateProvider.notifier)
        .requestOtp(fullNumber, 'phone');
    */

    const success = true; // Hamesha pass karega testing ke liye
    // 🔥 --------------------------- 🔥

    if (success && mounted) {
      HapticFeedback.mediumImpact();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OtpVerificationScreen(phoneNumber: fullNumber, role: widget.role),
        ),
      );
    }
  }

  String _getAttractiveRoleName(String rawRole) {
    switch (rawRole.toLowerCase()) {
      case 'farmer':
      case 'producer':
      case 'supplier':
        return 'Producer / Supplier';
      case 'buyer':
        return 'B2B Buyer';
      case 'transporter':
        return 'Logistics Partner';
      default:
        return rawRole[0].toUpperCase() + rawRole.substring(1);
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayRole = _getAttractiveRoleName(widget.role);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned(
            top: -150,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary700.withValues(alpha: 0.04),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary700.withValues(alpha: 0.06),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      24,
                      16,
                      24,
                      MediaQuery.of(context).viewInsets.bottom + 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.gray200),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: AppColors.gray900,
                                  size: 20,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.gray100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "اردو / EN",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.gray900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  color: AppColors.primary700.withValues(
                                    alpha: 0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: AppColors.primary700.withValues(
                                      alpha: 0.2,
                                    ),
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.hub_outlined,
                                    size: 44,
                                    color: AppColors.primary700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Join AgriConnect',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.gray900,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Securely login to manage your\noperations as a $displayRole.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: AppColors.gray500,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 48),
                        const Text(
                          'Mobile Number',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.gray900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 64,
                          decoration: BoxDecoration(
                            color: _phoneFocusNode.hasFocus
                                ? AppColors.white
                                : AppColors.bgSecondary,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _errorText != null
                                  ? AppColors.error500
                                  : (_phoneFocusNode.hasFocus
                                        ? AppColors.primary700
                                        : AppColors.gray200),
                              width:
                                  _phoneFocusNode.hasFocus || _errorText != null
                                  ? 2
                                  : 1,
                            ),
                            boxShadow: _phoneFocusNode.hasFocus
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
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: _phoneFocusNode.hasFocus
                                          ? AppColors.gray200
                                          : AppColors.gray200.withValues(
                                              alpha: 0.5,
                                            ),
                                    ),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Text(
                                      '🇵🇰',
                                      style: TextStyle(fontSize: 22),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '+92',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.gray900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _phoneController,
                                  focusNode: _phoneFocusNode,
                                  autofocus: true,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                    PhoneInputFormatter(),
                                  ],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.gray900,
                                  ),
                                  onSubmitted: (_) => _processLogin(),
                                  decoration: InputDecoration(
                                    hintText: '300 1234567',
                                    hintStyle: TextStyle(
                                      color: AppColors.gray500.withValues(
                                        alpha: 0.5,
                                      ),
                                      letterSpacing: 1.5,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    suffixIcon: _phoneController.text.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(
                                              Icons.cancel,
                                              color: AppColors.gray500,
                                              size: 20,
                                            ),
                                            onPressed: () =>
                                                _phoneController.clear(),
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_errorText != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 4),
                            child: Text(
                              _errorText!,
                              style: const TextStyle(
                                color: AppColors.error500,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
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
                                color: AppColors.success500.withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed:
                                _processLogin, // Bypass mein loading lock hata diya hai
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success500,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                                letterSpacing: 0.5,
                              ),
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
