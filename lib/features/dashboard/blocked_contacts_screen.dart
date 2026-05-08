import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class BlockedContactsScreen extends StatefulWidget {
  const BlockedContactsScreen({super.key});

  @override
  State<BlockedContactsScreen> createState() => _BlockedContactsScreenState();
}

class _BlockedContactsScreenState extends State<BlockedContactsScreen> {
  List<Map<String, String>> blockedUsers = [
    {"name": "Zamir Traders", "phone": "0301-9876543"},
    {"name": "Scammer 123", "phone": "0333-1122334"},
  ];

  void _unblockUser(int index) {
    final user = blockedUsers[index];
    setState(() {
      blockedUsers.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${user['name']} has been unblocked.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        backgroundColor: const Color(0xFF022C22),
        title: const Text('Blocked Contacts', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: blockedUsers.isEmpty 
        ? const Center(child: Text("No blocked contacts.", style: TextStyle(color: Colors.grey, fontSize: 16)))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: blockedUsers.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.redAccent, child: Icon(Icons.block, color: Colors.white)),
                  title: Text(blockedUsers[index]["name"]!, style: AppTextStyles.h4),
                  subtitle: Text(blockedUsers[index]["phone"]!),
                  trailing: TextButton(
                    onPressed: () => _unblockUser(index),
                    child: const Text("Unblock", style: TextStyle(color: AppColors.primary500, fontWeight: FontWeight.bold)),
                  ),
                ),
              );
            },
          ),
    );
  }
}