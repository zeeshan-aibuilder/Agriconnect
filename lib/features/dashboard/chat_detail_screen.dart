import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:url_launcher/url_launcher.dart'; 
import 'dart:async';
import 'dart:io'; 
import 'package:flutter/foundation.dart' show kIsWeb; 

// ---- NATIVE PACKAGES IMPORTS ----
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:record/record.dart'; 
import 'package:path_provider/path_provider.dart'; 

// ---- AAPKI ASLI PROFILE SCREEN KA IMPORT ----
import 'user_profile_screen.dart'; 

// ==========================================
// ULTRA-PREMIUM DESIGN TOKENS
// ==========================================
const Color _ink = Color(0xFF1E293B); 
const Color _muted = Color(0xFF64748B);
const Color _primaryGreen = Color(0xFF10B981); 
const Color _hairline = Color(0xFFE2E8F0);
const Color _surfaceSoft = Color(0xFFF8FAFC); 

class ChatDetailScreen extends StatefulWidget {
  final String userName;
  const ChatDetailScreen({super.key, required this.userName});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();
  
  bool _isTyping = false; 
  bool _partnerIsTyping = false; 

  // ---- ASLI VOICE RECORDING STATES ----
  bool _isRecording = false;
  int _recordDuration = 0;
  Timer? _recordTimer;
  final AudioRecorder _audioRecorder = AudioRecorder();

  final ImagePicker _imagePicker = ImagePicker();

  final List<Map<String, dynamic>> _messages = [
    {'id': '1', 'text': 'Asalam o Alaikum bhai!', 'isMe': false, 'time': '10:00 AM', 'isRead': false, 'type': 'text'},
    {'id': '2', 'text': '500kg Gandum (Wheat) mil jayegi?', 'isMe': false, 'time': '10:01 AM', 'isRead': false, 'type': 'text'},
    {'id': '3', 'text': 'Walaikum Asalam! Haan bhai bilkul mil jayegi. Fresh stock hai.', 'isMe': true, 'time': '10:05 AM', 'isRead': true, 'type': 'text'},
  ];

