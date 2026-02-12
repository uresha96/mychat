import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'message.g.dart';

@HiveType(typeId: 0)
class Message extends HiveObject {
  static final uuid = Uuid();

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String chatId;

  @HiveField(2)
  final String senderId;

  @HiveField(3)
  final String text;

  @HiveField(4)
  final DateTime timestamp;

  @HiveField(5)
  final bool isMine;

  Message({
    String? id,
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isMine,
  }) : id = id ?? uuid.v4();
}
