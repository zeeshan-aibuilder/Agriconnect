import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ai_logic_engine.dart'; // Syncing import

final agriAiProvider = Provider<AgriAiService>((ref) {
  return AgriAiService();
});

class AgriAiService {
  String ask(String message) {
    return AgriAiEngine.generateResponse(message);
  }
}
