enum MessageType { text, audio, image, document, location, contact }

class Message {
  final String id;
  final String text;
  final MessageType type;
  final bool isMe;
  final DateTime timestamp;
  final bool isRead;
  final String? filePath;

  Message({
    required this.id,
    required this.text,
    this.type = MessageType.text,
    required this.isMe,
    required this.timestamp,
    this.isRead = false,
    this.filePath,
  });

  String get formattedTime {
    final hour = timestamp.hour > 12
        ? timestamp.hour - 12
        : (timestamp.hour == 0 ? 12 : timestamp.hour);
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final amPm = timestamp.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $amPm';
  }
}
