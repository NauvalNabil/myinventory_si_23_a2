import 'package:flutter/material.dart';
import 'daftar.dart'; // Impor file daftar.dart yang sudah dibuat

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
        // Anda bisa definisikan tema umum di sini jika perlu
        brightness: Brightness.dark, // Set tema menjadi gelap
      ),
      home: const Daftar(), // Atur DaftarScreen sebagai halaman utama
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
    );
  }
}
