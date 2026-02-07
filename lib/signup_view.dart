import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychat/auth/auth_controller.dart';
import 'package:mychat/main_background.dart';

class SignupPage extends ConsumerWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final emailController = TextEditingController();
    final nameController = TextEditingController();
    final passwordController = TextEditingController();

    if (auth.isAuthenticated) {
      Navigator.pop(context);
    }

    return Scaffold(
      body: Stack(
        children: [
          MainBackground(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/icons/mchat.png"),
                    const SizedBox(height: 8),
                    const Text(
                      'Create your account',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    inputField(
                      controller: nameController,
                      icon: Icons.person_outline,
                      hint: 'Name',
                    ),
                    const SizedBox(height: 16),
                    inputField(
                      controller: emailController,
                      icon: Icons.email_outlined,
                      hint: 'Email',
                    ),
                    const SizedBox(height: 16),
                    inputField(
                      controller: passwordController,
                      icon: Icons.lock_outline,
                      hint: 'Password',
                      obscure: true,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: auth.isLoading
                            ? null
                            : () {
                                ref.read(authProvider.notifier).signup(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    username: nameController.text);
                              },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: auth.isLoading
                            ? const CircularProgressIndicator()
                            : Ink(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF4FACFE),
                                      Color(0xFFB721FF),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Sign up',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Already have an account? Log in',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget inputField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xFFF4F5F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
