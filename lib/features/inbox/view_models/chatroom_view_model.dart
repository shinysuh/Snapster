import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/common_divider.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/inbox/models/chat_partner_model.dart';
import 'package:tiktok_clone/features/inbox/models/chatroom_model.dart';
import 'package:tiktok_clone/features/inbox/models/chatter_model.dart';
import 'package:tiktok_clone/features/inbox/repositories/chatroom_repository.dart';
import 'package:tiktok_clone/features/inbox/view_models/message_view_model.dart';
import 'package:tiktok_clone/features/inbox/views/chat_detail_screen.dart';
import 'package:tiktok_clone/features/user/models/user_profile_model.dart';
import 'package:tiktok_clone/features/user/repository/user_repository.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/utils/base_exception_handler.dart';
import 'package:tiktok_clone/utils/navigator_redirection.dart';

class ChatroomViewModel extends AsyncNotifier<void> {
  late final ChatroomRepository _chatroomRepository;
  late final AuthenticationRepository _authRepository;
  late final UserRepository _userRepository;
  late final User? _user;

  late final ChatroomModel chatroom;

  @override
  FutureOr<void> build() {
    _chatroomRepository = ref.read(chatroomRepository);
    _userRepository = ref.read(userRepository);
    _authRepository = ref.read(authRepository);
    _user = _authRepository.user;
  }

  // 채팅방 생성
  Future<void> createChatroom(
      BuildContext context, UserProfileModel invitee) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      _checkLoginUser(context);

      final myProfile = await _getMyProfile(context);
      if (myProfile.uid.isEmpty) return;

      final chatroomId = '${myProfile.uid}$commonIdDivider${invitee.uid}';
      final inviteeAsChatter = _getChatterByProfile(invitee);
      final now = DateTime.now().millisecondsSinceEpoch;

      // 이미 채팅룸 있는지 확인
      final checkedChatroom = await _getChatroom(myProfile.uid, invitee.uid);
      final chatroomExist = checkedChatroom.isNotEmpty;

      // 이미 있으면 해당 채팅방으로 이동
      if (chatroomExist) {
        final oldChatroom =
            ChatroomModel.fromJson(checkedChatroom.first.data());
        if (context.mounted) {
          _enterChatroom(
            context: context,
            chatroomId: oldChatroom.chatroomId,
            invitee: inviteeAsChatter,
            now: now,
          );
        }
      } else {
        // 없을 경우 생성
        final chatroomInfo = ChatroomModel(
          chatroomId: chatroomId,
          personA: _getChatterByProfile(myProfile),
          personB: inviteeAsChatter,
          createdAt: now,
          updatedAt: now,
        );

        await _chatroomRepository.createChatroom(chatroomInfo);
        chatroom = chatroomInfo;

        if (state.hasError) {
          if (context.mounted) showFirebaseErrorSnack(context, state.error);
        } else {
          // 채팅방으로 이동
          if (context.mounted) {
            _enterChatroom(
              context: context,
              chatroomId: chatroomId,
              invitee: inviteeAsChatter,
              now: now,
            );
          }
        }
      }
    });
  }

  // 전체 유저 리스트 가져오기 (로그인 유저 제외)
  Future<List<UserProfileModel>> fetchAllOtherUsers() async {
    final result = await _userRepository.fetchAllUsers();
    List<UserProfileModel> users = [];

    for (var doc in result.docs) {
      final user = UserProfileModel.fromJson(doc.data());
      if (user.uid != _user!.uid) users.add(user);
    }

    return users;
  }

  // 채팅방 정보 가져오기
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

  // 채팅방 나가기
  Future<void> exitChatroom(
      BuildContext context, ChatPartnerModel chatroomInfo) async {
    _checkLoginUser(context);
    final profile = await _getMyProfile(context);
    if (profile.uid.isEmpty) return;

    // user 컬렉션에서도 제거 필요 - index.ts

    if (!chatroomInfo.chatPartner.isParticipating) {
      // 사용자 둘 다 나가기 시, 채팅방 정보 삭제
      await _chatroomRepository.deleteChatroom(chatroomInfo.chatroomId);
    } else {
      // 한 명만 나가기 시, 채팅방 정보 업데이트
      var myChatterProfile = _getChatterByProfile(profile);

      int now = DateTime.now().millisecondsSinceEpoch;
      // isParticipating = false;
      myChatterProfile = myChatterProfile.copyWith(
        isParticipating: false,
        recentlyReadAt: now, // 채팅방 나가면 읽음으로 표시됨
        showMsgFrom: now + 1,
      );

      // personA / personB 중 나 구분 후 정보 넘기기 - chatroomId 에서 앞에 오면 personA
      bool amIPersonA =
          chatroomInfo.chatroomId.startsWith(myChatterProfile.uid);

      ChatroomModel updatedChatroom = ChatroomModel(
        chatroomId: chatroomInfo.chatroomId,
        personA: amIPersonA ? myChatterProfile : chatroomInfo.chatPartner,
        personB: amIPersonA ? chatroomInfo.chatPartner : myChatterProfile,
        updatedAt: now,
      );

      // chatroom 정보 업데이트
      await _chatroomRepository.updateChatroom(updatedChatroom);
      // 시스템 메세지 추가 (방 나감 메세지)
      if (context.mounted) {
        await ref
            .read(messageProvider(chatroomInfo.chatroomId).notifier)
            .sendSystemMessage(
              context: context,
              text:
                  S.of(context).userHasLeftChatroom(myChatterProfile.username),
              createdAt: now,
            );
      }
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _getChatroom(
      String myId, String inviteeId) async {
    var chatroomId = '$myId$commonIdDivider$inviteeId';
    var chatroom = await _chatroomRepository.fetchChatroom(chatroomId);

    if (chatroom.docs.isEmpty) {
      // chatroomId 가 person A/B 반대로 생성 되었을 경우도 체크
      chatroomId = '$inviteeId$commonIdDivider$myId';
      chatroom = await _chatroomRepository.fetchChatroom(chatroomId);
    }

    return chatroom.docs;
  }

  // 채팅방으로 이동
  void _enterChatroom({
    required BuildContext context,
    required String chatroomId,
    required ChatterModel invitee,
    required int now,
  }) {
    context.pop();
    goToRouteNamed(
      context: context,
      routeName: ChatDetailScreen.routeName,
      params: {'chatroomId': chatroomId},
      extra: ChatPartnerModel(
        chatroomId: chatroomId,
        chatPartner: invitee,
        updatedAt: now,
      ),
    );
  }

  // 로그인 유저 피로필 fetch
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

  // 유저 프로필 ChatterModel 로 형병환
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

  // 로그인 여부 체크
  void _checkLoginUser(BuildContext context) {
    if (!_authRepository.isLoggedIn) {
      showSessionErrorSnack(context);
    }
  }
}

final chatroomProvider = AsyncNotifierProvider<ChatroomViewModel, void>(
  () => ChatroomViewModel(),
);

// Stream 은 변화가 바로 반영됨 (watch)
final chatroomListProvider =
    StreamProvider.autoDispose<List<ChatPartnerModel>>((ref) {
  final user = ref.read(authRepository).user;
  final database = FirebaseFirestore.instance;
  return database
      .collection('users')
      .doc(user!.uid)
      .collection('chat_rooms')
      .orderBy('updatedAt')
      .snapshots()
      .map(
        (event) => event.docs
            .map(
              (doc) => ChatPartnerModel.fromJson(doc.data()),
            )
            .toList()
            .reversed
            .toList(),
      );
});
