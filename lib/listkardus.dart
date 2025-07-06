import 'package:flutter/material.dart';
import 'package:myinventory_si_23_a2/home.dart';
import 'package:myinventory_si_23_a2/edit.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Listkardus extends StatefulWidget {
  const Listkardus({super.key, this.kardus});
  final List<Kardus>? kardus;

  @override
  State<Listkardus> createState() => _ListkardusState();
}

class _ListkardusState extends State<Listkardus> {
  late List<Kardus> daftarKardus;
  late List<XFile?> daftarGambar;

  @override
  void initState() {
    super.initState();
    daftarKardus = widget.kardus ?? [];
    daftarGambar = daftarKardus.map((kardus) => kardus.gambar).toList();
  }

  Future<void> pilihGambar(int index) async {
    final picker = ImagePicker();
    final XFile? gambar = await picker.pickImage(source: ImageSource.gallery);

    if (gambar != null) {
      setState(() {
        daftarGambar[index] = gambar;
        daftarKardus[index].gambar = gambar;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16002F),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 125, 125, 174),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, daftarKardus);
          },
        ),
        title: const Text("List Kardus", style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: daftarKardus.length,
        itemBuilder: (context, index) {
          final kardus = daftarKardus[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () => pilihGambar(index),
                        child: Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                            image: daftarGambar[index] != null
                                ? DecorationImage(
                                    image: FileImage(File(daftarGambar[index]!.path)),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: daftarGambar[index] == null
                              ? Center(
                                  child: Icon(
                                    Icons.photo_camera_back,
                                    size: 60,
                                    color: Colors.grey[700],
                                  ),
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Row(
                          children: [
                            
                            Container(
                              width: 36,
                              height: 36,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.edit, size: 18, color: Colors.black),
                                onPressed: () async {
                                  final hasilEdit = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditKardus(kardus: kardus),
                                    ),
                                  );
                                  if (hasilEdit != null && hasilEdit is Kardus) {
                                    setState(() {
                                      daftarKardus[index] = hasilEdit;
                                    });
                                  }
                                },
                              ),
                            ),
                            
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.delete, size: 18, color: Colors.black),
                                onPressed: () async {
                                  final konfirmasi = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Peringatan !"),
                                      content: const Text("Yakin ingin menghapus kardus ini?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text("Tidak"),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: const Text("Ya"),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (konfirmasi == true) {
                                    setState(() {
                                      daftarKardus.removeAt(index);
                                      daftarGambar.removeAt(index);
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "KATEGORI : ${kardus.kategori.toUpperCase()}",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "DESKRIPSI : ${kardus.deskripsi}",
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "LOKASI : ${kardus.lokasi.toUpperCase()}",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
