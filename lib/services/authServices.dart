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
      print('🔄 Starting registration...');
      print('📧 Email: $email');
      print('👤 Username: $username');

      final response = await _supabase.auth
          .signUp(
            email: email,
            password: password,
            data: username != null ? {'username': username} : null,
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception(
                'Network timeout - registration failed. Check your internet connection.',
              );
            },
          );

      print('📋 Registration response: ${response.user?.id}');
      print('🔐 Session available: ${response.session != null}');

      if (response.user != null) {
        // Jika email confirmation disabled, user langsung aktif
        if (response.session != null) {
          print('✅ Registration successful with session');
          return UserModel(
            id: response.user!.id,
            email: response.user!.email!,
            username: username,
          );
        } else {
          print(
            '⚠️ Registration successful but no session (email confirmation required)',
          );
          // Coba login manual jika session tidak ada
          await Future.delayed(Duration(milliseconds: 500));
          return await login(email: email, password: password);
        }
      } else {
        print('❌ Registration failed - no user returned');
        throw Exception('Registration failed - no user created');
      }
    } on AuthException catch (e) {
      print('🚨 Auth Exception: ${e.message}');
      if (e.message.contains('Failed host lookup') ||
          e.message.contains('SocketException')) {
        throw Exception(
          'Network connection failed. Please check your internet connection and try again.',
        );
      }
      throw Exception('Registration failed: ${e.message}');
    } catch (e) {
      print('💥 General Exception: $e');
      if (e.toString().contains('timeout') ||
          e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup')) {
        throw Exception(
          'Network connection timeout. Please check your internet connection and try again.',
        );
      }
      throw Exception('Registration failed: $e');
    }
  }

  // Login user
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 Attempting login for: $email');

      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      print('📋 Login response: ${response.user?.id}');
      print('🔐 Session: ${response.session != null}');

      if (response.user != null) {
        return UserModel.fromJson({
          'id': response.user!.id,
          'email': response.user!.email,
          'user_metadata': response.user!.userMetadata,
        });
      }
      return null;
    } on AuthException catch (e) {
      print('🚨 Login Auth Exception: ${e.message}');
      throw Exception('Login failed: ${e.message}');
    } catch (e) {
      print('💥 Login General Exception: $e');
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
