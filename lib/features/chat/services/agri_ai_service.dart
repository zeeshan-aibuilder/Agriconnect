class AgriAiService {
  // 🛡️ SECURITY: Smart Regex to hide Mobile Numbers but keep Prices safe
  static String maskPhoneNumbers(String text) {
    // Matches 03xx-xxxxxxx, +923xx-xxxxxxx, etc.
    final phoneRegex = RegExp(
      r'(\+92|0)\s*3\d{2}\s*[-]?\s*\d{3}\s*[-]?\s*\d{4}',
    );
    return text.replaceAll(phoneRegex, '🔒 [Number Hidden for Security]');
  }

  // 🧠 OFFLINE AI BRAIN (Urdu, English, Hinglish)
  static String getSmartResponse(String rawMessage) {
    String msg = rawMessage.toLowerCase();

    // 1. Greetings
    if (msg.contains('salam') ||
        msg.contains('hello') ||
        msg.contains('hi') ||
        msg.contains('hey')) {
      return "Walaikum Assalam! 👋 Main AgriConnect ka AI Assistant hoon.\n\nMain aapki kya madad kar sakta hoon?\n1️⃣ App kaise use karein?\n2️⃣ Fasal bechni hai\n3️⃣ Transporter chahiye\n4️⃣ Fraud se kaise bachein?";
    }

    // 2. App Vision & Purpose
    if (msg.contains('vision') ||
        msg.contains('agriconnect kya hai') ||
        msg.contains('about')) {
      return "🌱 *AgriConnect Ka Vision*\nHamara maqsad Pakistan ki agriculture market se 'Middleman' (Aarthiya) ka kirdar khatam karna hai. Hum kisaan ko direct industry (factories/mills) se jorte hain taake kisaan ko apni mehnat ka poora muawza milay aur industry ko fresh maal.";
    }

    // 3. Selling / Posting (Supplier)
    if (msg.contains('bechna') ||
        msg.contains('sell') ||
        msg.contains('post') ||
        msg.contains('list')) {
      return "📦 *Fasal Bechna Bohat Asaan Hai:*\n\n1. Neeche center mein '+' (Add) button dabayein.\n2. Apni fasal (crop) select karein aur tasweer lagayein.\n3. Quantity aur Rate likhein.\n4. 'Publish' kar dein.\n\nJaise hi koi Buyer match hoga, aapko notification mil jayega!";
    }

    // 4. Buying (Industry)
    if (msg.contains('khareedna') ||
        msg.contains('buy') ||
        msg.contains('demand')) {
      return "🏭 *Bulk Khareedari (Buying):*\n\n1. Market tab mein jayen.\n2. Wahan filter lagayen (e.g., Wheat, 50 Tons, Lahore).\n3. Kisaanon ki listings dekhein aur unhein direct message kar ke rate final karein.";
    }

    // 5. Transporter Phase 2
    if (msg.contains('transport') ||
        msg.contains('truck') ||
        msg.contains('mazda') ||
        msg.contains('delivery')) {
      return "🚚 *Logistics & Transport*\nAbhi humara Transporter module Phase 2 mein hai. Jaldi hi aap deal final hone ke baad seedha chat se hi truck book kar sakenge!";
    }

    // 6. Security / Pricing / Calls
    if (msg.contains('call') ||
        msg.contains('number') ||
        msg.contains('contact')) {
      return "🔒 *Security Policy*\nAap aur buyer app ke andar hi Audio/Video call kar sakte hain. Number exchange karna allow nahi hai jab tak deal confirm na ho jaye. Deal confirm hone par numbers automatically share ho jayenge.";
    }

    // Fallback Response
    return "Maazrat, main ek AI hoon aur abhi naye alfaaz seekh raha hoon. 🤖\n\nAgar aapko fasal bechne, khareedne, ya app chalane mein koi masla aa raha hai toh asaan ilfaaz mein poochein.";
  }
}
