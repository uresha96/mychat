import 'package:flutter/material.dart';
import 'package:mychat/main_background.dart';
import 'package:mychat/signup_view.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MainBackground(),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 100.0,
                ),
                Image.asset(
                  "assets/icons/mychat_logo_transparent.png",
                  scale: 3.0,
                ),
                SizedBox(
                  height: 32,
                ),
                getInputField(
                  "Email",
                  false,
                  true,
                  Icons.email,
                ),
                getInputField(
                  "Password",
                  true,
                  false,
                  Icons.lock,
                ),
                ElevatedButton(
                  onPressed: () {},
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
          )
        ],
      ),
    );
  }

  getInputField(String hintText, bool obscure, bool autoFocus, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
      child: TextField(
        obscureText: obscure,
        autofocus: autoFocus,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
        ),
      ),
    );
  }
}
