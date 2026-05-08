import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; 
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import 'chat_detail_screen.dart';
import 'settings_screen.dart';

// ==========================================
// ULTRA-PREMIUM DESIGN TOKENS (GREEN THEME)
// ==========================================
const Color _ink = Color(0xFF1E293B); 
const Color _muted = Color(0xFF64748B);
const Color _primaryGreen = Color(0xFF10B981); 
const Color _hairline = Color(0xFFE2E8F0);
const Color _surfaceSoft = Color(0xFFF1F5F9); 

class MessagesScreen extends StatefulWidget {
  final String role;
  const MessagesScreen({super.key, required this.role});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // ---- DUMMY DATA STATE ----
  late List<Map<String, dynamic>> _allChats;
  List<Map<String, dynamic>> _filteredChats = [];
  String _activeFilter = 'All Messages'; 
  
  final List<String> _filters = ['All Messages', 'Unread', 'Archived'];

  @override
  void initState() {
    super.initState();
    final isFarmer = widget.role == 'farmer';
    
    _allChats = [
      {
        'id': '1',
        'name': isFarmer ? 'Ali Traders (Faisalabad)' : 'Chaudhry Farm House',
        'lastMessage': 'Price final hai ya negotiate ho sakti hai?',
        'time': '10:42 AM',
        'unreadCount': 2,
        'isOnline': true,
        'phone': '03001234567',
        'status': 'all'
      },
      {
        'id': '2',
        'name': isFarmer ? 'National Foods Ltd.' : 'Kisan Ittehad',
        'lastMessage': 'Transportation ka kya scene hoga?',
        'time': 'Yesterday',
        'unreadCount': 0,
        'isOnline': false,
        'phone': '03217654321',
        'status': 'archived' 
      },
      {
        'id': '3',
        'name': 'Usman Logistics',
        'lastMessage': 'Truck kal subah tak pohanch jayega.',
        'time': 'Monday',
        'unreadCount': 5,
        'isOnline': true,
        'phone': '03129876543',
        'status': 'all'
      },
      {
        'id': '4',
        'name': isFarmer ? 'Engro Fertilizers' : 'Malik Agri',
        'lastMessage': 'Ok, deal done. Main payment bhej raha hoon.',
        'time': '24 Apr',
        'unreadCount': 0,
        'isOnline': false,
        'phone': '03334567890',
        'status': 'all'
      },
    ];

    _filteredChats = List.from(_allChats);
  }

  // ---- 1. SEARCH & FILTER LOGIC ----
  void _runFilter() {
    String query = _searchController.text.toLowerCase();
    List<Map<String, dynamic>> results = [];
    
    if (_activeFilter == 'All Messages') {
      results = _allChats.where((chat) => chat['status'] != 'archived').toList();
    } else if (_activeFilter == 'Unread') {
      results = _allChats.where((chat) => chat['unreadCount'] > 0 && chat['status'] != 'archived').toList();
    } else if (_activeFilter == 'Archived') {
      results = _allChats.where((chat) => chat['status'] == 'archived').toList();
    }

    if (query.isNotEmpty) {
      results = results.where((chat) => 
        chat['name'].toString().toLowerCase().contains(query) ||
        chat['lastMessage'].toString().toLowerCase().contains(query)
      ).toList();
    }

    setState(() {
      _filteredChats = results;
    });
  }

  // ---- 2. DELETE CHAT ----
  void _deleteChat(String id) {
    setState(() {
      _allChats.removeWhere((chat) => chat['id'] == id);
      _runFilter(); 
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Chat deleted', style: TextStyle(fontWeight: FontWeight.w600)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _ink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(label: 'Undo', textColor: _primaryGreen, onPressed: () {}),
      ),
    );
  }

  // ---- 3. MORE OPTIONS LOGIC ----
  void _markAllAsRead() {
    setState(() {
      for (var chat in _allChats) {
        chat['unreadCount'] = 0;
      }
      _runFilter();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All messages marked as read ✅', style: TextStyle(fontWeight: FontWeight.w600)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _ink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _archiveAllChats() {
    setState(() {
      for (var chat in _allChats) {
        chat['status'] = 'archived';
      }
      _activeFilter = 'Archived';
      _runFilter();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All chats moved to Archive 📦', style: TextStyle(fontWeight: FontWeight.w600)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _ink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ---- 4. PHONE CALL ----
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open phone dialer ⚠️')));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surfaceSoft,
      
      // ---- UX: PREMIUM FLOATING ACTION BUTTON ----
      floatingActionButton: Container(
        height: 56, width: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: _primaryGreen.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        child: FloatingActionButton(
          heroTag: null, 
          backgroundColor: _primaryGreen,
          elevation: 0,
          shape: const CircleBorder(),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Start a new chat...'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: _ink,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              )
            );
          },
          child: const Icon(Icons.chat_rounded, color: Colors.white, size: 26),
        ),
      ),

      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ---- PREMIUM APP BAR ----
          SliverAppBar(
            backgroundColor: _surfaceSoft,
            elevation: 0,
            pinned: false,
            floating: true,
            centerTitle: false,
            toolbarHeight: 70,
            title: const Text('Messages', style: TextStyle(color: _ink, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -1)),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert_rounded, color: _ink, size: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: Colors.white,
                  elevation: 10,
                  offset: const Offset(0, 50),
                  onSelected: (value) {
                    if (value == 'mark_read') {
                      _markAllAsRead();
                    } else if (value == 'archive_all') {
                      _archiveAllChats();
                    } else if (value == 'settings') {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'mark_read', child: Row(children: [Icon(Icons.done_all_rounded, color: _primaryGreen, size: 20), SizedBox(width: 12), Text('Mark all as read', style: TextStyle(fontWeight: FontWeight.w600))])),
                    const PopupMenuItem(value: 'archive_all', child: Row(children: [Icon(Icons.archive_outlined, color: _muted, size: 20), SizedBox(width: 12), Text('Archive all', style: TextStyle(fontWeight: FontWeight.w600))])),
                    const PopupMenuDivider(),
                    const PopupMenuItem(value: 'settings', child: Row(children: [Icon(Icons.settings_outlined, color: _muted, size: 20), SizedBox(width: 12), Text('Settings', style: TextStyle(fontWeight: FontWeight.w600))])),
                  ],
                ),
              ),
            ],
          ),

