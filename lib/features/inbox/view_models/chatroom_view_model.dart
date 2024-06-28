import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/common_divider.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/inbox/models/chatroom_model.dart';
import 'package:tiktok_clone/features/inbox/models/chatter_model.dart';
import 'package:tiktok_clone/features/inbox/repositories/message_repository.dart';
import 'package:tiktok_clone/features/user/models/user_profile_model.dart';
import 'package:tiktok_clone/features/user/repository/user_repository.dart';
import 'package:tiktok_clone/utils/base_exception_handler.dart';

class ChatroomViewModel extends AsyncNotifier<void> {
  late final MessageRepository _messageRepository;
  late final AuthenticationRepository _authRepository;
  late final UserRepository _userRepository;
  late final User? _user;

  late final ChatroomModel chatroom;

  @override
  FutureOr<void> build() {
    _messageRepository = ref.read(messageRepository);
    _userRepository = ref.read(userRepository);
    _authRepository = ref.read(authRepository);
    _user = _authRepository.user;
  }

  Future<void> createChatroom(
      BuildContext context, UserProfileModel invitee) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      _checkLoginUser(context);

      final myProfile = await _getMyProfile(context);
      if (myProfile.uid.isEmpty) return;

      // 이미 채팅룸 있는지 확인
      if (!context.mounted) return;
      final chatroomExist = await _getChatroom(myProfile.uid, invitee.uid)
          .then((value) => value.isNotEmpty);
      if (chatroomExist) return;

      // 없을 경우 생성
      final chatroomId = '${myProfile.uid}$commonIdDivider${invitee.uid}';
      final chatroomInfo = ChatroomModel(
        chatroomId: chatroomId,
        personA: _getChatterByProfile(myProfile),
        personB: _getChatterByProfile(invitee),
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      final chatroomCreated =
          await _messageRepository.createChatroom(chatroomInfo);
      chatroom = ChatroomModel.fromJson(chatroomCreated.data()!);

      if (state.hasError) {
        if (context.mounted) showFirebaseErrorSnack(context, state.error);
      }
    });
  }

  FutureOr<ChatroomModel?> fetchChatroom(
      BuildContext context, UserProfileModel invitee) async {
    final myProfile = await _getMyProfile(context);
    if (myProfile.uid.isEmpty) return null;

    var chatroom = await _getChatroom(myProfile.uid, invitee.uid);

    if (chatroom.isNotEmpty) {
      return ChatroomModel.fromJson(chatroom.first.data());
    } else {
      if (context.mounted) {
        showCustomErrorSnack(context, 'Chatroom Does Not Exist');
      }
      return null;
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _getChatroom(
      String myId, String inviteeId) async {
    var chatroomId = '$myId$commonIdDivider$inviteeId';
    var chatroom = await _messageRepository.fetchChatroom(chatroomId);

    if (chatroom.docs.isEmpty) {
      // chatroomId 가 person A/B 반대로 생성 되었을 경우도 체크
      chatroomId = '$inviteeId$commonIdDivider$myId';
      chatroom = await _messageRepository.fetchChatroom(chatroomId);
    }

    return chatroom.docs;
  }

  Future<UserProfileModel> _getMyProfile(BuildContext context) async {
    var myProfile = UserProfileModel.empty();

    final json = await _userRepository.findProfile(_user!.uid);
    if (json == null) {
      if (context.mounted) {
        showCustomErrorSnack(context, 'Error: User Does Not Exist');
      }
    } else {
      myProfile = UserProfileModel.fromJson(json);
    }

    return myProfile;
  }

  ChatterModel _getChatterByProfile(UserProfileModel profile) {
    return ChatterModel(
      uid: profile.uid,
      name: profile.name,
      username: profile.username,
      hasAvatar: profile.hasAvatar,
      recentlyReadAt: 0,
      showMsgFrom: 0,
      isParticipating: true,
    );
  }

  void _checkLoginUser(BuildContext context) {
    if (!_authRepository.isLoggedIn) {
      showSessionErrorSnack(context);
    }
  }
}

final chatroomProvider = AsyncNotifierProvider<ChatroomViewModel, void>(
  () => ChatroomViewModel(),
);
