import 'package:flutter/material.dart';
import 'package:myinventory_si_23_a2/home.dart';

class Isikardus extends StatefulWidget {
  final Kardus kardus;
  const Isikardus({super.key, required this.kardus});

  @override
  State<Isikardus> createState() => _IsikardusState();
}

class _IsikardusState extends State<Isikardus> {
  @override
  Widget build(BuildContext context) {
    final kardus = widget.kardus;

    return Scaffold(
      backgroundColor: const Color(0xFF16002F),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 125, 125, 174),
        leading: const BackButton(color: Colors.white),
        title: const Text("Isi Kardus", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            
            Container(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Container(
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
                          Text(
                            kardus.kategori.toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            kardus.deskripsi,
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            kardus.lokasi.toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            
            GestureDetector(
              onTap: () {
                
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
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
