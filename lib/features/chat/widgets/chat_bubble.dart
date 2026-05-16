import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/models/message_model.dart';

class ChatBubble extends StatelessWidget {
  final Message message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        padding: EdgeInsets.all(message.type == MessageType.image ? 4 : 12),
        decoration: BoxDecoration(
          color: message.isMe ? AppColors.primary700 : AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: message.isMe
                ? const Radius.circular(16)
                : const Radius.circular(4),
            bottomRight: message.isMe
                ? const Radius.circular(4)
                : const Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: message.isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            _buildMessageContent(context),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.formattedTime,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 10,
                    color: message.isMe
                        ? AppColors.white.withValues(alpha: 0.7)
                        : AppColors.gray400,
                  ),
                ),
                if (message.isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.isRead ? Icons.done_all : Icons.check_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    switch (message.type) {
      case MessageType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: message.filePath != null
              ? (kIsWeb
                    ? Image.network(
                        message.filePath!,
                        width: 220,
                        height: 260,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(message.filePath!),
                        width: 220,
                        height: 260,
                        fit: BoxFit.cover,
                      ))
              : const SizedBox(
                  width: 220,
                  height: 100,
                  child: Center(child: Text('Image Error')),
                ),
        );
      case MessageType.document:
      case MessageType.audio:
      case MessageType.location:
        return Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            color: message.isMe
                ? Colors.black.withValues(alpha: 0.1)
                : AppColors.bgSecondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: message.isMe
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  message.type == MessageType.document
                      ? Icons.description_rounded
                      : (message.type == MessageType.location
                            ? Icons.location_on_rounded
                            : Icons.play_arrow_rounded),
                  color: message.isMe ? Colors.white : AppColors.primary700,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  message.text,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: message.isMe ? Colors.white : AppColors.gray900,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      default: // Text
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text(
            message.text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: message.isMe ? Colors.white : AppColors.gray900,
              fontSize: 15,
            ),
          ),
        );
    }
  }
}
