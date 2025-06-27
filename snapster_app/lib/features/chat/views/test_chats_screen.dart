import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:snapster_app/constants/breakpoints.dart';
import 'package:snapster_app/constants/gaps.dart';
import 'package:snapster_app/constants/message_types.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/authentication/renewal/providers/auth_status_provider.dart';
import 'package:snapster_app/features/chat/chatroom/models/chatroom_model.dart';
import 'package:snapster_app/features/chat/chatroom/view_models/chatroom_view_model.dart';
import 'package:snapster_app/features/chat/views/test_chat_detail_screen.dart';
import 'package:snapster_app/features/chat/views/test_chatroom_user_list_screen.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/generated/l10n.dart';
import 'package:snapster_app/utils/navigator_redirection.dart';
import 'package:snapster_app/utils/profile_network_img.dart';
import 'package:snapster_app/utils/system_message.dart';
import 'package:snapster_app/utils/widgets/regulated_max_width.dart';

class TestChatsScreen extends ConsumerStatefulWidget {
  static const String routeName = 'test-chats';
  static const String routeURL = '/test-chats';

  const TestChatsScreen({super.key});

  @override
  ConsumerState<TestChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<TestChatsScreen> {
  AppUser? _currentUser;
  List<ChatroomModel> _chatrooms = [];

  @override
  void initState() {
    super.initState();
  }

  void _onClickAddChat() {
    if (_currentUser == null) return;

    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              TestChatroomUserListScreen(currentUser: _currentUser!),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ));
  }

  void _closeExitDialog() {
    Navigator.of(context).pop();
  }

  void _removeLeftChatroom(ChatroomModel chatroom) {
    // 채팅방 나가기
    ref.read(httpChatroomProvider.notifier).exitChatroom(
          context: context,
          chatroomList: _chatrooms,
          chatroom: chatroom,
        );
    setState(() {});
  }

  void onExitChatroom(ChatroomModel chatroom) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(S.of(context).exitChatroom),
        actions: [
          CupertinoDialogAction(
            onPressed: _closeExitDialog,
            child: const Text("No"),
          ),
          CupertinoDialogAction(
            onPressed: () {
              _removeLeftChatroom(chatroom);
              _closeExitDialog();
            },
            isDestructiveAction: true,
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  Future<void> _onTapChat(int chatroomId) async {
    if (_currentUser == null) return;
    if (chatroomId == 0) return;

    if (mounted) {
      goToRouteNamed(
        context: context,
        routeName: TestChatDetailScreen.routeName,
        queryParams: {
          'chatroomId': chatroomId.toString(),
        },
        extra: ChatroomDetailParams(
          chatroomId: chatroomId,
          currentUser: _currentUser!,
          chatroom: null,
        ),
      );
    }
  }

  Widget _getChatroomListTile(int index) {
    var chatroom = _chatrooms[index];
    var participants = chatroom.participants;

    var other = participants[0].user;

    if (participants.length > 1) {
      other = participants
          .firstWhere(
            (p) => _currentUser?.userId != p.user.userId,
          )
          .user;
    }
    var updatedAt = chatroom.lastMessage.createdAt ?? chatroom.updatedAt;

    // TODO - 여러명 참여방일 경우 상대방 출력 로직 필요

    return ListTile(
        onLongPress: () => onExitChatroom(chatroom),
        onTap: () => _onTapChat(chatroom.id),
        leading: CircleAvatar(
          radius: Sizes.size28,
          foregroundImage: getProfileImgByUserProfileImageUrl(
            other.hasProfileImage,
            other.profileImageUrl,
            false,
          ),
          child: ClipOval(child: Text(other.username)),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              other.displayName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              _getLastUpdatedAt(updatedAt),
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: Sizes.size12,
              ),
            ),
          ],
        ),
        subtitle: _getLatestMessageText(chatroom));
  }

  Widget _getLatestMessageText(ChatroomModel chatroom) {
    if (chatroom.lastMessage.isEmpty()) {
      return Text(S.of(context).conversationNotStarted);
    }

    var lastMsg = chatroom.lastMessage;
    var content = lastMsg.content;

    if (lastMsg.type == MessageType.typeSystem) {
      content = getLeftTypeSystemMessage(context, content);
    }

    return Text(content);
  }

  String _getLastUpdatedAt(DateTime? updatedAt) {
    if (updatedAt == null) return '';

    var now = DateTime.now();
    // UTC -> LOCAL
    var localUpdate = updatedAt.toLocal();

    var isThisYear = now.year == localUpdate.year;
    var isToday = isThisYear &&
        now.month == localUpdate.month &&
        now.day == localUpdate.day;

    var format = isToday
        ? S.of(context).hourMinuteAPM
        : isThisYear
            ? S.of(context).monthDate
            : S.of(context).yearMonthDate;

    return DateFormat(format, 'en_US').format(localUpdate);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    if (authState.status == AuthStatus.loading) {
      return const CircularProgressIndicator();
    }

    if (authState.status == AuthStatus.unauthenticated) {
      return const Center(child: Text("로그인이 필요합니다."));
    }

    _currentUser = authState.user;

    return RegulatedMaxWidth(
      maxWidth: Breakpoints.sm,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          title: const Text('Direct messages'),
          actions: [
            IconButton(
              onPressed: _onClickAddChat,
              icon: const FaIcon(
                FontAwesomeIcons.plus,
              ),
            ),
          ],
        ),
        body: ref.watch(httpChatroomProvider).when(
              loading: () => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
              error: (error, stackTrace) => Center(
                child: Text(error.toString()),
              ),
              data: (chatrooms) {
                // _chatrooms = _getLastMessageInfo(chatrooms);
                _chatrooms = chatrooms;
                return _chatrooms.isEmpty
                    ? Column(
                        children: [
                          Gaps.v20,
                          ListTile(
                            title: ListTile(
                              onTap: _onClickAddChat,
                              contentPadding: const EdgeInsets.only(
                                left: Sizes.size20,
                              ),
                              title: Text(
                                S
                                    .of(context)
                                    .selectAProfileToStartAConversation,
                                style: const TextStyle(
                                  fontSize: Sizes.size16,
                                ),
                              ),
                              trailing: FaIcon(
                                FontAwesomeIcons.chevronRight,
                                size: Sizes.size14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListView.separated(
                        // key: _key,
                        itemCount: _chatrooms.length,
                        padding: const EdgeInsets.symmetric(
                          vertical: Sizes.size10,
                        ),
                        separatorBuilder: (context, index) => Gaps.v5,
                        itemBuilder: (context, index) =>
                            _getChatroomListTile(index),
                      );
              },
            ),
      ),
    );
  }
}
