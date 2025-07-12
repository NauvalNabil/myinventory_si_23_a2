import 'package:flutter/material.dart';
import 'package:myinventory_si_23_a2/models/itemModel.dart';
import 'package:myinventory_si_23_a2/services/itemService.dart';

class EditItem extends StatefulWidget {
  final ItemModel item;

  const EditItem({super.key, required this.item});

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  late TextEditingController namaController;
  late TextEditingController jumlahController;
  late TextEditingController kondisiController;
  late TextEditingController tanggalController;
  late TextEditingController deskripsiController;

  final ItemService _itemService = ItemService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.item.nama);
    jumlahController = TextEditingController(text: widget.item.jumlah.toString());
    kondisiController = TextEditingController(text: widget.item.kondisi);
    tanggalController = TextEditingController(text: widget.item.tanggalBeli?.toIso8601String().split('T')[0] ?? '');
    deskripsiController = TextEditingController(text: widget.item.deskripsi);
  }

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
        title: const Text("Edit Item", style: TextStyle(color: Colors.white)),
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
              buildLabel("TANGGAL BELI (YYYY-MM-DD)"),
              buildTextField(tanggalController, hintText: "Contoh: 2024-12-31"),
              buildLabel("DESKRIPSI"),
              buildTextField(deskripsiController, maxLines: 4),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.center,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : ElevatedButton(
                        onPressed: () async {
                          if (namaController.text.isEmpty ||
                              jumlahController.text.isEmpty) {
                            tampilkanPeringatan("Semua kolom harus diisi!");
                            return;
                          }

                          setState(() => _isLoading = true);

                          final updatedItem = widget.item.copyWith(
                            nama: namaController.text,
                            jumlah: int.tryParse(jumlahController.text) ?? 0,
                            kondisi: kondisiController.text,
                            tanggalBeli: DateTime.tryParse(tanggalController.text),
                            deskripsi: deskripsiController.text,
                          );

                          try {
                            await _itemService.updateItem(updatedItem);
                            setState(() => _isLoading = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Item berhasil disimpan!"), backgroundColor: Colors.green),
                            );
                            Navigator.pop(context, updatedItem);
                          } catch (e) {
                            setState(() => _isLoading = false);
                            tampilkanPeringatan("Gagal menyimpan item: $e");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 235, 114, 54),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: const StadiumBorder(),
                          elevation: 2,
                        ),
                        child: const Text(
                          "SIMPAN",
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
      {int maxLines = 1, TextInputType? keyboardType, String? hintText}) {
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