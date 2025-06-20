import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/chat/chatroom/models/chatroom_model.dart';
import 'package:snapster_app/features/chat/chatroom/repositories/chatroom_repository.dart';
import 'package:snapster_app/features/chat/providers/chat_providers.dart';
import 'package:snapster_app/utils/exception_handlers/base_exception_handler.dart';

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
}

final httpChatroomProvider =
    AsyncNotifierProvider<ChatroomViewModel, List<ChatroomModel>>(
  () => ChatroomViewModel(),
);
