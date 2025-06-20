import 'package:snapster_app/features/chat/chatroom/models/chatroom_model.dart';
import 'package:snapster_app/features/chat/chatroom/services/chatroom_service.dart';

class ChatroomRepository {
  final ChatroomService _chatroomService;

  ChatroomRepository(this._chatroomService);

  Future<List<ChatroomModel>> getAllChatroomsByUser() async {
    return await _chatroomService.fetchAllChatroomsByUser();
  }

  Future<ChatroomModel> getOneChatroom(int chatroomId) async {
    return await _chatroomService.fetchOneChatroom(chatroomId);
  }

  Future<ChatroomModel> getIfOneOnOneChatroomExists(int receiverId) async {
    return await _chatroomService.fetchIfOneOnOneChatroomExists(receiverId);
  }
}
