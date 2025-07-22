import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myinventory_si_23_a2/home.dart';
import 'package:myinventory_si_23_a2/services/authServices.dart';

class Daftar extends StatefulWidget {
  const Daftar({super.key});

  @override
  State<Daftar> createState() => _DaftarState();
}

//hhebjed
class _DaftarState extends State<Daftar> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00042D),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                TextField(
                  controller: usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'User Name',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFDB6A3E)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFFF7B54),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFDB6A3E)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFFF7B54),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: !_isPasswordVisible,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFDB6A3E)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFFF7B54),
                        width: 2,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: const Color(0xFFDB6A3E),
                        size: 24,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      splashRadius: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child:
                      _isLoading
                          ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFDB6A3E),
                            ),
                          )
                          : ElevatedButton(
                            onPressed: () async {
                              // Validasi input
                              if (usernameController.text.isEmpty ||
                                  emailController.text.isEmpty ||
                                  passwordController.text.isEmpty) {
                                Get.snackbar(
                                  'Error',
                                  'Semua field harus diisi',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                                return;
                              }

                              if (passwordController.text.length < 6) {
                                Get.snackbar(
                                  'Error',
                                  'Password minimal 6 karakter',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                                return;
                              }

                            
                              if (!GetUtils.isEmail(
                                emailController.text.trim(),
                              )) {
                                Get.snackbar(
                                  'Error',
                                  'Format email tidak valid',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                                return;
                              }

                              setState(() => _isLoading = true);

                              try {
                                print('🚀 Starting registration process...');

                                final user = await _authService.register(
                                  email: emailController.text.trim(),
                                  password: passwordController.text,
                                  username: usernameController.text.trim(),
                                );

                                setState(() => _isLoading = false);

                                if (user != null) {
                                  print('✅ Registration successful!');
                                  Get.snackbar(
                                    'Sukses',
                                    'Registrasi berhasil! Selamat datang ${user.username}',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );

                                
                                  Get.offAll(
                                    () => HomeScreen(
                                      username: user.username ?? '',
                                      email: user.email,
                                    ),
                                  );
                                } else {
                                  print('❌ Registration returned null user');
                                  Get.snackbar(
                                    'Error',
                                    'Registrasi gagal. User tidak dibuat.',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              } catch (e) {
                                setState(() => _isLoading = false);
                                print('💥 Registration error: $e');

                                String errorMessage = 'Registrasi gagal';
                                if (e.toString().contains(
                                  'already registered',
                                )) {
                                  errorMessage = 'Email sudah terdaftar';
                                } else if (e.toString().contains(
                                  'weak password',
                                )) {
                                  errorMessage = 'Password terlalu lemah';
                                } else if (e.toString().contains(
                                  'invalid email',
                                )) {
                                  errorMessage = 'Format email tidak valid';
                                }

                                Get.snackbar(
                                  'Error',
                                  '$errorMessage: ${e.toString()}',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  duration: Duration(seconds: 5),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDB6A3E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text(
                              'DAFTAR',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sudah punya akun? ',
                      style: TextStyle(color: Colors.white70),
                    ),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        'Login sekarang',
                        style: TextStyle(
                          color: Color(0xFFDB6A3E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
