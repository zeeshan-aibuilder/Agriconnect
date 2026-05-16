import 'dart:math';
import 'ai_knowledge_base.dart';

class AgriAiEngine {
  static String generateResponse(String userMessage) {
    final cleanedMessage = _normalize(userMessage);
    final securityCheckedMessage = SecurityLayer.maskSensitiveData(
      cleanedMessage,
    );
    final matchedIntent = IntentMatcher.findBestIntent(securityCheckedMessage);

    if (matchedIntent == null) {
      return _fallbackResponse();
    }
    return ResponseGenerator.generate(matchedIntent);
  }

  static String _normalize(String input) {
    return input
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^\w\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  static String _fallbackResponse() {
    final fallbackResponses = [
      "🤖 Maazrat, main abhi is baat ko theek se samajh nahi saka.\n\nAap B2B Deals, Logistics, Cherries/Olives ki listing, ya Aarthiya system ko bypass karne ke baray mein pooch sakte hain.",
      "🌱 Main AgriConnect AI hoon. Aap fasal bechne, verified buyers dhoondne, ya market rates par sawal kar sakte hain.",
    ];
    return fallbackResponses[Random().nextInt(fallbackResponses.length)];
  }
}

class SecurityLayer {
  static String maskSensitiveData(String text) {
    text = _maskPhoneNumbers(text);
    text = _maskEmails(text);
    return text;
  }

  static String _maskPhoneNumbers(String text) {
    final phoneRegex = RegExp(
      r'(\+92|0)\s*3\d{2}\s*[-]?\s*\d{3}\s*[-]?\s*\d{4}',
    );
    return text.replaceAll(phoneRegex, '🔒 [Contact Hidden]');
  }

  static String _maskEmails(String text) {
    final emailRegex = RegExp(r'[\w-\.]+@([\w-]+\.)+[\w-]{2,4}');
    return text.replaceAll(emailRegex, '🔒 [Email Hidden]');
  }
}

class IntentMatcher {
  static AiKnowledgeEntry? findBestIntent(String message) {
    AiKnowledgeEntry? bestMatch;
    int highestScore = 0;

    for (final entry in AgriAiKnowledgeBase.entries) {
      int score = 0;
      for (final keyword in entry.keywords) {
        if (message.contains(keyword)) score += 10;
      }
      score += entry.priority;

      if (score >= 10 && score > highestScore) {
        highestScore = score;
        bestMatch = entry;
      }
    }
    return bestMatch;
  }
}

class ResponseGenerator {
  static String generate(AiKnowledgeEntry entry) {
    return entry.responses[Random().nextInt(entry.responses.length)];
  }
}
