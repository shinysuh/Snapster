import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/chatroom_model.dart';

class ChatroomRepository {
  static const String chatroomCollection = 'chat_rooms';
  static const String chatroomIdField = 'chatroomId';

  final FirebaseFirestore _database = FirebaseFirestore.instance;

  // create a chatroom
  Future<void> createChatroom(ChatroomModel chatroom) async {
    await _database
        .collection(ChatroomRepository.chatroomCollection)
        .doc(chatroom.chatroomId)
        .set(chatroom.toJson());
  }

  // fetch a chatroom
  Future<QuerySnapshot<Map<String, dynamic>>> fetchChatroom(
      String chatroomId) async {
    return await _database
        .collection(chatroomCollection)
        .where(chatroomIdField, isEqualTo: chatroomId)
        .get();
  }
}

final chatroomRepository = Provider((ref) => ChatroomRepository());
