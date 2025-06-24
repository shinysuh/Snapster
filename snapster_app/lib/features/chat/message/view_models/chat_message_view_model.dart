import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/chat/chatroom/models/chatroom_model.dart';
import 'package:snapster_app/features/chat/message/models/chat_message_model.dart';
import 'package:snapster_app/features/chat/message/repositories/chat_message_repository.dart';
import 'package:snapster_app/features/chat/providers/chat_providers.dart';
import 'package:uuid/uuid.dart';

class ChatMessageViewModel
    extends FamilyNotifier<List<ChatMessageModel>, ChatroomModel> {
  late final ChatMessageRepository _messageRepository;
  late final ChatroomModel _chatroom;

  final _uuid = const Uuid();

  @override
  List<ChatMessageModel> build(ChatroomModel arg) {
    _messageRepository = ref.watch(chatMessageRepositoryProvider);
    _chatroom = arg;

    // 초기 메시지 리스트 (DB)
    state = List.of(_chatroom.messages);

    // 2) STOMP 브로드캐스트 구독 등록
    subscribeChatroom();

    return state;
  }

  void sendMessageToRoom({
    required BuildContext context,
    required int senderId,
    int? receiverId,
    required String content,
    required String type, // MessageType: text, emoji, image
  }) {
    final message = ChatMessageModel(
      id: 0,
      chatroomId: _chatroom.id,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      type: type,
      isDeleted: false,
      clientMessageId: _uuid.v4(),
      createdAt: 0,
    );

    _messageRepository.sendMessage(message);
  }

  void subscribeChatroom() {
    _messageRepository.subscribeToChatroom(
      _chatroom.id,
      (data) {
        final msg = ChatMessageModel.fromJson(data);
        state = [...state, msg];
      },
    );
  }

  void leaveRoom() {
    _messageRepository.unsubscribeFromChatroom(_chatroom.id);
  }
}

final chatMessageProvider = NotifierProvider.family<ChatMessageViewModel,
    List<ChatMessageModel>, ChatroomModel>(
  ChatMessageViewModel.new,
);
