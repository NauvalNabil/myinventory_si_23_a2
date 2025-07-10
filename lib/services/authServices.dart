
// File: services/auth_service.dart
import 'package:myinventory_si_23_a2/models/userModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Register user
  Future<UserModel?> register({
    required String email,
    required String password,
    String? username,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: username != null ? {'username': username} : null,
      );

      if (response.user != null) {
        // Setelah register, langsung login
        final loginResponse = await _supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
        if (loginResponse.user != null) {
          return UserModel(
            id: loginResponse.user!.id,
            email: loginResponse.user!.email!,
            username: username,
          );
        } else {
          throw Exception('Login otomatis gagal setelah registrasi.');
        }
      }
      return null;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Login user
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return UserModel.fromJson({
          'id': response.user!.id,
          'email': response.user!.email,
          'user_metadata': response.user!.userMetadata,
        });
      }
      return null;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Logout user
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  // Get current user
  UserModel? getCurrentUser() {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      return UserModel.fromJson({
        'id': user.id,
        'email': user.email,
        'user_metadata': user.userMetadata,
      });
    }
    return null;
  }
}
