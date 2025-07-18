import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/constants/message_types.dart';
import 'package:snapster_app/features/chat/chatroom/models/chatroom_model.dart';
import 'package:snapster_app/features/chat/message/models/chat_message_model.dart';
import 'package:snapster_app/features/chat/message/repositories/chat_message_repository.dart';
import 'package:snapster_app/features/chat/participant/models/chatroom_participant_model.dart';
import 'package:snapster_app/features/chat/providers/chat_providers.dart';
import 'package:snapster_app/generated/l10n.dart';
import 'package:snapster_app/utils/exception_handlers/base_exception_handler.dart';
import 'package:snapster_app/utils/exception_handlers/error_snack_bar.dart';

class ChatMessageViewModel extends FamilyAsyncNotifier<void, int> {
  late final ChatMessageRepository _messageRepository;
  late final int _chatroomId;

  @override
  FutureOr<void> build(int arg) async {
    _messageRepository = ref.read(chatMessageRepositoryProvider);
    _chatroomId = arg;
  }

  Future<List<ChatMessageModel>> getMessagesByChatroom(
    BuildContext context,
  ) async {
    return await runFutureWithExceptionHandler<List<ChatMessageModel>>(
      context: context,
      errorPrefix: '채팅방 전체 메시지 조회',
      requestFunction: () async =>
          _messageRepository.getAllMessagesByChatroom(_chatroomId),
      fallback: [],
    );
  }

  Future<ChatMessageModel> getRecentMessageByChatroom({
    required BuildContext context,
    required ChatroomModel chatroom,
  }) async {
    return await runFutureWithExceptionHandler<ChatMessageModel>(
      context: context,
      errorPrefix: '채팅방 최근 메시지 조회',
      requestFunction: () async =>
          _messageRepository.getRecentMessageByChatroom(chatroom),
      fallback: ChatMessageModel.empty(),
    );
  }

  Future<ChatMessageModel?> updateMessageToDeleted({
    required BuildContext context,
    required ChatroomParticipantModel currentUser,
    required ChatMessageModel message,
  }) async {
    // validate sender
    if (_validateSender(
      context: context,
      currentUser: currentUser,
      message: message,
    )) {
      return null;
    }

    return await runFutureWithExceptionHandler<ChatMessageModel>(
      context: context,
      errorPrefix: '메시지 삭제 처리',
      requestFunction: () async =>
          _messageRepository.updateMessageToDeleted(message),
      fallback: ChatMessageModel.empty(),
    );
  }

  bool _validateSender({
    required BuildContext context,
    required ChatroomParticipantModel currentUser,
    required ChatMessageModel message,
  }) {
    final isValid = currentUser.id.userId == message.senderId;
    if (!isValid) {
      showCustomErrorSnack(
        context,
        S.of(context).youCanOnlyDeleteTheMessagesYouSent,
      );
    }
    return isValid;
  }

  String getSenderType(int currentUserId, ChatMessageModel message) {
    if (message.type == MessageType.typeSystem) {
      return SenderType.senderSystem;
    }

    if (currentUserId == message.senderId) {
      return SenderType.senderMe;
    }

    return SenderType.senderOther;
  }
}

final chatMessageProvider =
    AsyncNotifierProvider.family<ChatMessageViewModel, void, int>(
  ChatMessageViewModel.new,
);