  // ==========================================
  // 1. SEND MESSAGE LOGIC
  // ==========================================
  void _sendMessage({String? text, String type = 'text', String? filePath}) {
    final sentText = text ?? _messageController.text.trim();
    if (sentText.isEmpty && type == 'text' && filePath == null) return;

    setState(() {
      _messages.add({
        'id': DateTime.now().toString(), 
        'text': sentText, 
        'isMe': true, 
        'time': 'Just now', 
        'isRead': false, 
        'type': type,
        'filePath': filePath 
      });
      _messageController.clear();
      _isTyping = false;
      if (type == 'text') _partnerIsTyping = true; 
    });

    _scrollToBottom();

    if (type == 'text') {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _partnerIsTyping = false;
            _messages.add({'id': DateTime.now().toString(), 'text': 'Theek hai, check karta hoon.', 'isMe': false, 'time': 'Just now', 'isRead': false, 'type': 'text'});
          });
          _scrollToBottom();
        }
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent, 
          duration: const Duration(milliseconds: 300), 
          curve: Curves.easeOutCubic
        );
      }
    });
  }

  // ==========================================
  // 2. REAL VOICE RECORDING
  // ==========================================
  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final path = '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        await _audioRecorder.start(const RecordConfig(), path: path);
        
        setState(() {
          _isRecording = true;
          _recordDuration = 0;
        });

        _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() => _recordDuration++);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Microphone permission required.')));
      }
    } catch (e) {
      debugPrint('Recording error: $e');
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;
    _recordTimer?.cancel();
    
    try {
      final path = await _audioRecorder.stop();
      setState(() => _isRecording = false);
      
      if (path != null && _recordDuration > 0) {
        _sendMessage(text: 'Voice Note (00:${_recordDuration.toString().padLeft(2, '0')})', type: 'audio', filePath: path);
      }
    } catch (e) {
      debugPrint('Stop recording error: $e');
    }
  }

  // ==========================================
  // 3. FILE PICKERS
  // ==========================================
  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context); 
    try {
      final XFile? photo = await _imagePicker.pickImage(source: source, imageQuality: 80);
      if (photo != null) _sendMessage(text: 'Photo', type: 'image', filePath: photo.path);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to pick image.')));
    }
  }

  Future<void> _pickDocument() async {
    Navigator.pop(context);
    try {
      FilePickerResult? result = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx', 'txt']);
      if (result != null && result.files.single.path != null) {
        _sendMessage(text: result.files.single.name, type: 'document', filePath: result.files.single.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to pick document.')));
    }
  }

  Future<void> _pickAudioFile() async {
    Navigator.pop(context);
    try {
      FilePickerResult? result = await FilePicker.pickFiles(type: FileType.audio);
      if (result != null && result.files.single.path != null) {
        _sendMessage(text: result.files.single.name, type: 'audio', filePath: result.files.single.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to pick audio.')));
    }
  }

  // ==========================================
  // 4. CALL LOGIC
  // ==========================================
  Future<void> _makePhoneCall() async {
    const String realPhoneNumber = '03001234567'; 
    final Uri launchUri = Uri(scheme: 'tel', path: realPhoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open dialer.')));
    }
  }

  void _startVideoCallScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => _CallScreen(userName: widget.userName, isVideo: true)));
  }

  // ==========================================
  // ATTACHMENT MENU
  // ==========================================
  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)), // Premium Curves
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              runSpacing: 24,
              children: [
                _attachmentIcon(Icons.insert_drive_file_rounded, const Color(0xFF6366F1), 'Document', _pickDocument),
                _attachmentIcon(Icons.camera_alt_rounded, const Color(0xFFEC4899), 'Camera', () => _pickImage(ImageSource.camera)),
                _attachmentIcon(Icons.image_rounded, const Color(0xFFA855F7), 'Gallery', () => _pickImage(ImageSource.gallery)),
                _attachmentIcon(Icons.headphones_rounded, const Color(0xFFF59E0B), 'Audio', _pickAudioFile),
                _attachmentIcon(Icons.location_on_rounded, const Color(0xFF10B981), 'Location', () { Navigator.pop(context); _sendMessage(text: 'Location Shared 📍', type: 'location'); }),
                _attachmentIcon(Icons.person_rounded, const Color(0xFF3B82F6), 'Contact', () { Navigator.pop(context); _sendMessage(text: 'Contact Card Sent 👤', type: 'contact'); }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _attachmentIcon(IconData icon, Color color, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap, 
      child: SizedBox(
        width: 80, 
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16), 
              decoration: BoxDecoration(
                color: color.withOpacity(0.1), 
                borderRadius: BorderRadius.circular(20), // Squircle
                border: Border.all(color: color.withOpacity(0.2)),
              ), 
              child: Icon(icon, color: color, size: 28)
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _ink)),
          ],
        ),
      ),
    );
  }

  void _showMessageOptions(Map<String, dynamic> message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(width: 48, height: 5, decoration: BoxDecoration(color: _hairline, borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 16),
              ListTile(leading: const Icon(Icons.copy_rounded, color: _ink), title: const Text('Copy Text', style: TextStyle(fontWeight: FontWeight.w600, color: _ink)), onTap: () { Clipboard.setData(ClipboardData(text: message['text'])); Navigator.pop(context); }),
              ListTile(leading: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)), title: const Text('Delete Message', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFEF4444))), onTap: () { setState(() => _messages.removeWhere((m) => m['id'] == message['id'])); Navigator.pop(context); }),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    _scrollController.dispose();
    _recordTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String initial = widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : '?';

    return Scaffold(
      backgroundColor: _surfaceSoft,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 4, 
          shadowColor: Colors.black.withOpacity(0.1),
          leadingWidth: 48,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _ink, size: 20), onPressed: () => Navigator.pop(context)),
          
          title: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileScreen(userName: widget.userName)));
            },
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 44, height: 44, 
                      decoration: BoxDecoration(
                        color: _primaryGreen.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: _primaryGreen.withOpacity(0.3)),
                      ), 
                      child: Center(child: Text(initial, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _primaryGreen)))
                    ),
                    Positioned(
                      right: 0, bottom: 0, 
                      child: Container(
                        width: 12, height: 12, 
                        decoration: BoxDecoration(color: const Color(0xFF10B981), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2))
                      )
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.userName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _ink, letterSpacing: -0.3), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(_partnerIsTyping ? 'typing...' : 'Online', style: TextStyle(fontSize: 12, color: _partnerIsTyping ? _primaryGreen : _muted, fontWeight: _partnerIsTyping ? FontWeight.w700 : FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          actions: [
            IconButton(icon: const Icon(Icons.videocam_rounded, color: _ink, size: 28), onPressed: _startVideoCallScreen), 
            IconButton(icon: const Icon(Icons.call_rounded, color: _ink, size: 24), onPressed: _makePhoneCall), 
            const SizedBox(width: 4),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 24, bottom: 8, left: 16, right: 16),
              itemCount: _messages.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) return _buildDateDivider('Today');
                return _buildChatBubble(_messages[index - 1]);
              },
            ),
          ),
          _buildFloatingInputBar(),
        ],
      ),
    );
  }

  Widget _buildDateDivider(String date) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(color: _hairline, borderRadius: BorderRadius.circular(20)),
        child: Text(date, style: const TextStyle(fontSize: 11, color: _muted, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
      ),
    );
  }

  Widget _buildChatBubble(Map<String, dynamic> message) {
    final bool isMe = message['isMe'];
    final bool isRead = message['isRead'] ?? false;
    final String type = message['type'] ?? 'text';
    final String? filePath = message['filePath'];

    return GestureDetector(
      onLongPress: () => _showMessageOptions(message), 
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isMe) ...[
              Container(width: 28, height: 28, decoration: BoxDecoration(color: _primaryGreen.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.person_rounded, color: _primaryGreen, size: 16)),
              const SizedBox(width: 8),
            ],
            
            Flexible(
              child: Container(
                padding: EdgeInsets.all(type == 'image' ? 4 : 12), 
                decoration: BoxDecoration(
                  color: isMe ? _primaryGreen : Colors.white,
                  gradient: (isMe && type != 'image') ? LinearGradient(colors: [_primaryGreen, const Color(0xFF059669)], begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20), 
                    topRight: const Radius.circular(20), 
                    bottomLeft: Radius.circular(isMe ? 20 : 4), 
                    bottomRight: Radius.circular(isMe ? 4 : 20)
                  ),
                  boxShadow: [
                    if (!isMe) BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                    if (isMe) BoxShadow(color: _primaryGreen.withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    
                    if (type == 'image' && filePath != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: kIsWeb 
                          ? Image.network(filePath, width: 220, height: 260, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: 220, height: 100, color: _surfaceSoft, child: const Center(child: Text('Preview N/A'))))
                          : Image.file(File(filePath), width: 220, height: 260, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: 220, height: 100, color: _surfaceSoft, child: const Center(child: Text('Image Error')))),
                      ),

                    if (type == 'document' || type == 'audio')
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: EdgeInsets.only(bottom: type == 'audio' ? 4 : 8),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.black.withOpacity(0.1) : _surfaceSoft, 
                          borderRadius: BorderRadius.circular(16)
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: isMe ? Colors.white.withOpacity(0.2) : Colors.white, shape: BoxShape.circle),
                              child: Icon(type == 'document' ? Icons.description_rounded : Icons.play_arrow_rounded, color: isMe ? Colors.white : _primaryGreen, size: 20)
                            ),
                            const SizedBox(width: 12),
                            Flexible(child: Text(message['text'], style: TextStyle(color: isMe ? Colors.white : _ink, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ),

                    if (type == 'text' || type == 'location' || type == 'contact')
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        child: Text(message['text'], style: TextStyle(fontSize: 15, color: isMe ? Colors.white : _ink, height: 1.3, fontWeight: FontWeight.w500)),
                      ),
                    
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(message['time'], style: TextStyle(color: isMe ? Colors.white.withOpacity(0.8) : _muted, fontSize: 10, fontWeight: FontWeight.w600)),
                        if (isMe) ...[
                          const SizedBox(width: 4),
                          Icon(isRead ? Icons.done_all_rounded : Icons.check_rounded, color: isRead ? Colors.white : Colors.white.withOpacity(0.6), size: 14),
                        ]
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (isMe) const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }

  // ---- THE NEW FLOATING INPUT BAR ----
  Widget _buildFloatingInputBar() {
    return Container(
      color: Colors.transparent, 
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24), 
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(32), 
                border: Border.all(color: _hairline), 
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 8))]
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: _surfaceSoft, shape: BoxShape.circle),
                      child: const Icon(Icons.add_rounded, color: _ink, size: 24)
                    ), 
                    onPressed: _showAttachmentMenu
                  ),
                  
                  Expanded(
                    child: _isRecording 
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            children: [
                              Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle)),
                              const SizedBox(width: 12),
                              const Text('Recording...', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w700, fontSize: 15)),
                              const Spacer(),
                              Text('00:${_recordDuration.toString().padLeft(2, '0')}', style: const TextStyle(fontWeight: FontWeight.w800, color: _ink)),
                              const SizedBox(width: 16),
                            ],
                          ),
                        )
                      : TextField(
                          controller: _messageController,
                          focusNode: _messageFocusNode,
                          onChanged: (text) => setState(() => _isTyping = text.trim().isNotEmpty),
                          maxLines: 4, minLines: 1,
                          style: const TextStyle(fontSize: 15, color: _ink, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            hintText: 'Type a message...', 
                            hintStyle: TextStyle(color: _muted.withOpacity(0.8)), 
                            border: InputBorder.none, 
                            isDense: true, 
                            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4)
                          ),
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Send / Mic Button
          GestureDetector(
            onTap: _isTyping ? () => _sendMessage() : null,
            onLongPressStart: _isTyping ? null : (_) => _startRecording(),
            onLongPressEnd: _isTyping ? null : (_) => _stopRecording(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52, 
              height: 52,
              decoration: BoxDecoration(
                color: _isTyping ? _primaryGreen : (_isRecording ? const Color(0xFFEF4444) : _ink), 
                shape: BoxShape.circle, 
                boxShadow: [
                  BoxShadow(
                    color: (_isTyping ? _primaryGreen : (_isRecording ? const Color(0xFFEF4444) : _ink)).withOpacity(0.3), 
                    blurRadius: 16, 
                    offset: const Offset(0, 8)
                  )
                ]
              ),
              child: Icon(_isTyping ? Icons.send_rounded : Icons.mic_rounded, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 5. CINEMATIC CALL UI (CRASH-PROOF)
// ==========================================
class _CallScreen extends StatelessWidget {
  final String userName;
  final bool isVideo;

  const _CallScreen({required this.userName, required this.isVideo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF020617)], 
            begin: Alignment.topCenter, end: Alignment.bottomCenter
          )
        ),
        child: SafeArea(
          child: Column(
            children: [
              // THE FIX: Wrapped the central info in Expanded + SingleChildScrollView
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40), // Safe top padding
                      Text(isVideo ? 'AgriConnect Video' : 'AgriConnect Audio', style: const TextStyle(fontSize: 14, color: Colors.white54, fontWeight: FontWeight.w600, letterSpacing: 1)),
                      const SizedBox(height: 32),
                      
                      // Avatar
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(width: 160, height: 160, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.05), width: 1))),
                          Container(width: 130, height: 130, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.1), width: 1))),
                          Container(
                            width: 100, height: 100, 
                            decoration: BoxDecoration(color: _primaryGreen, shape: BoxShape.circle, boxShadow: [BoxShadow(color: _primaryGreen.withOpacity(0.5), blurRadius: 40, spreadRadius: 10)]),
                            child: Center(child: Text(userName[0].toUpperCase(), style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: Colors.white)))
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      Text(userName, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -1), textAlign: TextAlign.center),
                      const SizedBox(height: 8),
                      const Text('Ringing...', style: TextStyle(fontSize: 16, color: Colors.white54, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 40), // Safe bottom padding
                    ],
                  ),
                ),
              ),
              
              // THE FIX: Reduced Paddings/Margins to prevent horizontal overflow on 320px screens
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24), // Tighter margin
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12), // Tighter padding
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1), 
                  borderRadius: BorderRadius.circular(32), 
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _callIcon(Icons.volume_up_rounded, Colors.white.withOpacity(0.15), Colors.white),
                    if (isVideo) _callIcon(Icons.videocam_off_rounded, Colors.white.withOpacity(0.15), Colors.white),
                    _callIcon(Icons.mic_off_rounded, Colors.white.withOpacity(0.15), Colors.white),
                    _callIcon(Icons.call_end_rounded, const Color(0xFFEF4444), Colors.white, onTap: () => Navigator.pop(context)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _callIcon(IconData icon, Color bgColor, Color iconColor, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12), // Reduced from 16 to 12 for small screens
        decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle), 
        child: Icon(icon, color: iconColor, size: 24) // Reduced from 28 to 24
      ),
    );
  }
}