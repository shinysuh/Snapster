import 'package:snapster_app/features/chat/chatroom/models/chatroom_model.dart';
import 'package:snapster_app/features/chat/message/models/chat_message_model.dart';
import 'package:snapster_app/features/chat/message/services/chat_message_service.dart';

class ChatMessageRepository {
  final ChatMessageService _chatMessageService;

  ChatMessageRepository(this._chatMessageService);

  Future<List<ChatMessageModel>> getAllMessagesByChatroom(
    int chatroomId,
  ) async {
    return _chatMessageService.fetchAllMessagesByChatroom(chatroomId);
  }

  Future<ChatMessageModel> getRecentMessageByChatroom(
    ChatroomModel chatroom,
  ) async {
    return _chatMessageService.fetchRecentMessageByChatroom(chatroom);
  }

  Future<ChatMessageModel> updateMessageToDeleted(
    ChatMessageModel message,
  ) async {
    return _chatMessageService.updateMessageToDeleted(message);
  }
}
