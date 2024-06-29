import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/chatroom_model.dart';

class ChatroomRepository {
  static const String chatroomCollection = 'chat_rooms';

  final FirebaseFirestore _database = FirebaseFirestore.instance;

  // create a chatroom
  Future<DocumentSnapshot<Map<String, dynamic>>> createChatroom(
      ChatroomModel chatroom) async {
    final chatroomCreated = await _database
        .collection(ChatroomRepository.chatroomCollection)
        .add(chatroom.toJson());
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

final chatroomRepository = Provider((ref) => ChatroomRepository());
