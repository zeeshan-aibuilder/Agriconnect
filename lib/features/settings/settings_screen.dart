import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class SettingsScreen extends StatefulWidget {
  final String role; // 🔥 ROLE ADDED
  const SettingsScreen({super.key, required this.role});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isUrdu = false;
  bool _notifications = true;

  final Map<String, String> _eng = {
    'settings': 'Settings',
    'account': 'Account',
    'privacy': 'Privacy & Security',
    'lang': 'Language',
    'help': 'Help Center',
    'logout': 'Log Out',
    'support': 'Contact Support',
    'prefs': 'Preferences',
    'edit_prof': 'Edit Profile Details',
  };

  final Map<String, String> _urdu = {
    'settings': 'ترتیبات',
    'account': 'اکاؤنٹ',
    'privacy': 'پرائیویسی اور سیکیورٹی',
    'lang': 'زبان تبدیل کریں',
    'help': 'مدد کا مرکز',
    'logout': 'لاگ آؤٹ',
    'support': 'رابطہ کریں',
    'prefs': 'ترجیحات',
    'edit_prof': 'پروفائل میں ترمیم کریں',
  };

  String t(String key) => _isUrdu ? (_urdu[key] ?? key) : (_eng[key] ?? key);

  void _showLanguageSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Language', style: AppTextStyles.h3),
            const SizedBox(height: 16),
            ListTile(
              title: const Text(
                'English',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              trailing: !_isUrdu
                  ? const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success500,
                    )
                  : null,
              onTap: () {
                setState(() => _isUrdu = false);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                'اردو',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              trailing: _isUrdu
                  ? const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success500,
                    )
                  : null,
              onTap: () {
                setState(() => _isUrdu = true);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDriver = widget.role == 'transporter';

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        title: Text(t('settings'), style: AppTextStyles.h3),
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
          // Dynamic User Profile Card
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
                      Text(
                        isDriver ? 'Driver Profile' : 'Business Profile',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '+92 300 1234567',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          Text(
            t('account').toUpperCase(),
            style: AppTextStyles.caption.copyWith(
              letterSpacing: 1.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.gray200),
            ),
            child: Column(
              children: [
                _buildTile(
                  Icons.edit_document,
                  Colors.blue,
                  t('edit_prof'),
                  () {},
                ),
                const Divider(height: 1, color: AppColors.gray200),
                _buildTile(
                  Icons.language_rounded,
                  Colors.orange,
                  t('lang'),
                  _showLanguageSheet,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text(
            t('prefs').toUpperCase(),
            style: AppTextStyles.caption.copyWith(
              letterSpacing: 1.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.gray200),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.notifications_active_rounded,
                  color: Colors.red,
                  size: 20,
                ),
              ),
              title: Text(
                'Notifications',
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
          ),
          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout_rounded, color: AppColors.error500),
              label: Text(
                t('logout'),
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
        ],
      ),
    );
  }

  Widget _buildTile(
    IconData icon,
    Color color,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
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
