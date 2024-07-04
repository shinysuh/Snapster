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
import 'package:tiktok_clone/features/inbox/views/chat_detail_screen.dart';
import 'package:tiktok_clone/features/user/models/user_profile_model.dart';
import 'package:tiktok_clone/features/user/repository/user_repository.dart';
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
      final now = DateTime.now().millisecondsSinceEpoch;

      final inviteeAsChatter = _getChatterByProfile(invitee);
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
        if (context.mounted) {
          context.pop();
          goToRouteNamed(
            context: context,
            routeName: ChatDetailScreen.routeName,
            params: {'chatroomId': chatroomId},
            extra: ChatPartnerModel(
              chatroomId: chatroomId,
              chatPartner: inviteeAsChatter,
              updatedAt: now,
            ),
          );
        }
      }
    });
  }

  Future<List<UserProfileModel>> fetchAllUsers() async {
    final result = await _userRepository.fetchAllUsers();
    final users = result.docs.map((doc) {
      return UserProfileModel.fromJson(doc.data());
      // final user = UserProfileModel.fromJson(doc.data());
      // return ChatterModel.fromJson({
      //   'uid': user.uid,
      //   'name': user.name,
      //   'username': user.username,
      //   'hasAvatar': user.hasAvatar,
      //   'isParticipating': false,
      //   'recentlyReadAt': 0,
      //   'showMsgFrom': 0,
      // });
    }).toList();
    return users;
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
    var chatroom = await _chatroomRepository.fetchChatroom(chatroomId);

    if (chatroom.docs.isEmpty) {
      // chatroomId 가 person A/B 반대로 생성 되었을 경우도 체크
      chatroomId = '$inviteeId$commonIdDivider$myId';
      chatroom = await _chatroomRepository.fetchChatroom(chatroomId);
    }

    return chatroom.docs;
  }

  /*
      TODO [1] - 대화방
       1) Chatroom 생성 기능 -> personA (방 생성자) / personB (초대된 사람)  (V)
           >>> onChatroomCreated 클라우드함수 사용해서 -> user 하위에 chat_rooms - chatroomId 랑 autoId 랑 상대chatter 정보 저장 (V)
       2) + 클릭 시, 사용자 목록 선택하게 하기 (기존 대화방 있는 상대 선택 시, 해당 대화방으로 이동)
       ---
       3) 대화방 생성 후 바로 대화방으로 이동 - 리스트는 알아서 fetch 되도록 함
       4) 목록에 내가 참여하는 대화방 리스트 뿌려주기 (isParticipating=true)

   */

  Future<void> getChatPartners(String chatroomId) async {}

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
