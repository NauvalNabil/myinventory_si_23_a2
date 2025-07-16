import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:myinventory_si_23_a2/login.dart';
import 'package:myinventory_si_23_a2/services/authServices.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.username, required this.email});

  final String username;
  final String email;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? displayEmail;
  String? displayUsername;
  String? _imageUrl;
  bool _isLoading = true;
  final AuthService _authService = AuthService();
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final currentUser = _supabase.auth.currentUser;
    final userMetadata = currentUser?.userMetadata;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      displayEmail = widget.email;
      displayUsername = prefs.getString('username') ?? userMetadata?['username'] ?? widget.username;
      _imageUrl = userMetadata?['avatar_url'];
      _isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (pickedFile != null) {
      setState(() => _isLoading = true);
      try {
        final file = File(pickedFile.path);
        
        final fileName = _supabase.auth.currentUser!.id;
        const bucketName = 'profile-pictures';

        await _supabase.storage.from(bucketName).upload(
              fileName,
              file,
              fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
            );

        final imageUrlResponse = _supabase.storage.from(bucketName).getPublicUrl(fileName);
        
        // PERBAIKAN: Buat URL unik dengan parameter waktu untuk
        final uniqueUrl = '$imageUrlResponse?t=${DateTime.now().millisecondsSinceEpoch}';

        await _supabase.auth.updateUser(
          UserAttributes(
            data: {'avatar_url': uniqueUrl},
          ),
        );

        if (mounted) {
          setState(() {
            _imageUrl = uniqueUrl;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mengunggah foto: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }
  
  // Fungsi _editUsername dan _logout tidak ada perubahan, tetap sama
  Future<void> _editUsername() async {
    TextEditingController usernameController =
        TextEditingController(text: displayUsername ?? '');

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(0, 6, 47, 1.0),
          title: const Text('Edit Username', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: usernameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Masukkan username baru',
              hintStyle: TextStyle(color: Colors.white54),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.white70)),
            ),
            TextButton(
              onPressed: () async {
                final newUsername = usernameController.text.trim();
                if (newUsername.isNotEmpty) {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setString('username', newUsername);
                  
                  await _supabase.auth.updateUser(
                    UserAttributes(data: {'username': newUsername})
                  );

                  setState(() {
                    displayUsername = newUsername;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan', style: TextStyle(color: Color(0xFFD65A38))),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(0, 6, 47, 1.0),
          title: const Text('Konfirmasi Logout', style: TextStyle(color: Colors.white)),
          content: const Text('Apakah Anda yakin ingin keluar?', style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.white70)),
            ),
            TextButton(
              onPressed: () async {
                if (mounted) {
                  await _authService.logout();
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  Get.offAll(() => const LoginPage());
                }
              },
              child: const Text('Logout', style: TextStyle(color: Color(0xFFD65A38))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, displayUsername);
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(0, 6, 47, 1.0),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 235, 114, 54),
          elevation: 4,
          title: const Text('Profile', style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context, displayUsername);
            },
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFFD65A38)))
            : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white,
                        backgroundImage: _imageUrl != null ? CachedNetworkImageProvider(_imageUrl!) : null,
                        child: _imageUrl == null
                            ? const Icon(Icons.person, size: 100, color: Color(0xFF0F1035))
                            : null,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.person, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          displayUsername ?? 'Tidak tersedia',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: _editUsername,
                          child: const Icon(Icons.edit, color: Colors.white70, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.email, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          displayEmail ?? 'Tidak tersedia',
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _logout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 235, 114, 54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'LOGOUT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ),
      ),
    );
  }
}