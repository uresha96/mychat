import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychat/auth/auth_controller.dart';
import 'package:mychat/chat/chat_list_controller.dart';
import 'package:mychat/custom_widgets.dart';

class AddChatDialog extends ConsumerStatefulWidget {
  const AddChatDialog({super.key});

  @override
  ConsumerState<AddChatDialog> createState() => AddChatDialogState();
}

class AddChatDialogState extends ConsumerState<AddChatDialog> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              spacing: 12.0,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Chat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                inputTextField(
                    controller: nameController,
                    icon: Icons.person_outline,
                    hint: 'Name'),
                inputTextField(
                    controller: emailController,
                    icon: Icons.email_outlined,
                    hint: 'Email'),
                button(isLoading, 'Create', createChat),
              ],
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: const Icon(Icons.close),
              splashRadius: 20,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> createChat() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();

    if (name.isEmpty || email.isEmpty) return;
    setState(() => isLoading = true);

    await ref
        .read(chatListProvider.notifier)
        .addNewChat(name: name, email: email);

    if (!mounted) return;
    Navigator.pop(context);
  }
}
