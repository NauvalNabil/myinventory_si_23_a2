import 'package:image_picker/image_picker.dart';

class Item {
  String nama;
  int jumlah;
  String kondisi;
  String tanggalBeli;
  String deskripsi;
  XFile? gambar;

  Item({
    required this.nama,
    required this.jumlah,
    required this.kondisi,
    required this.tanggalBeli,
    required this.deskripsi,
    this.gambar,
  });
}