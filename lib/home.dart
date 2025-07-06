import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color(0xFF16002F),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 125, 125, 174),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 235, 114, 54),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "Selamat datang, ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 150,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 235, 114, 54),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 40),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              height: 50,
              width: 150,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 235, 114, 54),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.format_list_bulleted, color: Colors.white, size: 35),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
