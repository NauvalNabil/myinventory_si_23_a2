import 'package:flutter/material.dart';
import 'package:myinventory_si_23_a2/models/kardusModel.dart';
import 'package:myinventory_si_23_a2/services/kardusService.dart'; // Import service untuk update

class EditKardus extends StatefulWidget {
  final KardusModel kardus;

  const EditKardus({super.key, required this.kardus});

  @override
  State<EditKardus> createState() => _EditKardusState();
}

class _EditKardusState extends State<EditKardus> {
  late TextEditingController kategoriController;
  late TextEditingController deskripsiController;
  late TextEditingController lokasiController;

  final KardusService _kardusService = KardusService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    kategoriController = TextEditingController(text: widget.kardus.kategori);
    deskripsiController = TextEditingController(text: widget.kardus.deskripsi);
    lokasiController = TextEditingController(text: widget.kardus.lokasi);
  }

  @override
  void dispose() {
    kategoriController.dispose();
    deskripsiController.dispose();
    lokasiController.dispose();
    super.dispose();
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, int? maxLines}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(255, 255, 255, 255),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        hintStyle: TextStyle(color: Colors.white54),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 6, 47, 1.0),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Edit Kardus", style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 235, 114, 54),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildLabel("KATEGORI"),
            _buildTextField(controller: kategoriController, maxLines: 1),
            SizedBox(height: 10),
            _buildLabel("DESKRIPSI"),
            _buildTextField(controller: deskripsiController, maxLines: null),
            SizedBox(height: 10),
            _buildLabel("LOKASI"),
            _buildTextField(controller: lokasiController, maxLines: null),
            SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 235, 114, 54),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    onPressed: () async {
                      setState(() => _isLoading = true);
                      // Gunakan copyWith untuk mempertahankan ID dan field lain yang tidak diubah
                      final updatedKardus = widget.kardus.copyWith(
                        kategori: kategoriController.text,
                        deskripsi: deskripsiController.text,
                        lokasi: lokasiController.text,
                      );
                      try {
                        await _kardusService.updateKardus(updatedKardus);
                        setState(() => _isLoading = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Kardus berhasil disimpan!"), backgroundColor: Colors.green),
                        );
                        Navigator.pop(context, updatedKardus);
                      } catch (e) {
                        setState(() => _isLoading = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Gagal menyimpan: $e"), backgroundColor: Colors.red),
                        );
                      }
                    },
                    child: Text("SIMPAN", style: TextStyle(color: Colors.white)),
                  ),
          ],
        ),
      ),
    );
  }
}