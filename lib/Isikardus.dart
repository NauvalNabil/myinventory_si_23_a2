import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myinventory_si_23_a2/edititem.dart';
import 'package:myinventory_si_23_a2/models/itemModel.dart';
import 'package:myinventory_si_23_a2/models/kardusModel.dart';
import 'package:myinventory_si_23_a2/services/itemService.dart';
import 'package:myinventory_si_23_a2/tambahitem.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Isikardus extends StatefulWidget {
  final KardusModel kardus;
  const Isikardus({super.key, required this.kardus});

  @override
  State<Isikardus> createState() => _IsikardusState();
}

class _IsikardusState extends State<Isikardus> {
  late List<ItemModel> daftarItem = [];
  final ItemService _itemService = ItemService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final items = await _itemService.getItemsByKardusId(widget.kardus.id);
      if (mounted) {
        setState(() {
          daftarItem = items;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Gagal memuat item: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> hapusItem(int index) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromRGBO(0, 6, 47, 1.0),
        title: const Text("Konfirmasi Hapus",
            style: TextStyle(color: Colors.white)),
        content: const Text("Yakin ingin menghapus item ini?",
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Tidak", style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Ya", style: TextStyle(color: Color(0xFFD65A38))),
          ),
        ],
      ),
    );

    if (konfirmasi == true) {
      try {
        await _itemService.deleteItem(daftarItem[index].id);
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Item berhasil dihapus!"),
                backgroundColor: Colors.green),
          );
        }
        _loadItems();
      } catch (e) {
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Gagal menghapus item: $e"),
                backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final kardus = widget.kardus;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 6, 47, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 125, 125, 174),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Isi Kardus", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // =================================================================
            // PERBAIKAN: Menambahkan kembali kartu informasi kardus yang hilang
            // =================================================================
            Container(
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
                      image: kardus.gambar != null && kardus.gambar!.isNotEmpty
                          ? DecorationImage(
                              image: CachedNetworkImageProvider(kardus.gambar!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: kardus.gambar == null || kardus.gambar!.isEmpty
                        ? const Icon(Icons.folder_copy,
                            size: 40, color: Colors.white)
                        : null,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(kardus.kategori.toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(kardus.deskripsi?.toUpperCase() ?? '',
                            style: const TextStyle(fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(kardus.lokasi?.toUpperCase() ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                final hasil = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TambahItem(kardusId: widget.kardus.id)),
                );
                if (hasil != null && hasil is ItemModel) {
                  _loadItems();
                }
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
                  children: [Icon(Icons.add, color: Colors.white, size: 40)],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white))
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 8),
                      itemCount: daftarItem.length,
                      itemBuilder: (context, index) {
                        final item = daftarItem[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(10),
                                        image: item.gambar != null && item.gambar!.isNotEmpty
                                            ? DecorationImage(
                                                image: CachedNetworkImageProvider(item.gambar!),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                      child: item.gambar == null || item.gambar!.isEmpty
                                          ? Center(
                                              child: Icon(
                                                Icons.inventory_2_outlined,
                                                size: 60,
                                                color: Colors.grey[700],
                                              ),
                                            )
                                          : null,
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Row(
                                        children: [
                                          buildCircleButton(Icons.edit, () async {
                                            final hasilEdit = await Navigator.push<ItemModel>(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditItem(item: item),
                                              ),
                                            );
                                            if (hasilEdit != null) {
                                              _loadItems();
                                            }
                                          }),
                                          buildCircleButton(Icons.delete, () => hapusItem(index)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                buildInfoText("NAMA ITEM", item.nama.toUpperCase()),
                                buildInfoText("DESKRIPSI", item.deskripsi ?? '-'),
                                buildInfoText("JUMLAH", (item.jumlah ?? 0).toString()),
                                buildInfoText("KONDISI", item.kondisi ?? '-'),
                                if (item.tanggalBeli != null)
                                  buildInfoText(
                                    "TANGGAL BELI",
                                    DateFormat('d MMMM yyyy').format(item.tanggalBeli!),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCircleButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 36,
      height: 36,
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 18, color: Colors.black87),
        onPressed: onPressed,
      ),
    );
  }

  Widget buildInfoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 14),
          children: [
            TextSpan(
              text: "$label : ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}