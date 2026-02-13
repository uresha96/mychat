import 'package:flutter/material.dart';
import 'package:mychat/custom_widgets.dart';
import 'package:mychat/main_background.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          MainBackground(),
          Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 100.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 35,
                ),
                const CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person, size: 40),
                ),
                const SizedBox(height: 40),
                inputTextField(controller: nameController, hint: 'Name'),
                const SizedBox(height: 12),
                inputTextField(controller: emailController, hint: 'Email'),
                const Spacer(),
                SafeArea(
                  child: button(
                    false,
                    'Save',
                    () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
