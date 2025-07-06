import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String username = 'USERNAME';
  String email = 'Username@Gmail.Com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 6, 47, 1.0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD65A38),
        elevation: 4,
        centerTitle: false,
        titleSpacing: 0,
        title: const Text(
          'Profile ',
          style: TextStyle(color: Colors.white),
        ),
        // Gunakan ikon back default tanpa dekorasi
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),

          // Circle avatar di tengah atas
          Center(
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 50, color: Color(0xFF0F1035)),
            ),
          ),

          const SizedBox(height: 30),

          // Username
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                username,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Email
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.email, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                email,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
