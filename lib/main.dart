import 'package:flutter/material.dart';
import 'daftar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Pendaftaran',
      theme: ThemeData(
        
        brightness: Brightness.dark, 
      ),
      home: const Daftar(), 
      debugShowCheckedModeBanner: false, 
    );
  }
}
