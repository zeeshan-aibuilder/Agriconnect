import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/ai_engine/ai_logic_engine.dart';
import '../../core/models/message_model.dart';
import 'widgets/chat_bubble.dart';

class ChatDetailScreen extends StatefulWidget {
  final String name;
  final bool isAi;
  final bool isVerified;
  final bool isOnline;

  const ChatDetailScreen({
    super.key,
    required this.name,
    this.isAi = false,
    this.isVerified = false,
    this.isOnline = false,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();
  final ImagePicker _imagePicker = ImagePicker();

  final List<Message> _messages = [];
  bool _isTyping = false;
  bool _partnerIsTyping = false;

  bool _isRecording = false;
  int _recordDuration = 0;
  Timer? _recordTimer;
  late final AudioRecorder _audioRecorder;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _loadInitialMessages();
  }

  void _loadInitialMessages() {
    _messages.add(
      Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: widget.isAi
            ? AgriAiEngine.generateResponse("hello")
            : "Assalam o Alaikum! Aapke pass 50 ton wheat available hai?",
        type: MessageType.text,
        isMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    );
  }

  // --- 1. CORE MESSAGING LOGIC ---
  void _sendMessage({
    String? text,
    MessageType type = MessageType.text,
    String? filePath,
  }) {
    final sentText = text ?? _msgController.text.trim();
    if (sentText.isEmpty && type == MessageType.text && filePath == null) {
      return;
    }

    try {
      String safeText = (type == MessageType.text)
          ? SecurityLayer.maskSensitiveData(sentText)
          : sentText;

      setState(() {
        _messages.insert(
          0,
          Message(
            id: DateTime.now().toString(),
            text: safeText,
            type: type,
            isMe: true,
            timestamp: DateTime.now(),
            filePath: filePath,
          ),
        );
        _msgController.clear();
        _isTyping = false;
        if (type == MessageType.text && widget.isAi) _partnerIsTyping = true;
      });

      _scrollToBottom();

      if (widget.isAi && type == MessageType.text) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (!mounted) return;
          setState(() {
            _partnerIsTyping = false;
            _messages.insert(
              0,
              Message(
                id: DateTime.now().toString(),
                text: AgriAiEngine.generateResponse(safeText),
                type: MessageType.text,
                isMe: false,
                timestamp: DateTime.now(),
              ),
            );
          });
          _scrollToBottom();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error500,
          ),
        );
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // --- 2. NATIVE HARDWARE INTEGRATIONS ---
  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final path =
            '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(const RecordConfig(), path: path);
        setState(() {
          _isRecording = true;
          _recordDuration = 0;
        });

        _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() => _recordDuration++);
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Microphone permission required.')),
          );
        }
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
        _sendMessage(
          text: 'Voice Note (00:${_recordDuration.toString().padLeft(2, '0')})',
          type: MessageType.audio,
          filePath: path,
        );
      }
    } catch (e) {
      debugPrint('Stop recording error: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (photo != null) {
        _sendMessage(
          text: 'Photo Attached',
          type: MessageType.image,
          filePath: photo.path,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to pick image.')));
      }
    }
  }

  Future<void> _pickDocument() async {
    Navigator.pop(context);
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      );
      if (result != null && result.files.single.path != null) {
        _sendMessage(
          text: result.files.single.name,
          type: MessageType.document,
          filePath: result.files.single.path,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to pick document.')),
        );
      }
    }
  }

  Future<void> _shareCurrentLocation() async {
    Navigator.pop(context);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Please enable GPS in phone settings.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied.');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission permanently denied.');
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fetching Location...'),
          backgroundColor: AppColors.info500,
        ),
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;
      _sendMessage(
        text:
            'Live Location 📍\nLAT: ${position.latitude.toStringAsFixed(4)}\nLNG: ${position.longitude.toStringAsFixed(4)}',
        type: MessageType.location,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.error500,
        ),
      );
    }
  }

  @override
  void dispose() {
    _msgController.dispose();
    _messageFocusNode.dispose();
    _scrollController.dispose();
    _recordTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  // --- 3. UI RENDERING ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        title: Text(widget.name, style: AppTextStyles.h4),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length + (_partnerIsTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_partnerIsTyping && index == 0) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Typing...',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: AppColors.gray500,
                        ),
                      ),
                    ),
                  );
                }
                final msg = _messages[_partnerIsTyping ? index - 1 : index];
                return ChatBubble(message: msg);
              },
            ),
          ),
          _buildBottomInputBar(),
        ],
      ),
    );
  }

  Widget _buildBottomInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
      decoration: const BoxDecoration(color: AppColors.white),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.add_circle_outline,
                color: AppColors.gray500,
                size: 28,
              ),
              onPressed: _showAttachmentMenu,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.bgSecondary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: _isRecording
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEF4444),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Recording...',
                              style: TextStyle(
                                color: Color(0xFFEF4444),
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '00:${_recordDuration.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AppColors.gray900,
                              ),
                            ),
                          ],
                        ),
                      )
                    : TextField(
                        controller: _msgController,
                        focusNode: _messageFocusNode,
                        onChanged: (text) =>
                            setState(() => _isTyping = text.trim().isNotEmpty),
                        style: AppTextStyles.bodyMedium,
                        decoration: const InputDecoration(
                          hintText: "Type your message...",
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _isTyping ? () => _sendMessage() : null,
              onLongPressStart: _isTyping ? null : (_) => _startRecording(),
              onLongPressEnd: _isTyping ? null : (_) => _stopRecording(),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isTyping ? AppColors.primary700 : AppColors.gray900,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isTyping ? Icons.send_rounded : Icons.mic_rounded,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            runSpacing: 24,
            children: [
              _attachmentIcon(
                Icons.insert_drive_file_rounded,
                const Color(0xFF6366F1),
                'Document',
                _pickDocument,
              ),
              _attachmentIcon(
                Icons.camera_alt_rounded,
                const Color(0xFFEC4899),
                'Camera',
                () => _pickImage(ImageSource.camera),
              ),
              _attachmentIcon(
                Icons.image_rounded,
                const Color(0xFFA855F7),
                'Gallery',
                () => _pickImage(ImageSource.gallery),
              ),
              _attachmentIcon(
                Icons.location_on_rounded,
                AppColors.success500,
                'Location',
                _shareCurrentLocation,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _attachmentIcon(
    IconData icon,
    Color color,
    String label,
    VoidCallback onTap,
  ) {
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
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withValues(alpha: 0.2)),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.gray900,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
