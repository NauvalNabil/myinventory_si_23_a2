import 'dart:io';
import 'package:myinventory_si_23_a2/models/kardusModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KardusService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Mendapatkan ID pengguna saat ini
  String get _currentUserId {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    return user.id;
  }

  // FUNGSI BARU: Upload gambar ke Supabase Storage
  Future<String> uploadKardusImage(File file) async {
    try {
      final String fileName =
          '${_currentUserId}_${DateTime.now().millisecondsSinceEpoch}.${file.path.split('.').last}';
      await _supabase.storage.from('kardus-images').upload(
            fileName,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      return _supabase.storage.from('kardus-images').getPublicUrl(fileName);
    } catch (e) {
      throw Exception('Gagal mengunggah gambar kardus: $e');
    }
  }

  // Create a new kardus
  Future<KardusModel?> createKardus({
    required String kategori,
    String? deskripsi,
    String? lokasi,
    String? gambar, // Tetap String untuk menampung URL
  }) async {
    try {
      final response = await _supabase.from('kardus').insert({
        'user_id': _currentUserId,
        'kategori': kategori,
        'deskripsi': deskripsi,
        'lokasi': lokasi,
        'gambar': gambar, // Simpan URL gambar
      }).select().single();
      return KardusModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create kardus: $e');
    }
  }

  // Read all kardus for the current user
  Future<List<KardusModel>> getAllKardus() async {
    try {
      final response = await _supabase
          .from('kardus')
          .select()
          .eq('user_id', _currentUserId);
      return response.map((json) => KardusModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch kardus: $e');
    }
  }

  // Read a single kardus by id for the current user
  Future<KardusModel?> getKardusById(String id) async {
    try {
      final response = await _supabase
          .from('kardus')
          .select()
          .eq('id', id)
          .eq('user_id', _currentUserId)
          .single();
      return KardusModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch kardus: $e');
    }
  }

  // Update a kardus for the current user
  Future<void> updateKardus(KardusModel kardus) async {
    try {
      await _supabase
          .from('kardus')
          .update({
            'kategori': kardus.kategori,
            'deskripsi': kardus.deskripsi,
            'lokasi': kardus.lokasi,
            'gambar': kardus.gambar, // Simpan URL gambar
          })
          .eq('id', kardus.id)
          .eq('user_id', _currentUserId);
    } catch (e) {
      throw Exception('Failed to update kardus: $e');
    }
  }

  // Delete a kardus for the current user
  Future<void> deleteKardus(String id) async {
    try {
      // PERBAIKAN: Hapus juga gambar dari storage jika ada
      final kardusData = await getKardusById(id);
      if (kardusData?.gambar != null && kardusData!.gambar!.isNotEmpty) {
        final uri = Uri.parse(kardusData.gambar!);
        final fileName = uri.pathSegments.last;
        await _supabase.storage.from('kardus-images').remove([fileName]);
      }

      await _supabase
          .from('kardus')
          .delete()
          .eq('id', id)
          .eq('user_id', _currentUserId);
    } catch (e) {
      throw Exception('Failed to delete kardus: $e');
    }
  }
}