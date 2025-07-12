import 'dart:io';
import 'package:myinventory_si_23_a2/models/itemModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ItemService {
  final SupabaseClient _supabase = Supabase.instance.client;

  String get _currentUserId {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    return user.id;
  }

  // FUNGSI BARU: Upload gambar item ke Supabase Storage
  Future<String> uploadItemImage(File file) async {
    try {
      final String fileName =
          '${_currentUserId}_${DateTime.now().millisecondsSinceEpoch}.${file.path.split('.').last}';
      await _supabase.storage.from('item-images').upload(
            fileName,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      return _supabase.storage.from('item-images').getPublicUrl(fileName);
    } catch (e) {
      throw Exception('Gagal mengunggah gambar item: $e');
    }
  }

  // Create a new item
  Future<ItemModel?> createItem({
    required String nama,
    int? jumlah,
    String? kondisi,
    DateTime? tanggalBeli,
    String? deskripsi,
    String? gambar, // Akan berisi URL
    required String kardusId,
  }) async {
    try {
      final response = await _supabase.from('item').insert({
        'user_id': _currentUserId,
        'nama': nama,
        'jumlah': jumlah,
        'kondisi': kondisi,
        'tanggal_beli': tanggalBeli?.toIso8601String(),
        'deskripsi': deskripsi,
        'gambar': gambar, // Simpan URL
        'kardus_id': kardusId,
      }).select().single();
      return ItemModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create item: $e');
    }
  }

  // Read items by kardusId for the current user
  Future<List<ItemModel>> getItemsByKardusId(String kardusId) async {
    try {
      final response = await _supabase
          .from('item')
          .select()
          .eq('kardus_id', kardusId)
          .eq('user_id', _currentUserId);
      return response.map((json) => ItemModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch items: $e');
    }
  }
  
  // PERBAIKAN: Tambahkan fungsi untuk get item by ID
  Future<ItemModel?> getItemById(String id) async {
     try {
      final response = await _supabase
          .from('item')
          .select()
          .eq('id', id)
          .eq('user_id', _currentUserId)
          .single();
      return ItemModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Update an item for the current user
  Future<void> updateItem(ItemModel item) async {
    try {
      await _supabase
          .from('item')
          .update({
            'nama': item.nama,
            'jumlah': item.jumlah,
            'kondisi': item.kondisi,
            'tanggal_beli': item.tanggalBeli?.toIso8601String(),
            'deskripsi': item.deskripsi,
            'gambar': item.gambar, // Simpan URL
            'kardus_id': item.kardusId,
          })
          .eq('id', item.id)
          .eq('user_id', _currentUserId);
    } catch (e) {
      throw Exception('Failed to update item: $e');
    }
  }

  // Delete an item for the current user
  Future<void> deleteItem(String id) async {
    try {
      // PERBAIKAN: Hapus juga gambar dari storage jika ada
      final itemData = await getItemById(id);
      if (itemData?.gambar != null && itemData!.gambar!.isNotEmpty) {
        final uri = Uri.parse(itemData.gambar!);
        final fileName = uri.pathSegments.last;
        await _supabase.storage.from('item-images').remove([fileName]);
      }

      await _supabase
          .from('item')
          .delete()
          .eq('id', id)
          .eq('user_id', _currentUserId);
    } catch (e) {
      throw Exception('Failed to delete item: $e');
    }
  }
}