          // ---- SEARCH BAR & FILTERS ----
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                
                // UX: Soft Pill Search Bar (Matching Market Screen)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6))],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: _ink, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) => _runFilter(),
                            style: const TextStyle(fontSize: 15, color: _ink, fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              hintText: 'Search chats, names...',
                              hintStyle: TextStyle(color: _muted.withOpacity(0.8), fontSize: 15, fontWeight: FontWeight.w400),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              _runFilter();
                              FocusScope.of(context).unfocus();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(color: _hairline, shape: BoxShape.circle),
                              child: const Icon(Icons.close_rounded, color: _ink, size: 16),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),

                // Quick Filters (Matching Categories Strip style)
                SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filters.length,
                    itemBuilder: (context, index) {
                      final filterName = _filters[index];
                      final isSelected = _activeFilter == filterName;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _activeFilter = filterName);
                          _runFilter();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: isSelected ? _primaryGreen : Colors.white,
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: isSelected ? [BoxShadow(color: _primaryGreen.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
                            border: Border.all(color: isSelected ? _primaryGreen : _hairline, width: 1),
                          ),
                          child: Center(
                            child: Text(
                              filterName,
                              style: TextStyle(
                                color: isSelected ? Colors.white : _ink,
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // ---- CHAT LIST ----
          _filteredChats.isEmpty 
          ? SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))]),
                      child: Icon(_activeFilter == 'Archived' ? Icons.archive_rounded : Icons.chat_bubble_outline_rounded, size: 48, color: _muted),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _activeFilter == 'Archived' ? 'No Archived Chats' : 'No chats found', 
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _ink, letterSpacing: -0.5)
                    ),
                    const SizedBox(height: 8),
                    Text('Try searching for a different name.', style: TextStyle(fontSize: 14, color: _muted, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 100), 
                  ],
                ),
              ),
            )
          : SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final chat = _filteredChats[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
                    child: Dismissible(
                      key: Key(chat['id']),
                      direction: DismissDirection.endToStart, 
                      onDismissed: (direction) => _deleteChat(chat['id']),
                      background: Container(
                        decoration: BoxDecoration(color: const Color(0xFFEF4444), borderRadius: BorderRadius.circular(24)),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
                            SizedBox(height: 4),
                            Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                          ],
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          // Clear unread count visually when opened
                          setState(() => chat['unreadCount'] = 0);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetailScreen(userName: chat['name'])));
                        },
                        child: _PremiumChatListItem(
                          name: chat['name'],
                          lastMessage: chat['lastMessage'],
                          time: chat['time'],
                          unreadCount: chat['unreadCount'],
                          isOnline: chat['isOnline'],
                          onCallTap: () => _makePhoneCall(chat['phone']),
                        ),
                      ),
                    ),
                  );
                },
                childCount: _filteredChats.length,
              ),
            ),
            
          // Safe spacing for bottom nav bar + FAB
          const SliverToBoxAdapter(child: SizedBox(height: 140)),
        ],
      ),
    );
  }
}

// ---- UX: PREMIUM INDIVIDUAL CHAT TILE ----
class _PremiumChatListItem extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final VoidCallback onCallTap;

  const _PremiumChatListItem({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.isOnline,
    required this.onCallTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasUnread = unreadCount > 0;
    
    // Extract first letter for the Avatar
    final String initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasUnread ? _primaryGreen.withOpacity(0.04) : Colors.white, 
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: hasUnread ? _primaryGreen.withOpacity(0.3) : _hairline, width: hasUnread ? 1.5 : 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8))
        ],
      ),
      child: Row(
        children: [
          // ---- AVATAR ----
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color: _surfaceSoft,
                  shape: BoxShape.circle,
                  border: Border.all(color: _hairline),
                ),
                child: Center(
                  child: Text(
                    initial, 
                    style: const TextStyle(color: _primaryGreen, fontSize: 22, fontWeight: FontWeight.w800)
                  ),
                ),
              ),
              if (isOnline)
                Positioned(
                  right: 2, bottom: 2,
                  child: Container(
                    width: 14, height: 14,
                    decoration: BoxDecoration(color: const Color(0xFF10B981), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2.5)),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),

          // ---- TEXT INFO ----
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(color: _ink, fontWeight: hasUnread ? FontWeight.w800 : FontWeight.w600, fontSize: 16, letterSpacing: -0.2),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  lastMessage,
                  style: TextStyle(color: hasUnread ? _ink : _muted, fontSize: 13, fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w500),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // ---- METADATA (Time, Unread Badge, Call Icon) ----
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: TextStyle(color: hasUnread ? _primaryGreen : _muted, fontSize: 11, fontWeight: hasUnread ? FontWeight.w800 : FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasUnread)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: _primaryGreen, borderRadius: BorderRadius.circular(10)),
                      child: Text(unreadCount.toString(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                    ),
                  if (hasUnread) const SizedBox(width: 10),
                  
                  GestureDetector(
                    onTap: onCallTap,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: _surfaceSoft, shape: BoxShape.circle, border: Border.all(color: _hairline)),
                      child: const Icon(Icons.call_rounded, color: _primaryGreen, size: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}