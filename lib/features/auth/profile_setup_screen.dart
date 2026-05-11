import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../dashboard/main_layout.dart'; // Navigation Fixed: Yeh lazmi import karna tha

class ProfileSetupScreen extends StatefulWidget {
  final String role; // supplier, buyer, transporter

  const ProfileSetupScreen({super.key, required this.role});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  // Common Fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController(); // Password Field Added

  // 🚚 Transporter Specific Fields
  final TextEditingController _vehicleTypeController = TextEditingController();
  final TextEditingController _loadCapacityController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  String _getRoleTitle() {
    switch (widget.role.toLowerCase()) {
      case 'supplier':
      case 'producer':
        return 'Supplier Profile';
      case 'buyer':
        return 'B2B Buyer Profile';
      case 'transporter':
        return 'Logistics Profile';
      default:
        return 'Setup Profile';
    }
  }

  void _saveProfile() async {
    // Password verification added
    if (_nameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Name and Password are required!"),
          backgroundColor: AppColors.error500,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    HapticFeedback.lightImpact();

    // Fake API Delay
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isLoading = false);
      HapticFeedback.heavyImpact();

      // Navigation Unlocked! Direct to MainLayout
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainLayout(role: widget.role)),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _businessNameController.dispose();
    _passwordController.dispose();
    _vehicleTypeController.dispose();
    _loadCapacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String currentRole = widget.role.toLowerCase();
    final bool isTransporter = currentRole == 'transporter';

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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                _getRoleTitle(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.gray900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Complete your business details to start connecting on AgriConnect.",
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.gray500,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 40),

              _buildInputField(
                "Full Name (Contact Person)",
                "Enter your legal name",
                _nameController,
                Icons.person_outline,
              ),
              const SizedBox(height: 24),

              _buildInputField(
                isTransporter
                    ? "Logistics Company Name"
                    : "Business / Farm Name (Optional)",
                isTransporter
                    ? "E.g. ZI Group Logistics"
                    : "E.g. Green Valley Suppliers",
                _businessNameController,
                Icons.business_outlined,
              ),
              const SizedBox(height: 24),

              // 🚚 Transporter Dynamic UI
              if (isTransporter) ...[
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildInputField(
                        "Vehicle Fleet",
                        "E.g. Mazda, 22-Wheeler",
                        _vehicleTypeController,
                        Icons.local_shipping_outlined,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: _buildInputField(
                        "Max Load",
                        "Tons",
                        _loadCapacityController,
                        Icons.monitor_weight_outlined,
                        isNumber: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],

              // Password Field Added here
              _buildPasswordField(),
              const SizedBox(height: 32),

              // Premium Save Button
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary700.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary700,
                    disabledBackgroundColor: AppColors.primary700.withValues(
                      alpha: 0.7,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Complete Profile',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // 🛠️ Helper Widget for Premium Input Fields
  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController controller,
    IconData icon, {
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.gray900,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gray200),
          ),
          child: TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.gray900,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.gray400,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: Icon(icon, color: AppColors.gray500),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 🛠️ Helper Widget for Password
  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Set Secure Password",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.gray900,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gray200),
          ),
          child: TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.gray900,
            ),
            decoration: InputDecoration(
              hintText: "Enter at least 6 characters",
              hintStyle: TextStyle(
                color: AppColors.gray400,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: AppColors.gray500,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.gray400,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
