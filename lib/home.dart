import 'package:flutter/material.dart';
import 'package:myinventory_si_23_a2/models/kardusModel.dart';
import 'package:myinventory_si_23_a2/services/kardusService.dart';
import 'package:myinventory_si_23_a2/buatkardus.dart';
import 'package:myinventory_si_23_a2/listkardus.dart';
import 'package:myinventory_si_23_a2/profil.dart';
import 'package:myinventory_si_23_a2/isikardus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final String email;

  const HomeScreen({super.key, required this.username, required this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String username;
  String? _imageUrl;
  late final KardusService _kardusService;
  List<KardusModel> daftarKardus = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    username = widget.username;
    _kardusService = KardusService();
    _loadKardus();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser != null) {
      final userMetadata = currentUser.userMetadata;
      if (mounted) {
        setState(() {
          _imageUrl = userMetadata?['avatar_url'];
        });
      }
    }
  }

  Future<void> _loadKardus() async {
    setState(() => _isLoading = true);
    try {
      final kardusList = await _kardusService.getAllKardus();
      if (mounted) {
        setState(() {
          daftarKardus = kardusList;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal memuat kardus: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _navigateToProfile() async {
    final updatedUsername = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => Profile(
          username: username,
          email: widget.email,
        ),
      ),
    );

    if (updatedUsername != null && updatedUsername.isNotEmpty) {
      setState(() {
        username = updatedUsername;
      });
    }
    _loadProfileImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 6, 47, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 125, 125, 174),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        ),
        title: Row(
          children: [
            GestureDetector(
              onTap: _navigateToProfile,
              child: CircleAvatar(
                radius: 22.5,
                backgroundColor: Colors.white,
                backgroundImage:
                    _imageUrl != null ? CachedNetworkImageProvider(_imageUrl!) : null,
                child: _imageUrl == null
                    ? const Icon(Icons.person, color: Color(0xFF0F1035), size: 30)
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "Selamat datang, $username",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Buatkardus()),
                            );
                            _loadKardus();
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 235, 114, 54),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child:
                                  Icon(Icons.add, color: Colors.white, size: 40),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final hasilList = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Listkardus(kardus: daftarKardus),
                              ),
                            );
                            if (hasilList != null &&
                                hasilList is List<KardusModel>) {
                              setState(() {
                                daftarKardus = hasilList;
                              });
                            }
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 235, 114, 54),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Icon(Icons.format_list_bulleted,
                                  color: Colors.white, size: 35),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: ListView.builder(
                      itemCount: daftarKardus.length,
                      itemBuilder: (context, index) {
                        final kardus = daftarKardus[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Isikardus(kardus: kardus),
                                      ),
                                    );
                                    _loadKardus();
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 125, 125, 174),
                                      borderRadius: BorderRadius.circular(8),
                                      image: kardus.gambar != null &&
                                              kardus.gambar!.isNotEmpty
                                          ? DecorationImage(
                                              image: CachedNetworkImageProvider(kardus.gambar!),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: (kardus.gambar == null ||
                                            kardus.gambar!.isEmpty)
                                        ? const Icon(Icons.folder_copy,
                                            size: 40, color: Colors.white)
                                        : null,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        kardus.kategori.toUpperCase(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(kardus.deskripsi ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(fontSize: 12)),
                                      const SizedBox(height: 4),
                                      Text(
                                        (kardus.lokasi ?? '').toUpperCase(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}