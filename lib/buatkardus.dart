import 'package:flutter/material.dart';
import 'package:myinventory_si_23_a2/home.dart';

class Buatkardus extends StatefulWidget {
  const Buatkardus({super.key});

  @override
  State<Buatkardus> createState() => _BuatkardusState();
}

class _BuatkardusState extends State<Buatkardus> {

  final TextEditingController kategoriController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();

  String? hasilKategori;
  String? hasilDeskripsi;
  String? hasilLokasi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16002F),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(style: TextStyle(color: Colors.white),"Buat Kardus"),
        backgroundColor: Color.fromARGB(255, 235, 114, 54),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildLabel("KATEGORI"),
            SizedBox(height: 10),
            _buildTextField(controller: kategoriController, maxLines:1),
            SizedBox(height: 10),
            _buildLabel("DESKRIPSI"),
            SizedBox(height: 10),
            _buildTextField(controller: deskripsiController, maxLines: null),
            SizedBox(height: 10),
            _buildLabel("LOKASI"),
            SizedBox(height: 10),
            _buildTextField(controller: lokasiController, maxLines: null),
             SizedBox(height: 20),


            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 235, 114, 54),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () {
                if (kategoriController.text.isEmpty ||
                    deskripsiController.text.isEmpty ||
                    lokasiController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Semua kolom harus di isi !"),
                          backgroundColor: Colors.red, 
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                      return;  
                    }
              

                final newKardus = Kardus(
                  kategori: kategoriController.text,
                  deskripsi: deskripsiController.text,
                  lokasi: lokasiController.text
                );
                Navigator.pop(context, newKardus);
              },
              child: Text("BUAT", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            
          ],
        ),
      ),
        
   
      








    );
  }
}

Widget _buildLabel(String text) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: TextStyle(
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