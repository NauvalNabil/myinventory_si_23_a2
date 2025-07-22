import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myinventory_si_23_a2/edit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myinventory_si_23_a2/models/kardusModel.dart';
import 'package:myinventory_si_23_a2/services/kardusService.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Listkardus extends StatefulWidget {
  const Listkardus({super.key, required this.kardus});
  final List<KardusModel> kardus;

  @override
  State<Listkardus> createState() => _ListkardusState();
}

class _ListkardusState extends State<Listkardus> {
  late List<KardusModel> daftarKardus;
  final KardusService _kardusService = KardusService();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    daftarKardus = List<KardusModel>.from(widget.kardus);
  }

  Future<void> pilihGambar(int index) async {
    final picker = ImagePicker();
    final XFile? gambar = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (gambar != null) {
      setState(() => _isUploading = true);
      try {
        final file = File(gambar.path);
        final imageUrl = await _kardusService.uploadKardusImage(file);
        final updatedKardus = daftarKardus[index].copyWith(gambar: imageUrl);
        await _kardusService.updateKardus(updatedKardus);
        if (mounted) {
          setState(() {
            daftarKardus[index] = updatedKardus;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Gagal mengunggah gambar: $e"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isUploading = false);
        }
      }
    }
  }

  // =================================================================
  // PERBAIKAN: Mengembalikan logika fungsi hapusKardus yang hilang
  // =================================================================
  Future<void> hapusKardus(int index) async {
    final kardus = daftarKardus[index];
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color.fromRGBO(0, 6, 47, 1.0),
            title: const Text(
              "Konfirmasi Hapus",
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              "Yakin ingin menghapus kardus ini? Semua item di dalamnya juga akan terhapus.",
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  "Tidak",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  "Ya",
                  style: TextStyle(color: Color(0xFFD65A38)),
                ),
              ),
            ],
          ),
    );

    if (konfirmasi == true) {
      try {
        await _kardusService.deleteKardus(kardus.id);
        if (mounted) {
          setState(() {
            daftarKardus.removeAt(index);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Kardus berhasil dihapus!"),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Gagal menghapus kardus: $e"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Widget buildCircleButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 36,
      height: 36,
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 18, color: Colors.black87),
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 6, 47, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 235, 114, 54),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, daftarKardus);
          },
        ),
        title: const Text("List Kardus", style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          ListView.builder(
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
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                                image:
                                    kardus.gambar != null &&
                                            kardus.gambar!.isNotEmpty
                                        ? DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            kardus.gambar!,
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                        : null,
                              ),
                              child:
                                  kardus.gambar == null ||
                                          kardus.gambar!.isEmpty
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
                            top: 8,
                            right: 8,
                            child: Row(
                              children: [
                                buildCircleButton(Icons.edit, () async {
                                  final hasilEdit =
                                      await Navigator.push<KardusModel>(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  EditKardus(kardus: kardus),
                                        ),
                                      );
                                  if (hasilEdit != null) {
                                    setState(() {
                                      daftarKardus[index] = hasilEdit;
                                    });
                                  }
                                }),
                                buildCircleButton(
                                  Icons.delete,
                                  () => hapusKardus(index),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "KATEGORI : ${kardus.kategori.toUpperCase()}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "DESKRIPSI : ${kardus.deskripsi ?? ''}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "LOKASI : ${(kardus.lokasi ?? '').toUpperCase()}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (_isUploading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      "Mengunggah...",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
