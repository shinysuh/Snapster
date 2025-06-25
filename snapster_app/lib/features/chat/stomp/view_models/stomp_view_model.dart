import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/chat/chatroom/models/chatroom_model.dart';
import 'package:snapster_app/features/chat/message/models/chat_message_model.dart';
import 'package:snapster_app/features/chat/providers/chat_providers.dart';
import 'package:snapster_app/features/chat/stomp/repositories/stomp_repository.dart';
import 'package:uuid/uuid.dart';

class StompViewModel
    extends FamilyNotifier<List<ChatMessageModel>, ChatroomModel> {
  late final StompRepository _stompRepository;
  late final ChatroomModel _chatroom;

  final _uuid = const Uuid();

  @override
  List<ChatMessageModel> build(ChatroomModel arg) {
    _stompRepository = ref.watch(stompRepositoryProvider);
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

    _stompRepository.sendMessage(message);
  }

  void subscribeChatroom() {
    _stompRepository.subscribeToChatroom(
      _chatroom.id,
      (data) {
        final msg = ChatMessageModel.fromJson(data);
        state = [...state, msg];
      },
    );
  }

  void leaveRoom() {
    _stompRepository.unsubscribeFromChatroom(_chatroom.id);
  }
}

final stompProvider = NotifierProvider.family<StompViewModel,
    List<ChatMessageModel>, ChatroomModel>(
  StompViewModel.new,
);
