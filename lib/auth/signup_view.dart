import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychat/auth/auth_controller.dart';
import 'package:mychat/auth/auth_state.dart';
import 'package:mychat/main_background.dart';

import '../custom_widgets.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SignupPageState();
}

class SignupPageState extends ConsumerState<SignupPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated) {
        Navigator.pop(context);
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          MainBackground(),
          Form(
            key: formKey,
            child: Center(
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
                      Image.asset("assets/icons/logo_with_text.png"),
                      const SizedBox(height: 8),
                      const Text(
                        'Create your account',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 32),
                      inputTextField(
                        controller: nameController,
                        icon: Icons.person_outline,
                        hint: 'Name',
                      ),
                      const SizedBox(height: 16),
                      inputTextField(
                        controller: emailController,
                        icon: Icons.email_outlined,
                        hint: 'Email',
                      ),
                      const SizedBox(height: 16),
                      inputTextField(
                        controller: passwordController,
                        icon: Icons.lock_outline,
                        hint: 'Password',
                        obscure: true,
                      ),
                      const SizedBox(height: 24),
                      button(auth.isLoading, "Sign up", () {
                        signup();
                      }),
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
          ),
        ],
      ),
    );
  }

  void signup() {
    if (formKey.currentState!.validate()) {
      ref.read(authProvider.notifier).signup(
          email: emailController.text,
          password: passwordController.text,
          username: nameController.text);
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
