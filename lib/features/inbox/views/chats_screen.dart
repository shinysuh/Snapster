import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/constants/system_message_types.dart';
import 'package:tiktok_clone/features/inbox/models/chat_partner_model.dart';
import 'package:tiktok_clone/features/inbox/models/chatter_model.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';
import 'package:tiktok_clone/features/inbox/view_models/chatroom_view_model.dart';
import 'package:tiktok_clone/features/inbox/view_models/message_view_model.dart';
import 'package:tiktok_clone/features/inbox/views/chat_detail_screen.dart';
import 'package:tiktok_clone/features/inbox/views/chatroom_user_list_screen.dart';
import 'package:tiktok_clone/features/user/view_models/user_view_model.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/utils/navigator_redirection.dart';
import 'package:tiktok_clone/utils/profile_network_img.dart';
import 'package:tiktok_clone/utils/system_message.dart';
import 'package:tiktok_clone/utils/widgets/regulated_max_width.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  static const String routeName = 'chats';
  static const String routeURL = '/chats';

  const ChatsScreen({super.key});

  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  List<ChatPartnerModel> _chatrooms = [];
  Map<String, MessageModel?> _lastMessages = {};

  void _onClickAddChat() {
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const ChatroomUserListScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ));
  }

  void _closeExitDialog() {
    Navigator.of(context).pop();
  }

  void _removeLeftChatroom(ChatPartnerModel chatroom) {
    final index = _chatrooms.indexOf(chatroom);
    _chatrooms.removeAt(index);
    setState(() {});

    // 채팅방 제거
    ref.read(chatroomProvider.notifier).exitChatroom(context, chatroom);
  }

  List<ChatPartnerModel> _getLastMessageInfo(List<ChatPartnerModel> chatrooms) {
    List<ChatPartnerModel> sortedChatrooms = [];
    Map<String, MessageModel?> lastMsgs = {};

    for (var i = 0; i < chatrooms.length; i++) {
      var chatroom = chatrooms[i];
      var msg = ref.watch(lastMessageProvider(chatroom.chatroomId));

      if (msg.value != null) {
        final lastMsg = msg.value!;
        // 채팅방 업데이트 보다 마지막 메세지가 더 최근이면 메세지 생성 시간으로 업데이트 시간 교체
        if (chatroom.updatedAt < lastMsg.createdAt) {
          chatroom = chatroom.copyWith(updatedAt: lastMsg.createdAt);
        }
      }

      sortedChatrooms.add(chatroom);
      lastMsgs[chatroom.chatroomId] = msg.value;
    }

    setState(() {
      _lastMessages = lastMsgs;
    });

    sortedChatrooms.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sortedChatrooms;
  }

  void _onExitChatroom(ChatPartnerModel chatroom) {
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

  void _onTapChat(ChatPartnerModel chatroom) {
    goToRouteNamed(
      context: context,
      routeName: ChatDetailScreen.routeName,
      params: {'chatroomId': chatroom.chatroomId},
      extra: chatroom,
    );
  }

  Widget _getChatroomListTile(ChatPartnerModel chatroom, int index) {
    return FutureBuilder(
      future: _getPartnerUsername(chatroom.chatPartner),
      builder: (context, snapshot) {
        final chatPartner = chatroom.chatPartner;
        // 상대방의 최신 username 가져와서 세팅
        final chatInfo = chatroom.copyWith(
          chatPartner: chatPartner.copyWith(
            username: snapshot.data,
          ),
        );

        return ListTile(
            onLongPress: () => _onExitChatroom(chatInfo),
            onTap: () => _onTapChat(chatInfo),
            leading: CircleAvatar(
              radius: Sizes.size28,
              foregroundImage: chatPartner.hasAvatar
                  ? getProfileImgByUserId(chatPartner.uid, false)
                  : null,
              child: ClipOval(child: Text(chatPartner.name)),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  snapshot.data ?? chatPartner.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _getLastUpdatedAt(chatInfo.updatedAt),
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: Sizes.size12,
                  ),
                ),
              ],
            ),
            subtitle: _getLatestMessageText(chatInfo));
      },
    );
  }

  Widget _getLatestMessageText(ChatPartnerModel chatroom) {
    var text = '';
    if (_lastMessages.isEmpty) return Text(text);

    MessageModel? msg = _lastMessages[chatroom.chatroomId];

    if (msg != null) {
      text = !msg.userId.startsWith(MessageViewModel.systemId)
          ? msg.text
          : _getLatestSystemMsg(msg.text, chatroom.chatPartner.uid);
    } else {
      text = S.of(context).conversationNotStarted;
    }

    return Text(text);
  }

  String _getLatestSystemMsg(String text, String partnerUid) {
    var textElms = text.split(systemMessageDivider);
    var userId = textElms[0];
    return userId == partnerUid
        ? getLeftTypeSystemMessage(context, text)
        : S.of(context).conversationNotStarted;
  }

  String _getLastUpdatedAt(int updatedAt) {
    var today = DateTime.now();
    var lastUpdate = DateTime.fromMillisecondsSinceEpoch(updatedAt);

    var isThisYear = today.year == lastUpdate.year;
    var isToday = isThisYear &&
        today.month == lastUpdate.month &&
        today.day == lastUpdate.day;

    var format = isToday
        ? S.of(context).hourMinuteAPM
        : isThisYear
            ? S.of(context).monthDate
            : S.of(context).yearMonthDate;

    return DateFormat(format, 'en_US').format(lastUpdate);
  }

  Future<String> _getPartnerUsername(ChatterModel partner) async {
    return await ref
        .read(userProvider.notifier)
        .findUsername(context, partner.uid);
  }

  @override
  Widget build(BuildContext context) {
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
        body: ref.watch(chatroomListProvider).when(
              loading: () => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
              error: (error, stackTrace) => Center(
                child: Text(error.toString()),
              ),
              data: (chatrooms) {
                _chatrooms = _getLastMessageInfo(chatrooms);
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
                            _getChatroomListTile(_chatrooms[index], index),
                      );
              },
            ),
      ),
    );
  }
}
