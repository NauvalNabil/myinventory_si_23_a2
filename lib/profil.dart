import 'package:flutter/material.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  String username = 'USERNAME';
  String email = 'Username@Gmail.Com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3E3E50),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD65A38),
        elevation: 4,
        centerTitle: false,
        titleSpacing: 0,
        title: const Text(
          'PROFILE',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 18),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),

          // Username
          Row(
            children: [
              const SizedBox(width: 20),
              const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xFF0F1035)),
              ),
              const SizedBox(width: 10),
              Text(
                username,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Email
          Row(
            children: [
              const SizedBox(width: 20),
              const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.email, color: Color(0xFF0F1035)),
              ),
              const SizedBox(width: 10),
              Text(
                email,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
