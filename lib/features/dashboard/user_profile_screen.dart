import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class UserProfileScreen extends StatefulWidget {
  final String userName;
  final String role;
  const UserProfileScreen({
    super.key,
    required this.userName,
    required this.role,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // Transporter specific data
  String _truckName = "Mazda 22 Wheeler";
  String _plateNumber = "LHR-9082";
  String _capacity = "50 Tons";

  // 🔥 EDIT PROFILE LOGIC FOR TRANSPORTER
  void _showEditProfileModal() {
    TextEditingController nameCtrl = TextEditingController(text: _truckName);
    TextEditingController plateCtrl = TextEditingController(text: _plateNumber);
    TextEditingController capCtrl = TextEditingController(text: _capacity);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.role == 'transporter'
                    ? 'Edit Fleet Details'
                    : 'Edit Profile',
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: 24),
              if (widget.role == 'transporter') ...[
                _buildEditField("Vehicle Type / Name", nameCtrl),
                const SizedBox(height: 16),
                _buildEditField("Plate Number", plateCtrl),
                const SizedBox(height: 16),
                _buildEditField("Loading Capacity", capCtrl),
              ] else ...[
                _buildEditField(
                  "Business Name",
                  TextEditingController(text: widget.userName),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      if (widget.role == 'transporter') {
                        _truckName = nameCtrl.text;
                        _plateNumber = plateCtrl.text;
                        _capacity = capCtrl.text;
                      }
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile Updated Successfully!'),
                        backgroundColor: AppColors.success500,
                      ),
                    );
                  },
                  child: const Text(
                    'Save Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEditField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.gray50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isTransporter = widget.role == 'transporter';

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text('Profile'),
        actions: [
          // 🔥 NEW EDIT BUTTON
          TextButton.icon(
            onPressed: _showEditProfileModal,
            icon: const Icon(
              Icons.edit_rounded,
              size: 18,
              color: AppColors.primary700,
            ),
            label: const Text(
              'Edit',
              style: TextStyle(
                color: AppColors.primary700,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // --- HEADER ---
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary700.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary700.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.userName[0].toUpperCase(),
                        style: AppTextStyles.h1.copyWith(
                          color: AppColors.primary700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.userName, style: AppTextStyles.h3),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified_rounded,
                        color: AppColors.info500,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isTransporter
                        ? 'Verified Logistics Partner'
                        : 'Verified B2B Member',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 🔥 TRUCK DETAILS (ONLY FOR TRANSPORTERS)
            if (isTransporter) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.gray900,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_shipping_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _truckName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Plate: $_plateNumber • Cap: $_capacity',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // --- TRUST STATS ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.gray200),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gray900.withValues(alpha: 0.03),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat(
                    isTransporter ? '4.9' : '4.8',
                    'Rating',
                    isStar: true,
                  ),
                  Container(width: 1, height: 40, color: AppColors.gray200),
                  _buildStat(
                    isTransporter ? '3' : '150+',
                    isTransporter ? 'Fleet Size' : 'Deals',
                  ),
                  Container(width: 1, height: 40, color: AppColors.gray200),
                  _buildStat(
                    isTransporter ? '100%' : '2024',
                    isTransporter ? 'Safe Drop' : 'Member Since',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- VERIFICATION DOCUMENTS ---
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'BUSINESS CREDIBILITY',
                style: AppTextStyles.caption.copyWith(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.gray200),
              ),
              child: Column(
                children: [
                  _buildDocRow('CNIC Verification', true),
                  const Divider(height: 1, color: AppColors.gray200),
                  _buildDocRow('NTN / Business Registration', true),
                  if (isTransporter) ...[
                    const Divider(height: 1, color: AppColors.gray200),
                    _buildDocRow('Fleet Insurance', true),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String val, String label, {bool isStar = false}) {
    return Column(
      children: [
        Row(
          children: [
            if (isStar)
              const Icon(
                Icons.star_rounded,
                color: AppColors.warning500,
                size: 18,
              ),
            if (isStar) const SizedBox(width: 4),
            Text(val, style: AppTextStyles.h3),
          ],
        ),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _buildDocRow(String title, bool isVerified) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.gray100,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.description_outlined,
          color: AppColors.gray700,
          size: 18,
        ),
      ),
      title: Text(title, style: AppTextStyles.bodyMedium),
      trailing: isVerified
          ? const Icon(Icons.check_circle_rounded, color: AppColors.success500)
          : const Icon(
              Icons.pending_actions_rounded,
              color: AppColors.warning500,
            ),
    );
  }
}
