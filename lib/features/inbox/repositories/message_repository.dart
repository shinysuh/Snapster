import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/chatroom_model.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';

class MessageRepository {
  static const String chatroomCollection = 'chat_rooms';
  static const String textCollection = 'texts';

  final FirebaseFirestore _database = FirebaseFirestore.instance;

  // send a message
  Future<void> sendMessage(MessageModel message, String chatroomId) async {
    await _database
        .collection(chatroomCollection)
        .doc(chatroomId)
        .collection(textCollection)
        .add(message.toJson());
  }

  // create a chatroom
  Future<DocumentSnapshot<Map<String, dynamic>>> createChatroom(
      ChatroomModel chatroom) async {
    final chatroomCreated =
        await _database.collection(chatroomCollection).add(chatroom.toJson());
    return chatroomCreated.get();
  }

  // fetch a chatroom
  Future<QuerySnapshot<Map<String, dynamic>>> fetchChatroom(
      String chatroomId) async {
    return await _database
        .collection(chatroomCollection)
        .where('chatroomId', isEqualTo: chatroomId)
        .get();
  }
}

final messageRepository = Provider((ref) => MessageRepository());
