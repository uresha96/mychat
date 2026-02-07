import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychat/auth/auth_controller.dart';
import 'package:mychat/auth/auth_state.dart';
import 'package:mychat/chat/chat_list_page.dart';
import 'package:mychat/main_background.dart';
import 'package:mychat/auth/signup_view.dart';

import '../custom_widgets.dart';

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
    final auth = ref.watch(authProvider);

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
                  inputTextField(
                    controller: emailController,
                    hint: "Email",
                    icon: Icons.email,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  inputTextField(
                    controller: passwordController,
                    icon: Icons.lock,
                    hint: "Password",
                    obscure: true,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  button(auth.isLoading, "Log In", () {
                    login();
                  }),
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

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() {
    if (formKey.currentState!.validate()) {
      ref.read(authProvider.notifier).login(
          email: emailController.text, password: passwordController.text);
    }
  }
}
