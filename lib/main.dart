import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_screen.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fuvjhhztvohsyvwzdvis.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1dmpoaHp0dm9oc3l2d3pkdmlzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTIwNjQwMTQsImV4cCI6MjA2NzY0MDAxNH0.rsL33X6Vao2cntAAQFtRbOnh8DtsbS959iHZf8_prz8',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

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
