import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; 
import 'package:flutter/services.dart'; // THE FIX: Added Services for Clipboard
import 'package:share_plus/share_plus.dart'; 

// ---- SCREENS IMPORTS ----
import 'blocked_contacts_screen.dart'; 
import 'faq_screen.dart'; 
import '../auth/role_selection_screen.dart'; 

// ==========================================
// ULTRA-PREMIUM DESIGN TOKENS (INDEPENDENT)
// ==========================================
const Color _primaryGreen = Color(0xFF10B981); 
const Color _darkSurface = Color(0xFF0F172A); 
const Color _darkCard = Color(0xFF1E293B);
const Color _lightSurface = Color(0xFFF8FAFC);
const Color _lightCard = Colors.white;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ---- GLOBAL STATE ----
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _currentLanguage = 'English';
  String _userName = 'Chaudhry Farm House';
  String _userBio = 'Premium Organic Wheat Supplier';

  bool _showOnlineStatus = true;
  bool _readReceipts = true;
  bool _enterIsSend = true;
  bool _mediaAutoDownload = false;

  // ---- TRANSLATION ENGINE ----
  final Map<String, Map<String, String>> _translations = {
    'English': {
      'settings': 'Settings', 'account': 'Account', 'preferences': 'Preferences', 'support': 'Support',
      'privacy': 'Account & Privacy', 'chats': 'Chats', 'notif': 'Notifications', 'dark': 'Dark Mode',
      'lang': 'App Language', 'help': 'Help Center', 'invite': 'Invite a Friend', 'logout': 'Log Out',
      'edit_profile': 'Edit Profile', 'farm_name': 'Farm / Business Name', 'short_bio': 'Short Bio',
      'save': 'Save Changes', 'sec_desc': 'Security, blocked contacts', 'chat_desc': 'Theme, wallpapers, chat backup',
      'notif_desc': 'Message, group & call tones', 'dark_desc': 'App appearance', 'help_desc': 'Contact us, FAQs',
      'invite_desc': 'Share referral code', 'show_online': 'Show Online Status', 'read_receipts': 'Read Receipts',
      'blocked': 'Blocked Contacts', 'enter_send': 'Enter is Send', 'media_auto': 'Media Auto-Download',
      'backup': 'Backup Chats Now', 'how_help': 'How can we help you?', 'email_support': 'Email Support',
      'read_faqs': 'Read FAQs', 'invite_farmers': 'Invite Farmers', 'share_link': 'Share Link',
      'sure_logout': 'Are you sure you want to log out?', 'cancel': 'Cancel'
    },
    'اردو (Urdu)': {
      'settings': 'ترتیبات', 'account': 'اکاؤنٹ', 'preferences': 'ترجیحات', 'support': 'مدد',
      'privacy': 'اکاؤنٹ اور پرائیویسی', 'chats': 'چیٹس', 'notif': 'نوٹیفیکیشنز', 'dark': 'ڈارک موڈ',
      'lang': 'زبان', 'help': 'ہیلپ سینٹر', 'invite': 'دوست کو مدعو کریں', 'logout': 'لاگ آؤٹ',
      'edit_profile': 'پروفائل میں ترمیم کریں', 'farm_name': 'فارم / کاروبار کا نام', 'short_bio': 'مختصر تعارف',
      'save': 'تبدیلیاں محفوظ کریں', 'sec_desc': 'سیکیورٹی، بلاک شدہ رابطے', 'chat_desc': 'تھیم، وال پیپرز، بیک اپ',
      'notif_desc': 'پیغام اور کال ٹونز', 'dark_desc': 'ایپ کی ظاہری شکل', 'help_desc': 'ہم سے رابطہ کریں، سوالات',
      'invite_desc': 'ریفرل کوڈ شیئر کریں', 'show_online': 'آن لائن سٹیٹس دکھائیں', 'read_receipts': 'ریڈ رسیدیں',
      'blocked': 'بلاک شدہ رابطے', 'enter_send': 'اینٹر سے میسج بھیجیں', 'media_auto': 'میڈیا آٹو ڈاؤن لوڈ',
      'backup': 'ابھی بیک اپ لیں', 'how_help': 'ہم آپ کی کیا مدد کر سکتے ہیں؟', 'email_support': 'ای میل سپورٹ',
      'read_faqs': 'عمومی سوالات پڑھیں', 'invite_farmers': 'کسانوں کو مدعو کریں', 'share_link': 'لنک شیئر کریں',
      'sure_logout': 'کیا آپ واقعی لاگ آؤٹ کرنا چاہتے ہیں؟', 'cancel': 'منسوخ کریں'
    }
  };

  String getText(String key) {
    return _translations[_currentLanguage]?[key] ?? _translations['English']![key]!;
  }

  Color get _bgColor => _darkModeEnabled ? _darkSurface : _lightSurface;
  Color get _cardColor => _darkModeEnabled ? _darkCard : _lightCard;
  Color get _textColor => _darkModeEnabled ? Colors.white : const Color(0xFF1E293B);
  Color get _mutedColor => _darkModeEnabled ? Colors.white54 : const Color(0xFF64748B);
  Color get _borderColor => _darkModeEnabled ? Colors.white.withOpacity(0.05) : const Color(0xFFE2E8F0);

  // ---- 1. EDIT PROFILE ----
  void _showEditProfileSheet() {
    final nameController = TextEditingController(text: _userName);
    final bioController = TextEditingController(text: _userBio);

    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: _cardColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(32))),
          child: SingleChildScrollView( 
            child: Column(
              mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 48, height: 5, decoration: BoxDecoration(color: _borderColor, borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 24),
                Text(getText('edit_profile'), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: _textColor, letterSpacing: -0.5)),
                const SizedBox(height: 24),
                
                TextField(
                  controller: nameController, style: TextStyle(color: _textColor, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    labelText: getText('farm_name'), labelStyle: TextStyle(color: _mutedColor, fontWeight: FontWeight.w500), 
                    filled: true, fillColor: _darkModeEnabled ? _darkSurface : _lightSurface, 
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: _primaryGreen, width: 2)),
                  ),
                ),
                const SizedBox(height: 16),
                
                TextField(
                  controller: bioController, maxLines: 3, style: TextStyle(color: _textColor, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    labelText: getText('short_bio'), labelStyle: TextStyle(color: _mutedColor, fontWeight: FontWeight.w500), 
                    filled: true, fillColor: _darkModeEnabled ? _darkSurface : _lightSurface, 
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: _primaryGreen, width: 2)),
                  ),
                ),
                const SizedBox(height: 32),
                
                SizedBox(
                  width: double.infinity, height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() { _userName = nameController.text; _userBio = bioController.text; });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: _primaryGreen, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    child: Text(getText('save'), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---- 2. LANGUAGE SELECTOR ----
  void _showLanguageSheet() {
    final languages = ['English', 'اردو (Urdu)']; 
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: _cardColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(32))),
        child: Column(
          mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 48, height: 5, decoration: BoxDecoration(color: _borderColor, borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 24),
            Text(getText('lang'), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: _textColor, letterSpacing: -0.5)),
            const SizedBox(height: 16),
            ...languages.map((lang) => _buildSelectionTile(
              title: lang, 
              isSelected: _currentLanguage == lang, 
              onTap: () {
                setState(() => _currentLanguage = lang);
                Navigator.pop(context);
              }
            )),
          ],
        ),
      ),
    );
  }

  // ---- 3. PRIVACY & BLOCKED CONTACTS ----
  void _showPrivacySheet() {
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: _cardColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(32))),
            child: Column(
              mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 48, height: 5, decoration: BoxDecoration(color: _borderColor, borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 24),
                Text(getText('privacy'), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: _textColor, letterSpacing: -0.5)),
                const SizedBox(height: 24),
                
                _buildSheetToggle(getText('show_online'), _showOnlineStatus, (val) { setModalState(() => _showOnlineStatus = val); setState(() => _showOnlineStatus = val); }),
                _buildSheetToggle(getText('read_receipts'), _readReceipts, (val) { setModalState(() => _readReceipts = val); setState(() => _readReceipts = val); }),
                
                Divider(height: 32, color: _borderColor),
                
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.block_rounded, color: Colors.red)),
                  title: Text(getText('blocked'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _textColor)),
                  trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: _mutedColor),
                  onTap: () {
                    final nav = Navigator.of(context);
                    nav.pop(); 
                    nav.push(MaterialPageRoute(builder: (context) => const BlockedContactsScreen()));
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }
      ),
    );
  }

  // ---- 4. CHAT SETTINGS ----
  void _showChatSettingsSheet() {
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: _cardColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(32))),
            child: Column(
              mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 48, height: 5, decoration: BoxDecoration(color: _borderColor, borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 24),
                Text(getText('chats'), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: _textColor, letterSpacing: -0.5)),
                const SizedBox(height: 24),
                
                _buildSheetToggle(getText('enter_send'), _enterIsSend, (val) { setModalState(() => _enterIsSend = val); setState(() => _enterIsSend = val); }),
                _buildSheetToggle(getText('media_auto'), _mediaAutoDownload, (val) { setModalState(() => _mediaAutoDownload = val); setState(() => _mediaAutoDownload = val); }),
                
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity, height: 56,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.cloud_upload_rounded, color: _primaryGreen),
                    label: Text(getText('backup'), style: const TextStyle(color: _primaryGreen, fontSize: 16, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), side: const BorderSide(color: _primaryGreen, width: 2)),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup started successfully! ☁️')));
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }
      ),
    );
  }

  // ---- 5. HELP CENTER ----
  void _showHelpCenterSheet() {
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: _cardColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(32))),
        child: Column(
          mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(width: 48, height: 5, decoration: BoxDecoration(color: _borderColor, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 32),
            Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: _primaryGreen.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.support_agent_rounded, size: 48, color: _primaryGreen)),
            const SizedBox(height: 24),
            Text(getText('how_help'), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _textColor, letterSpacing: -0.5)),
            const SizedBox(height: 32),
            
            _buildActionCard(Icons.mail_rounded, const Color(0xFF3B82F6), getText('email_support'), 'support@agriconnect.pk', () => Navigator.pop(context)),
            const SizedBox(height: 12),
            _buildActionCard(Icons.article_rounded, const Color(0xFFF59E0B), getText('read_faqs'), 'Find answers quickly', () {
              final nav = Navigator.of(context);
              nav.pop();
              nav.push(MaterialPageRoute(builder: (context) => const FAQScreen()));
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ---- 6. INVITE A FRIEND ----
  void _showInviteSheet() {
    String inviteLink = "agriconnect.pk/join/CHAUDHRY_99";
    
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: _cardColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(32))),
        child: Column(
          mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(width: 48, height: 5, decoration: BoxDecoration(color: _borderColor, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 32),
            Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFF8B5CF6).withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.card_giftcard_rounded, size: 48, color: Color(0xFF8B5CF6))),
            const SizedBox(height: 24),
            Text(getText('invite_farmers'), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _textColor, letterSpacing: -0.5)),
            const SizedBox(height: 12),
            Text('Share your code. When they join, both of you get verified faster!', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: _mutedColor, height: 1.5)),
            const SizedBox(height: 32),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: _darkModeEnabled ? _darkSurface : _lightSurface, borderRadius: BorderRadius.circular(16), border: Border.all(color: _borderColor)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(inviteLink, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _primaryGreen), overflow: TextOverflow.ellipsis)),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: inviteLink));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Link Copied! 📋')));
                    },
                    child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: _primaryGreen, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.copy_rounded, color: Colors.white, size: 20)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity, height: 56,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.share_rounded, color: Colors.white),
                label: Text(getText('share_link'), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                onPressed: () {
                  Share.share('Salam! AgriConnect par aayen aur seedha buyers se deal karein. Use my link: https://$inviteLink');
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ---- 7. LOGOUT DIALOG ----
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor,
        elevation: 24,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.logout_rounded, color: Colors.red)), 
          const SizedBox(width: 12), 
          Text(getText('logout'), style: TextStyle(fontWeight: FontWeight.w800, color: _textColor, fontSize: 20))
        ]),
        content: Text(getText('sure_logout'), style: TextStyle(color: _mutedColor, fontSize: 16, fontWeight: FontWeight.w500)),
        actionsPadding: const EdgeInsets.only(right: 24, bottom: 24),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(getText('cancel'), style: TextStyle(color: _mutedColor, fontWeight: FontWeight.w700, fontSize: 16))),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () { 
              final nav = Navigator.of(context);
              nav.pop(); 
              nav.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const RoleSelectionScreen()), (Route<dynamic> route) => false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: Text(getText('logout'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ---- PREMIUM HEADER ----
          SliverAppBar(
            backgroundColor: _bgColor,
            elevation: 0,
            pinned: true,
            centerTitle: false,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              title: Text(getText('settings'), style: TextStyle(color: _textColor, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -1)),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---- HERO PROFILE CARD ----
                  GestureDetector(
                    onTap: _showEditProfileSheet,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [_primaryGreen, Color(0xFF059669)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [BoxShadow(color: _primaryGreen.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const CircleAvatar(radius: 30, backgroundColor: _lightSurface, child: Icon(Icons.person_rounded, size: 36, color: _primaryGreen)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_userName, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.5), maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Text(_userBio, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle), child: const Icon(Icons.edit_rounded, color: Colors.white, size: 20)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ---- SECTION 1: ACCOUNT ----
                  Padding(padding: const EdgeInsets.only(left: 16, bottom: 8), child: Text(getText('account').toUpperCase(), style: TextStyle(color: _mutedColor, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.5))),
                  Container(
                    decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(24), border: Border.all(color: _borderColor)),
                    child: Column(
                      children: [
                        _buildGroupedTile(Icons.shield_rounded, const Color(0xFF3B82F6), getText('privacy'), getText('sec_desc'), _showPrivacySheet),
                        Divider(height: 1, indent: 64, color: _borderColor),
                        _buildGroupedTile(Icons.chat_bubble_rounded, const Color(0xFF10B981), getText('chats'), getText('chat_desc'), _showChatSettingsSheet),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ---- SECTION 2: PREFERENCES ----
                  Padding(padding: const EdgeInsets.only(left: 16, bottom: 8), child: Text(getText('preferences').toUpperCase(), style: TextStyle(color: _mutedColor, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.5))),
                  Container(
                    decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(24), border: Border.all(color: _borderColor)),
                    child: Column(
                      children: [
                        _buildGroupedToggle(Icons.notifications_active_rounded, const Color(0xFFEF4444), getText('notif'), _notificationsEnabled, (val) => setState(() => _notificationsEnabled = val)),
                        Divider(height: 1, indent: 64, color: _borderColor),
                        _buildGroupedToggle(Icons.dark_mode_rounded, const Color(0xFF8B5CF6), getText('dark'), _darkModeEnabled, (val) => setState(() => _darkModeEnabled = val)),
                        Divider(height: 1, indent: 64, color: _borderColor),
                        _buildGroupedTile(Icons.language_rounded, const Color(0xFFF59E0B), getText('lang'), _currentLanguage, _showLanguageSheet),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ---- SECTION 3: SUPPORT ----
                  Padding(padding: const EdgeInsets.only(left: 16, bottom: 8), child: Text(getText('support').toUpperCase(), style: TextStyle(color: _mutedColor, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.5))),
                  Container(
                    decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(24), border: Border.all(color: _borderColor)),
                    child: Column(
                      children: [
                        _buildGroupedTile(Icons.help_center_rounded, const Color(0xFF06B6D4), getText('help'), getText('help_desc'), _showHelpCenterSheet),
                        Divider(height: 1, indent: 64, color: _borderColor),
                        _buildGroupedTile(Icons.favorite_rounded, const Color(0xFFEC4899), getText('invite'), getText('invite_desc'), _showInviteSheet),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ---- LOGOUT BUTTON ----
                  GestureDetector(
                    onTap: _showLogoutDialog,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: _borderColor)),
                      child: Text(getText('logout'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w800, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // HELPER WIDGETS
  // ==========================================
  
  // Custom Tile for Grouped Lists
  Widget _buildGroupedTile(IconData icon, Color iconColor, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: iconColor, borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: Colors.white, size: 20)),
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _textColor)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: _mutedColor)) : null,
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: _mutedColor),
      onTap: onTap,
    );
  }

  // Custom Toggle for Grouped Lists
  Widget _buildGroupedToggle(IconData icon, Color iconColor, String title, bool value, Function(bool) onChanged) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: iconColor, borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: Colors.white, size: 20)),
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _textColor)),
      trailing: CupertinoSwitch(value: value, activeColor: _primaryGreen, onChanged: onChanged),
    );
  }

  // Simple Toggle for Bottom Sheets
  Widget _buildSheetToggle(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _textColor)),
          CupertinoSwitch(value: value, activeColor: _primaryGreen, onChanged: onChanged),
        ],
      ),
    );
  }

  // Selection Tile for Language
  Widget _buildSelectionTile({required String title, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(color: isSelected ? _primaryGreen.withOpacity(0.1) : Colors.transparent, borderRadius: BorderRadius.circular(16), border: Border.all(color: isSelected ? _primaryGreen.withOpacity(0.5) : _borderColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600, color: isSelected ? _primaryGreen : _textColor)),
            if (isSelected) const Icon(Icons.check_circle_rounded, color: _primaryGreen, size: 22),
          ],
        ),
      ),
    );
  }

  // Action Card for Help Center
  Widget _buildActionCard(IconData icon, Color color, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: _darkModeEnabled ? _darkSurface : _lightSurface, borderRadius: BorderRadius.circular(16), border: Border.all(color: _borderColor)),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 24)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _textColor)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 13, color: _mutedColor, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: _mutedColor),
          ],
        ),
      ),
    );
  }
}