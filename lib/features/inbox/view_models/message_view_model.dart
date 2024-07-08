import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';
import 'package:tiktok_clone/features/inbox/repositories/chatroom_repository.dart';
import 'package:tiktok_clone/features/inbox/repositories/message_repository.dart';
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

  MessageSenderType getMessageSender(BuildContext context, String senderId) {
    _checkLoginUser(context);
    final user = _authRepository.user;
    return senderId == systemId
        ? MessageSenderType.system
        : user!.uid == senderId
            ? MessageSenderType.me
            : MessageSenderType.partner;
  }

  bool isMine(MessageSenderType senderType) {
    return senderType == MessageSenderType.me;
  }

/*
       TODO [3] - extra
        1) (V) 대화 text 중 system 이 보낸 항목 UI 구분하기 ('OOO님이 대화방을 나갔습니다.' 문구) (V)
        **) (V) 내가 생성한 채팅방 아닐 때, 대화 상대 선택 리스트에서 기존 대화 상대 선택 후 채팅방 이동 시, 메세지들 안 보이는 이슈 fix
        **) (V) 상대방이 나간 채팅방에서 다시 메세지 보내면, 다시 상대 초대 여부 컨펌 후 재초대
        2) [XX] recentlyReadAt 으로 [여기까지 읽음] 구현 및 recentlyReadAt 업데이트
        3) [XX] 이전 메세지랑 날짜가 다르면 UI에 날짜 구분 말풍선 표시해주기
        ---
        4) [*2분 내로 보내진 메세지만] 메세지를 꾹(2-3초) 눌렀을 때, 메세지 지우는 컨펌 dialog 후 메세지를 [deleted message] 로 변경하거나 삭제하는 로직 구현
  */

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
        (event) => event.docs
            .map(
              (doc) => MessageModel.fromJson(doc.data()),
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
