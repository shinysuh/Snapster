import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';
import 'package:tiktok_clone/features/inbox/repositories/chatroom_repository.dart';

class MessageRepository {
  static const String textCollection = 'texts';

  final FirebaseFirestore _database = FirebaseFirestore.instance;

  // send a message
  Future<void> sendMessage(MessageModel message, String chatroomId) async {
    await _database
        .collection(ChatroomRepository.chatroomCollection)
        .doc(chatroomId)
        .collection(textCollection)
        .add(message.toJson());
  }
}

final messageRepository = Provider((ref) => MessageRepository());
