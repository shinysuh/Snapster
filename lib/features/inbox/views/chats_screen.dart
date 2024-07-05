import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/models/chat_partner_model.dart';
import 'package:tiktok_clone/features/inbox/view_models/chatroom_view_model.dart';
import 'package:tiktok_clone/features/inbox/view_models/message_view_model.dart';
import 'package:tiktok_clone/features/inbox/views/chat_detail_screen.dart';
import 'package:tiktok_clone/features/inbox/views/chatroom_user_list_screen.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/utils/navigator_redirection.dart';
import 'package:tiktok_clone/utils/profile_network_img.dart';
import 'package:tiktok_clone/utils/widgets/regulated_max_width.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  static const String routeName = 'chats';
  static const String routeURL = '/chats';

  const ChatsScreen({super.key});

  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  // final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();
  // final Duration _duration = const Duration(milliseconds: 300);
  List<ChatPartnerModel> _chatrooms = [];

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

  void _closeLeavingDialog() {
    Navigator.of(context).pop();
  }

  void _removeLeftChatroom(ChatPartnerModel chatroom) {
    final index = _chatrooms.indexOf(chatroom);
    _chatrooms.removeAt(index);
    setState(() {});
  }

  void _onLeaveChatroom(ChatPartnerModel chatroom) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(S.of(context).leaveChatroom),
        // content: const Text('Please confirm'),
        actions: [
          CupertinoDialogAction(
            onPressed: _closeLeavingDialog,
            child: const Text("No"),
          ),
          CupertinoDialogAction(
            onPressed: () {
              _removeLeftChatroom(chatroom);
              ref
                  .read(chatroomProvider.notifier)
                  .leaveChatroom(context, chatroom);
              _closeLeavingDialog();
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
    final chatPartner = chatroom.chatPartner;
    return ListTile(
      onLongPress: () => _onLeaveChatroom(chatroom),
      onTap: () => _onTapChat(chatroom),
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
            chatPartner.username,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            _getLastUpdatedAt(chatroom.updatedAt),
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: Sizes.size12,
            ),
          ),
        ],
      ),
      subtitle: ref.watch(lastMessageProvider(chatroom.chatroomId)).when(
          loading: () => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
          error: (error, stackTrace) => Center(
                child: Text(error.toString()),
              ),
          data: (message) {
            return Text(message != null
                ? message.text
                : S.of(context).conversationNotStarted);
          }),
    );
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
                            _getChatroomListTile(_chatrooms[index], index),
                      );
                // AnimatedList(
                //         key: _key,
                //         initialItemCount: _chatrooms.length,
                //         padding: const EdgeInsets.symmetric(
                //           vertical: Sizes.size10,
                //         ),
                //         itemBuilder: (context, index, animation) {
                //           return FadeTransition(
                //             key: UniqueKey(),
                //             opacity: animation,
                //             child: SizeTransition(
                //               sizeFactor: animation,
                //               child: _getChatroomListTile(
                //                   _chatrooms[index], index),
                //             ),
                //           );
                //         },
                //       );
              },
            ),
      ),
    );
  }
}
