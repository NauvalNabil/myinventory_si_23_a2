import 'package:myinventory_si_23_a2/models/itemModel.dart';

class KardusModel {
  final String id;
  final String userId;
  final String kategori;
  final String? deskripsi;
  final String? lokasi;
  final String? gambar;
  final DateTime createdAt;
  final List<ItemModel> isiItem;

  KardusModel({
    required this.id,
    required this.userId,
    required this.kategori,
    this.deskripsi,
    this.lokasi,
    this.gambar,
    required this.createdAt,
    this.isiItem = const [],
  });

  factory KardusModel.fromJson(Map<String, dynamic> json) {
    return KardusModel(
      // PERBAIKAN: Menggunakan .toString() yang aman dan memberikan nilai default
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      kategori: json['kategori']?.toString() ?? 'Tanpa Kategori',
      
      deskripsi: json['deskripsi'] as String?,
      lokasi: json['lokasi'] as String?,
      gambar: json['gambar'] as String?,
      
      // PERBAIKAN: Parsing tanggal yang lebih aman
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
          
      isiItem: (json['isi_item'] as List<dynamic>?)
              ?.map((itemJson) =>
                  ItemModel.fromJson(itemJson as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'kategori': kategori,
        'deskripsi': deskripsi,
        'lokasi': lokasi,
        'gambar': gambar,
        'created_at': createdAt.toIso8601String(),
      };

  KardusModel copyWith({
    String? id,
    String? userId,
    String? kategori,
    String? deskripsi,
    String? lokasi,
    String? gambar,
    DateTime? createdAt,
    List<ItemModel>? isiItem,
  }) {
    return KardusModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      kategori: kategori ?? this.kategori,
      deskripsi: deskripsi ?? this.deskripsi,
      lokasi: lokasi ?? this.lokasi,
      gambar: gambar ?? this.gambar,
      createdAt: createdAt ?? this.createdAt,
      isiItem: isiItem ?? this.isiItem,
    );
  }
}