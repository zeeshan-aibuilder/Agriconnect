import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Dotenv import add kar diya
import 'features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ---- 1. LOAD ENVIRONMENT VARIABLES ----
  // App start hone se pehle .env file ko load karega
  await dotenv.load(fileName: ".env");

  // ---- 2. SUPABASE INITIALIZATION (SECURED) ----
  // Hardcoded keys ko dotenv calls se replace kar diya gaya hai
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // ---- 3. RIVERPOD PROVIDER SCOPE ----
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF10B981)),
        useMaterial3: true,
      ),
      // App hamesha Splash Screen se shuru hogi
      home: const SplashScreen(),
    );
  }
}
