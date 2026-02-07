import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychat/models/chat.dart';

class ChatListController extends StateNotifier<List<Chat>> {
  ChatListController() : super([]) {
    loadInitial();
  }

  void loadInitial() {
    // TODO: vom Backend holen
    state = [
      Chat(
        id: "1",
        name: "Buntu",
        avatar:
            "https://static.vecteezy.com/system/resources/previews/005/346/410/non_2x/close-up-portrait-of-smiling-handsome-young-caucasian-man-face-looking-at-camera-on-isolated-light-gray-studio-background-photo.jpg",
      ),
      Chat(
        id: "2",
        name: "amma",
        avatar:
            "https://i.ds.at/qTka4Q/rs:fill:750:0/plain/2018/11/16/14FEMALEPLEASURE-1.jpg",
      )
    ];
  }
}

final chatListProvider = StateNotifierProvider<ChatListController, List<Chat>>(
  (ref) => ChatListController(),
);
