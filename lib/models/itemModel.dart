class ItemModel {
  final String id;
  final String userId;
  final String nama;
  final int? jumlah;
  final String? kondisi;
  final DateTime? tanggalBeli;
  final String? deskripsi;
  final String? gambar;
  final String kardusId;
  final DateTime createdAt;

  ItemModel({
    required this.id,
    required this.userId,
    required this.nama,
    this.jumlah,
    this.kondisi,
    this.tanggalBeli,
    this.deskripsi,
    this.gambar,
    required this.kardusId,
    required this.createdAt,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      // PERBAIKAN: Menggunakan .toString() yang aman dan memberikan nilai default
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      nama: json['nama']?.toString() ?? 'Tanpa Nama',
      
      jumlah: json['jumlah'] as int?,
      kondisi: json['kondisi'] as String?,
      
      // PERBAIKAN: Parsing tanggal yang lebih aman
      tanggalBeli: json['tanggal_beli'] != null
          ? DateTime.parse(json['tanggal_beli'].toString())
          : null,
          
      deskripsi: json['deskripsi'] as String?,
      gambar: json['gambar'] as String?,
      
      kardusId: json['kardus_id']?.toString() ?? '',
      
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'nama': nama,
        'jumlah': jumlah,
        'kondisi': kondisi,
        'tanggal_beli': tanggalBeli?.toIso8601String(),
        'deskripsi': deskripsi,
        'gambar': gambar,
        'kardus_id': kardusId,
        'created_at': createdAt.toIso8601String(),
      };

  ItemModel copyWith({
    String? id,
    String? userId,
    String? nama,
    int? jumlah,
    String? kondisi,
    DateTime? tanggalBeli,
    String? deskripsi,
    String? gambar,
    String? kardusId,
    DateTime? createdAt,
  }) {
    return ItemModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nama: nama ?? this.nama,
      jumlah: jumlah ?? this.jumlah,
      kondisi: kondisi ?? this.kondisi,
      tanggalBeli: tanggalBeli ?? this.tanggalBeli,
      deskripsi: deskripsi ?? this.deskripsi,
      gambar: gambar ?? this.gambar,
      kardusId: kardusId ?? this.kardusId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}