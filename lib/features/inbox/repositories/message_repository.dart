import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/MessageModel.dart';

class MessageRepository {
  static const String chatroomCollection = 'chat_rooms';
  static const String textCollection = 'texts';

  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Future<void> sendMessage(MessageModel message, String chatroomId) async {
    await _database
        .collection(chatroomCollection)
        .doc(chatroomId)
        .collection(textCollection)
        .add(message.toJson());
  }
}

final messageRepository = Provider((ref) => MessageRepository());
