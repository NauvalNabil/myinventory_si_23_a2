import 'package:flutter/material.dart';
import 'package:myinventory_si_23_a2/services/kardusService.dart';

class Buatkardus extends StatefulWidget {
  const Buatkardus({super.key});

  @override
  State<Buatkardus> createState() => _BuatkardusState();
}

class _BuatkardusState extends State<Buatkardus> {
  final TextEditingController kategoriController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();

  final KardusService _kardusService = KardusService();
  bool _isLoading = false;

  @override
  void dispose() {
    kategoriController.dispose();
    deskripsiController.dispose();
    lokasiController.dispose();
    super.dispose();
  }

  Future<void> _createKardus() async {
    if (kategoriController.text.isEmpty ||
        deskripsiController.text.isEmpty ||
        lokasiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text("Semua kolom harus diisi!"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      print('Mencoba membuat kardus dengan: '
          'kategori: ${kategoriController.text}, '
          'deskripsi: ${deskripsiController.text}, '
          'lokasi: ${lokasiController.text}');

      await _kardusService.createKardus(
        kategori: kategoriController.text,
        deskripsi: deskripsiController.text,
        lokasi: lokasiController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text("Kardus berhasil dibuat!"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      Navigator.pop(context); // Kembali ke HomeScreen
    } catch (e) {
      print('Error saat membuat kardus: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal membuat kardus: $e"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 64, 67, 93),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Buat Kardus",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 235, 114, 54),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildLabel("KATEGORI"),
            const SizedBox(height: 10),
            _buildTextField(controller: kategoriController, maxLines: 1),
            const SizedBox(height: 10),
            _buildLabel("DESKRIPSI"),
            const SizedBox(height: 10),
            _buildTextField(controller: deskripsiController, maxLines: null),
            const SizedBox(height: 10),
            _buildLabel("LOKASI"),
            const SizedBox(height: 10),
            _buildTextField(controller: lokasiController, maxLines: null),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 235, 114, 54),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    onPressed: _createKardus,
                    child: const Text(
                      "BUAT",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    int? maxLines,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}