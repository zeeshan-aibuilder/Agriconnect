import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/splash/splash_screen.dart'; // Apna splash screen import karein

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ---- 1. SUPABASE INITIALIZATION ----
  await Supabase.initialize(
    url: 'https://qhopruqddmnbiyzeezmt.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFob3BydXFkZG1uYml5emVlem10Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc2NDQ1NTksImV4cCI6MjA5MzIyMDU1OX0.bQRNqb4G_knjwrG7De9zWRi4ABxW_OEaDDqgIV8sdHw', 
  );

  // ---- 2. RIVERPOD PROVIDER SCOPE ----
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
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