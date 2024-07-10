import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';
import 'package:tiktok_clone/features/inbox/repositories/chatroom_repository.dart';
import 'package:tiktok_clone/features/inbox/repositories/message_repository.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/utils/base_exception_handler.dart';

enum MessageSenderType { me, partner, system }

class MessageViewModel extends FamilyAsyncNotifier<void, String> {
  static const String systemId = 'system_message';

  late final MessageRepository _messageRepository;
  late final AuthenticationRepository _authRepository;

  late final User? _user;
  late final String _chatroomId;

  @override
  FutureOr<void> build(String arg) {
    _chatroomId = arg;
    _messageRepository = ref.read(messageRepository);
    _authRepository = ref.read(authRepository);
    _user = _authRepository.user;
  }

  Future<void> sendMessage(BuildContext context, String text) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      _checkLoginUser(context);
      // final user = _authRepository.user;
      // final user = ref.read(authRepository).user;

      final message = MessageModel(
        text: text,
        userId: _user!.uid,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      await _messageRepository.sendMessage(message, _chatroomId);

      if (state.hasError) {
        if (context.mounted) showFirebaseErrorSnack(context, state.error);
      }
    });
  }

  Future<void> sendSystemMessage({
    required BuildContext context,
    required String text,
    required int createdAt,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final systemMessage = MessageModel(
        text: text,
        userId: systemId,
        createdAt: createdAt,
      );

      await _messageRepository.sendMessage(systemMessage, _chatroomId);

      if (state.hasError) {
        if (context.mounted) showFirebaseErrorSnack(context, state.error);
      }
    });
  }

  Future<void> updateMessageToDeleted(
    BuildContext context,
    MessageModel message,
  ) async {
    if (message.textId == null) return;
    final isMine = _isMine(getMessageSender(context, message.userId));

    // 본인이 보낸 메세지 아니면 삭제 불가
    if (!isMine) {
      showCustomErrorSnack(
        context,
        S.of(context).youCanOnlyDeleteTheMessagesYouSent,
      );
      return;
    }

    const String deleteMessage = '[Deleted message]';
    // final deleteMessage = '[삭제 된 메세지입니다]';
    _messageRepository.updateMessage(
      chatroomId: _chatroomId,
      messageId: message.textId!,
      message: message.copyWith(text: deleteMessage),
    );
  }

  MessageSenderType getMessageSender(BuildContext context, String senderId) {
    _checkLoginUser(context);
    final user = _authRepository.user;
    return senderId == systemId
        ? MessageSenderType.system
        : user!.uid == senderId
            ? MessageSenderType.me
            : MessageSenderType.partner;
  }

  bool _isMine(MessageSenderType senderType) {
    return senderType == MessageSenderType.me;
  }

  void _checkLoginUser(BuildContext context) {
    if (!_authRepository.isLoggedIn) {
      showSessionErrorSnack(context);
    }
  }
}

final messageProvider =
    AsyncNotifierProvider.family<MessageViewModel, void, String>(
  () => MessageViewModel(),
);

// Stream 은 변화가 바로 반영됨 (watch)
// autoDispose => 채팅방을 떠나면 dispose 됨 (resources can be released when no longer needed)
final chatProvider = StreamProvider.autoDispose
    .family<List<MessageModel>, String>((ref, chatroomId) {
  final database = FirebaseFirestore.instance;
  return database
      .collection(ChatroomRepository.chatroomCollection)
      .doc(chatroomId)
      .collection(MessageRepository.textCollection)
      .orderBy('createdAt')
      .snapshots() // snapshot 은 스트림을 리턴함
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) {
                return MessageModel.fromJson({
                  'textId': doc.id,
                  'text': doc.data()['text'],
                  'userId': doc.data()['userId'],
                  'createdAt': doc.data()['createdAt'],
                });
              },
            )
            .toList()
            .reversed
            .toList(),
      );
});

// latest message for chatroom list page
final lastMessageProvider =
    StreamProvider.autoDispose.family<MessageModel?, String>((ref, chatroomId) {
  return FirebaseFirestore.instance
      .collection(ChatroomRepository.chatroomCollection)
      .doc(chatroomId)
      .collection(MessageRepository.textCollection)
      .orderBy('createdAt', descending: true)
      .limit(1)
      .snapshots()
      .map((snapshot) => snapshot.docs.isNotEmpty
          ? MessageModel.fromJson(snapshot.docs.first.data())
          : null);
});
