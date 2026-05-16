import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Core Themes
import 'core/theme/app_theme.dart';

// Screens (Update these paths according to your clean architecture)
import 'features/splash/splash_screen.dart';
// Agar splash screen nahi banayi hui, toh iski jagah RoleSelectionScreen import kar lein:
// import 'features/auth/presentation/screens/role_selection_screen.dart';

void main() async {
  // 1. Ensure Flutter bindings are initialized before any async calls
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Lock app orientation to Portrait (Logistics apps shouldn't rotate randomly)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 3. Load Environment Variables (API Keys, Base URLs) securely
  // Make sure you have a .env file in your root folder
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint(
      "Warning: .env file not found. Ensure it exists in the root directory.",
    );
  }

  // 4. Initialize Local Storage, SQLite or Hive here in the future

  // 5. Wrap App with ProviderScope for Riverpod State Management
  runApp(const ProviderScope(child: AgriConnectApp()));
}

class AgriConnectApp extends StatelessWidget {
  const AgriConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriConnect',
      debugShowCheckedModeBanner: false,

      // 🔥 Your Global Clean Theme System
      theme: AppTheme.lightTheme,

      // Future-proofing for Dark Mode
      // darkTheme: AppTheme.darkTheme,
      // themeMode: ThemeMode.system,

      // 🔥 Set your initial screen here
      // For now, let's start with Splash or RoleSelection
      home: const SplashScreen(),
      // Agar SplashScreen ki file nahi hai toh:
      // home: const RoleSelectionScreen(),
    );
  }
}
