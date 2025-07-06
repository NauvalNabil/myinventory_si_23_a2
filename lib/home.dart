import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myinventory_si_23_a2/buatkardus.dart';
import 'package:myinventory_si_23_a2/listkardus.dart';
import 'package:myinventory_si_23_a2/profil.dart';
import 'package:myinventory_si_23_a2/isikardus.dart';
import 'package:myinventory_si_23_a2/kartuisi.dart';

class Kardus {
  String kategori;
  String deskripsi;
  String lokasi;
  XFile? gambar;
  List<Item> isiItem;

  Kardus({
    required this.kategori,
    required this.deskripsi,
    required this.lokasi,
    this.gambar,
    this.isiItem = const [],
  });
}

class HomeScreen extends StatefulWidget {
  final String username;
  final String email;

  const HomeScreen({super.key, required this.username, required this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Kardus> daftarKardus = [];

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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(
                      username: widget.username,
                      email: widget.email,
                    ),
                  ),
                );
              },
              child: Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 235, 114, 54),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 30),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "Selamat datang, ${widget.username}",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    final hasil = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Buatkardus()),
                    );
                    if (hasil != null && hasil is Kardus) {
                      setState(() {
                        daftarKardus.add(hasil);
                      });
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 235, 114, 54),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Icon(Icons.add, color: Colors.white, size: 40),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () async {
                    final hasilList = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Listkardus(kardus: daftarKardus),
                      ),
                    );
                    if (hasilList != null && hasilList is List<Kardus>) {
                      setState(() {
                        daftarKardus = hasilList;
                      });
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 150,
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
                              final hasil = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Isikardus(kardus: kardus),
                                ),
                              );
                              if (hasil != null && hasil is Kardus) {
                                setState(() {
                                  daftarKardus[index] = hasil;
                                });
                              }
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color:
                                    const Color.fromARGB(255, 125, 125, 174),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.folder_copy,
                                  size: 40, color: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  kardus.kategori.toUpperCase(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(kardus.deskripsi,
                                    style: const TextStyle(fontSize: 12)),
                                const SizedBox(height: 4),
                                Text(
                                  kardus.lokasi.toUpperCase(),
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
