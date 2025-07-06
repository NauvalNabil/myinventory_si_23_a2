import 'package:flutter/material.dart';
import 'package:myinventory_si_23_a2/kartuisi.dart'; 

class TambahItem extends StatefulWidget {
  const TambahItem({super.key});

  @override
  State<TambahItem> createState() => _TambahItemState();
}

class _TambahItemState extends State<TambahItem> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();
  final TextEditingController kondisiController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  @override
  void dispose() {
    namaController.dispose();
    jumlahController.dispose();
    kondisiController.dispose();
    tanggalController.dispose();
    deskripsiController.dispose();
    super.dispose();
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
              buildLabel("NAMA ITEM"),
              buildTextField(namaController),
              buildLabel("JUMLAH"),
              buildTextField(jumlahController, keyboardType: TextInputType.number),
              buildLabel("KONDISI"),
              buildTextField(kondisiController),
              buildLabel("TANGGAL BELI"),
              buildTextField(tanggalController),
              buildLabel("DESKRIPSI"),
              buildTextField(deskripsiController, maxLines: 4),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    if (namaController.text.isEmpty ||
                        jumlahController.text.isEmpty ||
                        kondisiController.text.isEmpty ||
                        tanggalController.text.isEmpty ||
                        deskripsiController.text.isEmpty) {
                      tampilkanPeringatan("Semua kolom harus di isi !");
                      return;
                    }

                    final item = Item(
                      nama: namaController.text,
                      jumlah: int.tryParse(jumlahController.text) ?? 0,
                      kondisi: kondisiController.text,
                      tanggalBeli: tanggalController.text,
                      deskripsi: deskripsiController.text,
                    );

                    Navigator.pop(context, item);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 235, 114, 54),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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

  Widget buildTextField(TextEditingController controller,
      {int maxLines = 1, TextInputType? keyboardType}) {
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
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }
}
