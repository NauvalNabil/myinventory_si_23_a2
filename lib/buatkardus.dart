import 'package:flutter/material.dart';

class Buatkardus extends StatefulWidget {
  const Buatkardus({super.key});

  @override
  State<Buatkardus> createState() => _BuatkardusState();
}

class _BuatkardusState extends State<Buatkardus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(style: TextStyle(color: Colors.white),"Buat Kardus"),
        backgroundColor: Color.fromARGB(255, 125, 125, 174),
      ),
    );
  }
}