import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:snapster_app/features/authentication/renewal/providers/token_storage_provider.dart';
import 'package:snapster_app/features/authentication/renewal/services/token_storage_service.dart';
import 'package:snapster_app/features/chat/chatroom/models/chatroom_model.dart';
import 'package:snapster_app/features/chat/chatroom/repositories/chatroom_repository.dart';
import 'package:snapster_app/features/chat/message/repositories/chat_message_repository.dart';
import 'package:snapster_app/features/chat/participant/models/chatroom_participant_id_model.dart';
import 'package:snapster_app/features/chat/participant/models/chatroom_participant_model.dart';
import 'package:snapster_app/features/chat/providers/chat_providers.dart';
import 'package:snapster_app/features/chat/views/test_chat_detail_screen.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/utils/exception_handlers/base_exception_handler.dart';
import 'package:snapster_app/utils/navigator_redirection.dart';

class ChatroomViewModel extends AsyncNotifier<List<ChatroomModel>> {
  late final ChatroomRepository _chatroomRepository;

  @override
  FutureOr<List<ChatroomModel>> build() async {
    _chatroomRepository = ref.read(chatroomRepositoryProvider);
    final data = await getAllChatroomsByUser();
    return data;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final newData = await getAllChatroomsByUser();
      state = AsyncValue.data(newData);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<List<ChatroomModel>> getAllChatroomsByUser() async {
    return await runFutureWithExceptionLogs<List<ChatroomModel>>(
      errorPrefix: '채팅방 목록 조회',
      requestFunction: () async => _chatroomRepository.getAllChatroomsByUser(),
      fallback: [],
    );
  }

  Future<ChatroomModel> getOneChatroom({
    required BuildContext context,
    required int chatroomId,
  }) async {
    return await runFutureWithExceptionHandler<ChatroomModel>(
      context: context,
      errorPrefix: '채팅방 상세 조회',
      requestFunction: () async =>
          _chatroomRepository.getOneChatroom(chatroomId),
      fallback: ChatroomModel.empty(),
    );
  }

  Future<void> enterOneOnOneChatroom({
    required BuildContext context,
    required AppUser sender,
    required AppUser receiver,
  }) async {
    final receiverId = int.parse(receiver.userId);
    ChatroomModel chatroom = await runFutureWithExceptionHandler<ChatroomModel>(
      context: context,
      errorPrefix: '1:1 채팅방 조회',
      requestFunction: () async =>
          _chatroomRepository.getIfOneOnOneChatroomExists(receiverId),
      fallback: ChatroomModel.empty(),
    );

    // 빈 채팅방 (생성 전)
    if (chatroom.id == 0 &&
        chatroom.participants.isEmpty &&
        chatroom.messages.isEmpty) {
      chatroom = _getChatroomPreview(sender, receiver);
    }

    if (context.mounted) {
      _enterChatroom(
        context: context,
        chatroom: chatroom,
      );
    }
  }

  ChatroomModel _getChatroomPreview(AppUser sender, AppUser receiver) {
    return ChatroomModel.empty().copyWith(
      participants: [
        ChatroomParticipantModel(
          user: sender,
          id: ChatroomParticipantIdModel(
            chatroomId: 0,
            userId: int.parse(sender.userId),
          ),
        ),
        ChatroomParticipantModel(
          user: receiver,
          id: ChatroomParticipantIdModel(
            chatroomId: 0,
            userId: int.parse(receiver.userId),
          ),
        ),
      ],
    );
  }

  // 채팅방 입장
  void _enterChatroom({
    required BuildContext context,
    required ChatroomModel chatroom,
  }) {
    context.pop();
    goToRouteNamed(
      context: context,
      routeName: TestChatDetailScreen.routeName,
      params: {'chatroomId': chatroom.id.toString()},
      extra: chatroom,
    );
  }

  // 채팅방 나가기
  Future<void> exitChatroom({
    required BuildContext context,
    required List<ChatroomModel> chatroomList,
    required ChatroomModel chatroom,
  }) async {
    final success = await runFutureWithExceptionHandler<bool>(
      context: context,
      errorPrefix: '채팅방 나가기',
      requestFunction: () async =>
          _chatroomRepository.leaveChatroom(chatroom.id),
      fallback: false,
    );

    if (!success) return;
    // remove 작업 후 프론트 객체도 리스트에서 제거
    chatroomList.remove(chatroom);
  }
}

final httpChatroomProvider =
    AsyncNotifierProvider<ChatroomViewModel, List<ChatroomModel>>(
  () => ChatroomViewModel(),
);
