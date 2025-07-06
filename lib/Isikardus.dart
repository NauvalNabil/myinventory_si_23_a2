import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myinventory_si_23_a2/edititem.dart';
import 'package:myinventory_si_23_a2/home.dart';
import 'package:myinventory_si_23_a2/kartuisi.dart';
import 'package:myinventory_si_23_a2/tambahitem.dart';

class Isikardus extends StatefulWidget {
  final Kardus kardus;
  const Isikardus({super.key, required this.kardus});

  @override
  State<Isikardus> createState() => _IsikardusState();
}

class _IsikardusState extends State<Isikardus> {
  List<Item> daftarItem = [];

  @override
  void initState() {
    super.initState();
    daftarItem = List<Item>.from(widget.kardus.isiItem);
  }

  void tambahItemBaru(Item item) {
    setState(() {
      daftarItem.add(item);
      widget.kardus.isiItem = daftarItem;
    });
  }

  Future<void> hapusItem(int index) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Peringatan !"),
        content: const Text("Yakin ingin menghapus item ini?"),
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
        daftarItem.removeAt(index);
        widget.kardus.isiItem = daftarItem;
      });
    }
  }

  Future<void> pilihGambarUntukItem(int index) async {
    final picker = ImagePicker();
    final gambar = await picker.pickImage(source: ImageSource.gallery);
    if (gambar != null) {
      setState(() {
        daftarItem[index].gambar = gambar;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final kardus = widget.kardus;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 6, 47, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 125, 125, 174),
        leading: IconButton(
  icon: const Icon(Icons.arrow_back, color: Colors.white),
  onPressed: () {
    widget.kardus.isiItem = daftarItem; 
    Navigator.pop(context, widget.kardus);
  },
),
        title: const Text("Isi Kardus", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 125, 125, 174),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.folder_copy, size: 40, color: Colors.white),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(kardus.kategori.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(kardus.deskripsi, style: const TextStyle(fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(kardus.lokasi.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                final hasil = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TambahItem()),
                );
                if (hasil != null && hasil is Item) {
                  tambahItemBaru(hasil);
                }
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 235, 114, 54),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.add, color: Colors.white, size: 40)],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: daftarItem.length,
                itemBuilder: (context, index) {
                  final item = daftarItem[index];
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
                                onTap: () => pilihGambarUntukItem(index),
                                child: Container(
                                  height: 150,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                    image: item.gambar != null
                                        ? DecorationImage(
                                            image: FileImage(File(item.gambar!.path)),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: item.gambar == null
                                      ? Center(
                                          child: Icon(
                                            Icons.photo_camera_back,
                                            size: 50,
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
                                    buildCircleButton(Icons.edit, () async {
                                      final hasilEdit = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditItem(item: daftarItem[index]),
                                        ),
                                      );
                                      if (hasilEdit != null && hasilEdit is Item) {
                                        setState(() {
                                          daftarItem[index] = hasilEdit;
                                          widget.kardus.isiItem = daftarItem;
                                        });
                                      }
                                    }),
                                    const SizedBox(width: 8),
                                    buildCircleButton(Icons.delete, () => hapusItem(index)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text("NAMA ITEM : ${item.nama}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text("JUMLAH : ${item.jumlah}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text("KONDISI : ${item.kondisi}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text("TANGGAL BELI : ${item.tanggalBeli}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text("DESKRIPSI : ${item.deskripsi}", style: const TextStyle(fontWeight: FontWeight.bold)),
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

  Widget buildCircleButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 18, color: Colors.black),
        onPressed: onPressed,
      ),
    );
  }
}
