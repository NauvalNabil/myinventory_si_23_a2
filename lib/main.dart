import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_screen.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

// Custom HTTP override for release builds
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fix for release builds - allow bad certificates
  HttpOverrides.global = MyHttpOverrides();

  try {
    print('🔄 Initializing Supabase...');

    // Tambah timeout untuk network call
    await Supabase.initialize(
      url: 'https://fuvjhhztvohsyvwzdvis.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1dmpoaHp0dm9oc3l2d3pkdmlzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTIwNjQwMTQsImV4cCI6MjA2NzY0MDAxNH0.rsL33X6Vao2cntAAQFtRbOnh8DtsbS959iHZf8_prz8',
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        print('⏰ Supabase initialization timeout - using offline mode');
        throw Exception('Network timeout - check your connection');
      },
    );

    print('✅ Supabase initialized successfully');
  } catch (e) {
    print('❌ Supabase initialization error: $e');
    print('🔄 App will continue in limited mode...');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MyInventory',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
