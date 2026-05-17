import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

// Assuming you have an AuthProvider. If not, just mock the role check for now.
// import '../../../auth/presentation/providers/auth_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  final String role; // 'transporter' or 'buyer'
  const SettingsScreen({super.key, required this.role});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notifications = true;
  bool _twoFactorAuth = false;

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: const Text(
          'Are you sure you want to logout? You will need to verify your phone number again to log in.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.gray500,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              /* Handle Logout */
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error500,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDriver = widget.role == 'transporter';

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        title: Text('Settings', style: AppTextStyles.h3),
        backgroundColor: Colors.white,
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
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          // --- PROFILE HEADER ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary700, AppColors.accent700],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary700.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: AppColors.primary700,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Verified User',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        isDriver ? 'Transporter Profile' : 'Buyer Profile',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // --- ACCOUNT SECTION ---
          _buildSectionHeader('ACCOUNT'),
          _buildCard([
            _buildTile(
              Icons.person_rounded,
              Colors.blue,
              'Edit Profile Details',
            ),
            const Divider(height: 1, color: AppColors.gray200),
            _buildTile(
              Icons.phone_iphone_rounded,
              Colors.teal,
              'Update Phone Number',
            ),
          ]),
          const SizedBox(height: 24),

          // --- ROLE SPECIFIC SETTINGS ---
          if (isDriver) ...[
            _buildSectionHeader('DRIVER SETTINGS'),
            _buildCard([
              _buildTile(
                Icons.local_shipping_rounded,
                AppColors.primary700,
                'Vehicle Management',
              ),
              const Divider(height: 1, color: AppColors.gray200),
              _buildTile(
                Icons.description_rounded,
                Colors.indigo,
                'Document Verification',
              ),
              const Divider(height: 1, color: AppColors.gray200),
              _buildTile(
                Icons.account_balance_rounded,
                Colors.green,
                'Bank & Payouts',
              ),
            ]),
            const SizedBox(height: 24),
          ] else ...[
            _buildSectionHeader('BUYER SETTINGS'),
            _buildCard([
              _buildTile(
                Icons.location_on_rounded,
                AppColors.primary700,
                'Saved Addresses',
              ),
              const Divider(height: 1, color: AppColors.gray200),
              _buildTile(
                Icons.payment_rounded,
                Colors.indigo,
                'Payment Methods',
              ),
            ]),
            const SizedBox(height: 24),
          ],

          // --- PREFERENCES & SECURITY ---
          _buildSectionHeader('SECURITY & PREFERENCES'),
          _buildCard([
            ListTile(
              leading: _iconBox(Icons.notifications_active_rounded, Colors.red),
              title: Text(
                'Push Notifications',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: CupertinoSwitch(
                value: _notifications,
                activeTrackColor: AppColors.primary700,
                onChanged: (val) => setState(() => _notifications = val),
              ),
            ),
            const Divider(height: 1, color: AppColors.gray200),
            ListTile(
              leading: _iconBox(Icons.security_rounded, Colors.orange),
              title: Text(
                'Two-Factor Auth (2FA)',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: CupertinoSwitch(
                value: _twoFactorAuth,
                activeTrackColor: AppColors.primary700,
                onChanged: (val) => setState(() => _twoFactorAuth = val),
              ),
            ),
            const Divider(height: 1, color: AppColors.gray200),
            _buildTile(
              Icons.password_rounded,
              Colors.blueGrey,
              'Change Password',
            ),
          ]),
          const SizedBox(height: 24),

          // --- DATA CONTROL (Danger Zone) ---
          _buildSectionHeader('DATA CONTROL'),
          _buildCard([
            _buildTile(
              Icons.download_rounded,
              Colors.purple,
              'Request Account Data',
            ),
            const Divider(height: 1, color: AppColors.gray200),
            ListTile(
              leading: _iconBox(
                Icons.delete_forever_rounded,
                AppColors.error500,
              ),
              title: Text(
                'Delete Account',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.error500,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.error500,
              ),
              onTap: () {},
            ),
          ]),
          const SizedBox(height: 40),

          // --- LOGOUT BUTTON ---
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              onPressed: _showLogoutDialog,
              icon: const Icon(Icons.logout_rounded, color: AppColors.error500),
              label: Text(
                'Log Out',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.error500,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error500),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: AppTextStyles.caption.copyWith(
          letterSpacing: 1.5,
          fontWeight: FontWeight.w800,
          color: AppColors.gray500,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(children: children),
    );
  }

  Widget _iconBox(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildTile(
    IconData icon,
    Color color,
    String title, [
    VoidCallback? onTap,
  ]) {
    return ListTile(
      onTap: onTap,
      leading: _iconBox(icon, color),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: AppColors.gray400,
      ),
    );
  }
}
