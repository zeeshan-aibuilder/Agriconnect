import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart'; // 🔥 FIXED: For debugPrint
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _messageController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  void connect(String userId) {
    final wsUrl = dotenv.env['WS_BASE_URL'] ?? 'wss://ws.agriconnect.pk';
    _channel = WebSocketChannel.connect(Uri.parse('$wsUrl?userId=$userId'));

    _channel?.stream.listen(
      (data) {
        final decodedData = jsonDecode(data);
        _messageController.add(decodedData);
      },
      onError: (error) {
        debugPrint(
          'WebSocket Error: $error',
        ); // 🔥 FIXED: No print in production
        _reconnect(userId);
      },
      onDone: () {
        debugPrint(
          'WebSocket Disconnected',
        ); // 🔥 FIXED: No print in production
      },
    );
  }

  void sendEvent(String eventType, Map<String, dynamic> payload) {
    if (_channel != null) {
      final message = jsonEncode({'type': eventType, 'payload': payload});
      _channel!.sink.add(message);
    }
  }

  void _reconnect(String userId) {
    Future.delayed(const Duration(seconds: 5), () => connect(userId));
  }

  void dispose() {
    _channel?.sink.close();
    _messageController.close();
  }
}
