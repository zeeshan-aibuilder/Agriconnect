class AiKnowledgeEntry {
  final String intent;
  final List<String> keywords;
  final List<String> responses;
  final int priority;

  const AiKnowledgeEntry({
    required this.intent,
    required this.keywords,
    required this.responses,
    this.priority = 1,
  });
}

class AgriAiKnowledgeBase {
  static const List<AiKnowledgeEntry> entries = [
    // --- 1. GREETINGS ---
    AiKnowledgeEntry(
      intent: "greeting",
      priority: 10,
      keywords: [
        "hi",
        "hello",
        "hey",
        "salam",
        "assalam",
        "aoa",
        "good morning",
        "kese ho",
        "help",
      ],
      responses: [
        "👋 Assalamualaikum! Main AgriConnect ka AI Brain hoon. \n\nMain aapki madad kar sakta hoon:\n• Fasal bechne mein 🌾\n• Verified buyers dhoondne mein 🏭\n• Transport book karne mein 🚚\nBatayein, aaj main aapki kya madad karun?",
        "🌱 Welcome to AgriConnect! B2B agriculture ko asaan aur profitable banane ka platform. Agar aapko rates janne hain ya deal karni hai, toh mujhe batayein.",
      ],
    ),

    // --- 2. VISION & IMPORT SUBSTITUTION (YOUR CORE IDEA) ---
    AiKnowledgeEntry(
      intent: "vision_imports",
      priority: 10,
      keywords: [
        "vision",
        "import",
        "zaya",
        "wastage",
        "waste",
        "agriconnect kya hai",
        "idea",
        "aim",
        "purpose",
      ],
      responses: [
        "🌍 AgriConnect ka main maqsad Pakistan ko agricultural imports se azad karna hai. Hum northern areas (Gilgit, Swat) ka fruit jo logistics na hone ki wajah se zaya (waste) ho jata tha, usay seedha processing industries tak pohnchate hain.",
        "🏭 Pakistan har saal millions of dollars ka fruit aur raw material import karta hai jabke hamara apna premium produce zaya ho jata hai. AgriConnect is supply chain ko digital karke wastage khatam karta hai aur farmers ko direct factories se connect karta hai.",
      ],
    ),

    // --- 3. PREMIUM CROPS (CHERRY, APRICOT, OLIVE) ---
    AiKnowledgeEntry(
      intent: "premium_crops",
      priority: 9,
      keywords: [
        "cherry",
        "cherries",
        "apricot",
        "khubani",
        "olive",
        "olives",
        "zaitoon",
        "swat",
        "gilgit",
        "northern",
      ],
      responses: [
        "🍒 Hum specialized hain high-value crops mein! Gilgit ki Cherries, Apricots aur Swat ke Olives (Zaitoon) ab direct juice aur oil extraction factories ko bechay ja sakte hain. Aap inki listing bana sakte hain.",
        "🫒 Pakistan mein Olives aur Cherries ki bohut demand hai. Processing industries achay rates par bulk mein uthati hain. 'Sell Crop' par click karein aur apna produce list karein taake buyers aap se direct raabta karein.",
      ],
    ),

    // --- 4. BYPASSING THE MIDDLEMAN (AARTHIYA) ---
    AiKnowledgeEntry(
      intent: "middleman",
      priority: 9,
      keywords: [
        "aarthiya",
        "commission",
        "agent",
        "middleman",
        "direct",
        "profit",
        "faida",
        "bachat",
      ],
      responses: [
        "🤝 AgriConnect par Aarthiya (Commission Agent) ka koi concept nahi! Kisan apni fasal ka rate khud tay karta hai aur Industry direct kisan ko pay karti hai. Zero hidden commission, 100% transparent.",
        "💰 Traditional mandi mein aarthiya aapka margin kha jata hai. AgriConnect par aap seedha verified Wholesale Buyers aur Mills se deal karke 15-20% extra profit bacha sakte hain.",
      ],
    ),

    // --- 5. LOGISTICS & TRANSPORT (PHASE 2) ---
    AiKnowledgeEntry(
      intent: "transportation",
      priority: 8,
      keywords: [
        "truck",
        "transport",
        "delivery",
        "logistics",
        "bhejna",
        "pahunchana",
        "book",
        "rent",
        "freight",
      ],
      responses: [
        "🚚 Hamara Logistics Network Phase 2 mein aayega! Jisme Verified Transporters direct app se truck book karne ki sahoolat denge. Live ETA, Fuel Logs, aur secure tracking hogi.",
        "📦 Deal confirm hone ke baad, buyer ya seller hamare 'Logistics Partner' module se direct truck (Mazda, Loader, Container) book kar sakenge.",
      ],
    ),

    // --- 6. PRICING, MOQ & NEGOTIATION ---
    AiKnowledgeEntry(
      intent: "b2b_pricing",
      priority: 8,
      keywords: [
        "price",
        "rate",
        "moq",
        "negotiate",
        "minimum",
        "bulk",
        "rate tay",
        "mandi rate",
      ],
      responses: [
        "📊 B2B Deal mein rate ki flexibility hoti hai. Aap 'Negotiable' toggle on kar sakte hain taake buyer aapko counter-offer de sakay. Hamesha apna Minimum Order Quantity (MOQ) zaroor specify karein (e.g., 50 Tons).",
        "📈 Live Mandi Rates Dashboard par available hain. Apni listing ka rate set karne se pehle market trends zaroor check karein taake aapki deal jaldi final ho.",
      ],
    ),

    // --- 7. SECURITY & FRAUD PREVENTION ---
    AiKnowledgeEntry(
      intent: "security",
      priority: 10,
      keywords: [
        "fraud",
        "scam",
        "safe",
        "secure",
        "number",
        "contact",
        "trust",
        "verification",
      ],
      responses: [
        "🔒 AgriConnect par aapki security sab se pehle hai! Hamara AI automatically chat mein phone numbers aur emails ko hide kar deta hai (masking) taake deals platform ke andar hi secure rahain aur koi fraud na ho.",
        "🛡️ Hum sirf Verified Buyers (jinke pass NTN/Business Registration hoti hai) ko approve karte hain. Hamesha payment terms (Advance, On Delivery) app ke Deal Widget mein confirm karein.",
      ],
    ),
  ];
}
