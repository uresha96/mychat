import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychat/auth/auth_controller.dart';
import 'package:mychat/auth/auth_state.dart';
import 'package:mychat/chat/chat_list_page.dart';
import 'package:mychat/main_background.dart';
import 'package:mychat/auth/signup_view.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => LoginViewState();
}

class LoginViewState extends ConsumerState<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.successfullyLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ChatList()),
        );
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          MainBackground(),
          Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 100.0),
              child: Column(
                children: [
                  Image.asset(
                    "assets/icons/mychat_logo_transparent.png",
                    scale: 3.0,
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  getInputField(
                    emailController,
                    "Email",
                    false,
                    true,
                    Icons.email,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  getInputField(
                    passwordController,
                    "Password",
                    true,
                    false,
                    Icons.lock,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => ChatList(),
                          ),
                        );
                      }
                    },
                    child: Text("Log In"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    child: Text("Don't have an account? Sign Up :)"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => SignupPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  getInputField(TextEditingController controller, String hintText, bool obscure,
      bool autoFocus, IconData icon) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      autofocus: autoFocus,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xFFF4F5F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (v) => v!.isEmpty ? 'Bitte ausfüllen' : null,
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
