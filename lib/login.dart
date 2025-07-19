import 'package:flutter/material.dart';
import 'package:myinventory_si_23_a2/services/authServices.dart';
import 'package:myinventory_si_23_a2/daftar.dart';
import 'package:myinventory_si_23_a2/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  
  Future<void> _login() async {
    
    FocusScope.of(context).unfocus();

    
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email dan password harus diisi!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    
    try {
      final user = await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      
      if (mounted && user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => HomeScreen(
                  username: user.username ?? '',
                  email: user.email,
                ),
          ),
        );
      }
    } catch (e) {
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email atau password salah!'),
            backgroundColor: Colors.red,
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 6, 47, 1.0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 250,
                height: 250,
                margin: const EdgeInsets.only(bottom: 40),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Myinventory_Logo.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'email',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFDB6A3E)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF7B54)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFDB6A3E)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF7B54)),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color(0xFFDB6A3E),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed:
                      _isLoading ? null : _login, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDB6A3E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                          : const Text(
                            'LOGIN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Belum punya akun? ',
                    style: TextStyle(color: Colors.white70),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Daftar()),
                      );
                    },
                    child: const Text(
                      'Daftar sekarang',
                      style: TextStyle(
                        color: Color(0xFFDB6A3E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
