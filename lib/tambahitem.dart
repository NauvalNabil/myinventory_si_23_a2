import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myinventory_si_23_a2/services/itemService.dart';

class TambahItem extends StatefulWidget {
  final String kardusId;
  const TambahItem({super.key, required this.kardusId});

  @override
  State<TambahItem> createState() => _TambahItemState();
}

class _TambahItemState extends State<TambahItem> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();
  final TextEditingController kondisiController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  final ItemService _itemService = ItemService();
  bool _isLoading = false;

  File? _gambarFile;
  DateTime? _tanggalBeli;

  @override
  void dispose() {
    namaController.dispose();
    jumlahController.dispose();
    kondisiController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _pilihGambar() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        _gambarFile = File(pickedFile.path);
      });
    }
  }

  // FUNGSI BARU: Untuk menampilkan date picker
  Future<void> _pilihTanggal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalBeli ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _tanggalBeli) {
      setState(() {
        _tanggalBeli = picked;
      });
    }
  }

  void tampilkanPeringatan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 6, 47, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 235, 114, 54),
        leading: const BackButton(color: Colors.white),
        title: const Text("Tambah Item", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PERBAIKAN: Widget untuk memilih gambar
              buildLabel("GAMBAR ITEM (OPSIONAL)"),
              GestureDetector(
                onTap: _pilihGambar,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white54),
                    image:
                        _gambarFile != null
                            ? DecorationImage(
                              image: FileImage(_gambarFile!),
                              fit: BoxFit.cover,
                            )
                            : null,
                  ),
                  child:
                      _gambarFile == null
                          ? const Center(
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.white70,
                              size: 50,
                            ),
                          )
                          : null,
                ),
              ),

              buildLabel("NAMA ITEM"),
              buildTextField(namaController),

              buildLabel("JUMLAH"),
              buildTextField(
                jumlahController,
                keyboardType: TextInputType.number,
              ),

              buildLabel("KONDISI"),
              buildTextField(kondisiController),

              // PERBAIKAN: Widget untuk memilih tanggal
              buildLabel("TANGGAL BELI"),
              GestureDetector(
                onTap: () => _pilihTanggal(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _tanggalBeli == null
                        ? 'Pilih Tanggal'
                        : DateFormat('d MMMM yyyy').format(_tanggalBeli!),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight:
                          _tanggalBeli == null
                              ? FontWeight.normal
                              : FontWeight.bold,
                    ),
                  ),
                ),
              ),

              buildLabel("DESKRIPSI"),
              buildTextField(deskripsiController, maxLines: 4),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.center,
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : ElevatedButton(
                          onPressed: () async {
                            if (namaController.text.isEmpty ||
                                jumlahController.text.isEmpty) {
                              tampilkanPeringatan(
                                "Nama dan Jumlah item harus diisi!",
                              );
                              return;
                            }
                            setState(() => _isLoading = true);

                            try {
                              String? imageUrl;
                              if (_gambarFile != null) {
                                imageUrl = await _itemService.uploadItemImage(
                                  _gambarFile!,
                                );
                              }

                              final newItem = await _itemService.createItem(
                                nama: namaController.text,
                                jumlah:
                                    int.tryParse(jumlahController.text) ?? 0,
                                kondisi:
                                    kondisiController.text.isNotEmpty
                                        ? kondisiController.text
                                        : null,
                                tanggalBeli: _tanggalBeli,
                                deskripsi:
                                    deskripsiController.text.isNotEmpty
                                        ? deskripsiController.text
                                        : null,
                                kardusId: widget.kardusId,
                                gambar: imageUrl,
                              );
                              setState(() => _isLoading = false);
                              if (newItem != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Item berhasil ditambahkan!"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pop(context, newItem);
                              }
                            } catch (e) {
                              setState(() => _isLoading = false);
                              tampilkanPeringatan("Gagal menambahkan item: $e");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              235,
                              114,
                              54,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: const StadiumBorder(),
                            elevation: 2,
                          ),
                          child: const Text(
                            "TAMBAH",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 1,
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

  Widget buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 4),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType? keyboardType,
    String? hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    );
  }
}
