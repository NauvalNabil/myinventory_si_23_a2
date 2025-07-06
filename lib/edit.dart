import 'package:flutter/material.dart';
import 'package:myinventory_si_23_a2/home.dart';

class EditKardus extends StatefulWidget {
  final Kardus kardus;
  

  const EditKardus({super.key, required this.kardus});

  @override
  State<EditKardus> createState() => _EditKardusState();
}

class _EditKardusState extends State<EditKardus> {
  late TextEditingController kategoriController;
  late TextEditingController deskripsiController;
  late TextEditingController lokasiController;

  @override
  void initState(){
    super.initState();
    kategoriController = TextEditingController(text: widget.kardus.kategori);
    deskripsiController = TextEditingController(text: widget.kardus.deskripsi);
    lokasiController = TextEditingController(text: widget.kardus.lokasi);
  }
  @override
  void dispose(){
    kategoriController.dispose();
    deskripsiController.dispose();
    lokasiController.dispose();
    super.dispose();
  }

  Widget _buildLabel(String text){
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
  Widget build(BuildContext content) {
    return Scaffold(
      backgroundColor: const Color(0xFF16002F),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Edit Kerdus", style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(225, 125, 125, 174),
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown.shade300,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () {
                final updatedKardus = Kardus(
                  kategori: kategoriController.text,
                  deskripsi: deskripsiController.text,
                  lokasi: lokasiController.text,
                );
                Navigator.pop(context, updatedKardus);
              },
              child: Text("SIMPAN",style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

}