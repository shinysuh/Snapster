import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:snapster_app/constants/breakpoints.dart';
import 'package:snapster_app/constants/gaps.dart';
import 'package:snapster_app/constants/message_types.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/chat/chatroom/models/chatroom_model.dart';
import 'package:snapster_app/features/chat/message/models/chat_message_model.dart';
import 'package:snapster_app/features/chat/message/view_models/chat_message_view_model.dart';
import 'package:snapster_app/features/chat/participant/models/chatroom_participant_model.dart';
import 'package:snapster_app/features/chat/participant/view_models/chatroom_participant_view_model.dart';
import 'package:snapster_app/features/chat/stomp/view_models/stomp_view_model.dart';
import 'package:snapster_app/features/inbox/view_models/chatroom_view_model.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/generated/l10n.dart';
import 'package:snapster_app/utils/profile_network_img.dart';
import 'package:snapster_app/utils/system_message.dart';
import 'package:snapster_app/utils/tap_to_unfocus.dart';
import 'package:snapster_app/utils/theme_mode.dart';
import 'package:snapster_app/utils/widgets/regulated_max_width.dart';

class ChatroomDetailParams {
  final int chatroomId;
  final ChatroomModel chatroom;
  final AppUser currentUser;

  const ChatroomDetailParams({
    required this.chatroomId,
    required this.chatroom,
    required this.currentUser,
  });
}

class TestChatDetailScreen extends ConsumerStatefulWidget {
  static const String routeName = 'test-chat-detail';
  static const String routeURL = 'chat-detail';

  final ChatroomDetailParams chatroomDetails;

  const TestChatDetailScreen({
    super.key,
    required this.chatroomDetails,
  });

  @override
  ConsumerState<TestChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<TestChatDetailScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  late final ChatroomModel _chatroom;
  late final ChatroomParticipantModel _currentUser;
  late final int _currentUserId;
  late final List<ChatroomParticipantModel> _others;

  List<ChatMessageModel> _messages = [];

  bool _isWriting = false;
  bool _isDropdownOpen = false;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _chatroom = widget.chatroomDetails.chatroom;
    var currentUserIdx = _chatroom.participants.indexWhere(
        (p) => widget.chatroomDetails.currentUser.userId == p.user.userId);

    _currentUser = _chatroom.participants.firstWhere(
      (p) => widget.chatroomDetails.currentUser.userId == p.user.userId,
    );
    _currentUserId = _currentUser.id.userId;
    _others = _chatroom.participants
        .where((p) => p.id.userId != _currentUserId)
        .toList();

    _initialize(currentUserIdx);
  }

  Future<void> _initialize(int currentUserIdx) async {
    var currUser = _currentUser;

    if (_chatroom.lastMessage.id != _currentUser.lastReadMessageId) {
      currUser = currUser.copyWith(
        lastReadMessageId: _chatroom.lastMessage.id,
      );

      _currentUser = currUser;
      await updateLastReadMessage(_currentUser);
    }
  }

  Future<void> updateLastReadMessage(
      ChatroomParticipantModel currentUser) async {
    await ref
        .read(participantProvider(_chatroom.id).notifier)
        .updateLastReadMessage(context, currentUser);
  }

  // Future<void> _getChatroomInfo(String partnerId) async {
  //   _chatroomInfo =
  //       await ref.read(chatroomProvider.notifier).fetchChatroomByPartnerId(
  //             context,
  //             partnerId,
  //           );
  // }

  void _onTapScaffold() {
    onTapOutsideAndDismissKeyboard(context);
    _isDropdownOpen = false;
    setState(() {});
  }

  void _onChangeMessage(String message) {
    bool hasText = _textEditingController.text.trim().isNotEmpty;
    if (_isWriting && hasText) return;

    setState(() {
      _isWriting = hasText;
    });
  }

  Future<void> _onSendMessage() async {
    final hasOtherParticipants = _others.isNotEmpty;

    var reInvitationConfirm = true;

    // if (!hasOtherParticipants) {
    // 상대 다시 초대 여부 => 메시지 보낼 때 말고, 대화 상대 추가하기 기능으로 재초대 가능
    // reInvitationConfirm = await _getReInvitationConfirm();
    // }

    int? receiverId;
    if (hasOtherParticipants && _others.length == 1) {
      receiverId = _others.first.id.userId;
    }

    if (reInvitationConfirm && mounted) {
      ref.read(stompProvider(_chatroom.id).notifier).sendMessageToRoom(
            context: context,
            senderId: _currentUserId,
            receiverId: receiverId,
            content: _textEditingController.text,
            type: MessageType.typeText,
          );

      // 입력창 clear
      _textEditingController.clear();

      setState(() {
        _isWriting = false;
      });
    }
  }

  Future<void> _getAlert({
    required String title,
    required void Function() confirmActionCallback,
    required void Function() destructiveActionCallback,
  }) async {
    await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: Sizes.size16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              // content: const Text('Please confirm'),
              actions: [
                CupertinoDialogAction(
                  onPressed: confirmActionCallback,
                  child: const Text("Yes"),
                ),
                CupertinoDialogAction(
                  onPressed: destructiveActionCallback,
                  isDestructiveAction: true,
                  child: const Text("No"),
                ),
              ],
            ));
  }

  void _onTapDots() {
    // setState(() {
    //   _isDropdownOpen = true;
    // });
  }

  void _closeDialog() {
    Navigator.of(context).pop();
  }

  void _onExitChatroom() {
    context.pop();
  }

  List<ChatMessageModel> _getAllowedMessages(List<ChatMessageModel> messages) {
    if (messages.isEmpty) {
      return messages;
    }

    DateTime? msgCreatedAt = messages.last.createdAt;
    DateTime? userJoinedAt = _currentUser.joinedAt;

    if (userJoinedAt == null || msgCreatedAt == null) {
      debugPrint('##### userJoinedAt || msgCreatedAt 누락 오류 발생');
      return [];
    }

    if (userJoinedAt.isBefore(msgCreatedAt)) {
      return messages;
    }

    // 시스템 메시지 처리
    if (messages.first.type == MessageType.typeSystem) {}

    // if (messages.first.userId == MessageViewModel.systemId) {
    //   final text = messages.first.text;
    //
    //   if (isLeftTypeSystemMessage(text) &&
    //       text
    //           .split(systemMessageDivider)[0]
    //           .startsWith(_chatroomBasic.chatPartner.username)) {
    //     _setPartnerParticipationInfo(false);
    //   }
    // }

    // List<MessageModel> allowedMessages = [];
    //
    // var idx = 0;
    //
    // for (; idx < messages.length; idx++) {
    //   var msg = messages[idx];
    //   if (!(msg.createdAt > _chatroomBasic.showMsgFrom)) break;
    //
    //   allowedMessages.add(msg);
    // }
    //
    // return allowedMessages;
    return messages;
  }

  void _updateMessageToDeleted(ChatMessageModel message) {
    var threeMinutes = const Duration(minutes: 3);
    var now = DateTime.now();
    bool isDeletable = message.createdAt != null
        ? now.difference(message.createdAt!).inMilliseconds <
            threeMinutes.inMilliseconds
        : false;

    // 보낸지 3분 이내에 삭제 가능
    if (!isDeletable) return;
    _getAlert(
      title: S.of(context).deleteMessageConfirm,
      confirmActionCallback: () async {
        await ref
            .read(chatMessageProvider(_chatroom.id).notifier)
            .updateMessageToDeleted(
              context: context,
              currentUser: _currentUser,
              message: message,
            );
        _closeDialog();
      },
      destructiveActionCallback: _closeDialog,
    );
  }

  Widget _getMsgSentAt(DateTime sentAt, bool isDark) {
    return Text(
      DateFormat(
        S.of(context).hourMinuteAPM,
        'en_US',
      ).format(sentAt.toLocal()),
      style: TextStyle(
        fontSize: Sizes.size12,
        color: isDark
            ? Colors.white.withAlpha((0.6 * 255).round())
            : Colors.black.withAlpha((0.4 * 255).round()),
      ),
    );
  }

  Widget _getDropdown(bool isDark) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + Sizes.size36,
      right: Sizes.size14,
      child: Container(
        clipBehavior: Clip.hardEdge,
        height: Sizes.size64,
        width: Sizes.size96 + Sizes.size52,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: isDark ? Colors.grey.shade800 : Colors.white,
          borderRadius: BorderRadius.circular(
            Sizes.size14,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.2 * 255).round()),
              blurRadius: 20,
              spreadRadius: 3,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _onExitChatroom,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).exitChatroom,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: Sizes.size14 + Sizes.size1,
                    ),
                  ),
                  Gaps.h10,
                  const FaIcon(
                    FontAwesomeIcons.arrowUpRightFromSquare,
                    size: Sizes.size14,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getMessageField(bool isDark, Color iconColor) {
    return TextField(
      controller: _textEditingController,
      onChanged: (message) => _onChangeMessage(message),
      onSubmitted: (message) => _onSendMessage(),
      expands: true,
      minLines: null,
      maxLines: null,
      textInputAction: TextInputAction.newline,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark ? Colors.grey.shade800 : Colors.white,
        hintText: 'Send a message...',
        hintStyle: TextStyle(
          color: isDark ? Colors.grey.shade300 : null,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Sizes.size20),
            topRight: Radius.circular(Sizes.size20),
            bottomLeft: Radius.circular(Sizes.size20),
          ),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Sizes.size10,
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(Sizes.size12),
          child: FaIcon(
            FontAwesomeIcons.faceLaugh,
            color: iconColor,
            size: Sizes.size22,
          ),
        ),
      ),
    );
  }

  String _getParticipantNames() {
    if (_others.length <= 3) {
      return _others.map((o) => o.user.displayName).join(', ');
    } else {
      final displayed =
          _others.take(3).map((o) => o.user.displayName).join(', ');
      final remaining = _others.length - 3;
      return '$displayed 외 $remaining명';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    final systemColor = isDark
        ? Colors.white.withAlpha((0.4 * 255).round())
        : Colors.black.withAlpha((0.3 * 255).round());
    var commonBcgColor = isDark
        ? Theme.of(context).appBarTheme.backgroundColor
        : Colors.grey.shade50;
    var iconColor = isDark ? Colors.grey.shade400 : Colors.grey.shade900;

    var isLoading = ref.watch(chatroomProvider).isLoading;

    return RegulatedMaxWidth(
      maxWidth: Breakpoints.sm,
      child: Stack(
        children: [
          GestureDetector(
            onTap: _onTapScaffold,
            child: Scaffold(
              backgroundColor: commonBcgColor,
              appBar: AppBar(
                backgroundColor: commonBcgColor,
                title: ListTile(
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: Sizes.size8,
                  leading: Stack(
                    // 아래 Positioned 대신 사용 가능
                    // alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      // TODO - 여러명 참여방일 경우 상대방 출력 로직 필요
                      Padding(
                        padding: const EdgeInsets.all(Sizes.size4),
                        child: CircleAvatar(
                          radius: Sizes.size24,
                          foregroundImage: getProfileImgByUserProfileImageUrl(
                            _others.first.user.hasProfileImage,
                            _others.first.user.profileImageUrl,
                            false,
                          ),
                          child: ClipOval(
                            child: Text(_others.first.user.displayName),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          height: Sizes.size20,
                          width: Sizes.size20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green.shade400,
                            border: Border.all(
                              color: Colors.white,
                              width: Sizes.size3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    _getParticipantNames(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text('Active now'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.flag,
                        size: Sizes.size22,
                        color: iconColor,
                      ),
                      Gaps.h32,
                      GestureDetector(
                        onTap: _onTapDots,
                        child: FaIcon(
                          FontAwesomeIcons.ellipsis,
                          size: Sizes.size20,
                          color: iconColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: Stack(
                children: [
                  ref.watch(stompProvider(_chatroom.id)).when(
                        loading: () => const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                        error: (error, stackTrace) => Center(
                          child: Text(error.toString()),
                        ),
                        data: (messages) {
                          _messages = _getAllowedMessages(messages);
                          return ListView.separated(
                            reverse: true,
                            padding: EdgeInsets.only(
                              top: Sizes.size20,
                              bottom: MediaQuery.of(context).padding.bottom +
                                  Sizes.size96,
                              left: Sizes.size20,
                              right: Sizes.size20,
                            ),
                            itemCount: _messages.length,
                            separatorBuilder: (context, index) => Gaps.v10,
                            itemBuilder: (context, index) {
                              final message = _messages[index];
                              final createdAt = message.createdAt!;

                              final senderType = ref
                                  .read(chatMessageProvider(_chatroom.id)
                                      .notifier)
                                  .getSenderType(_currentUserId, message);

                              final isMine = senderType == SenderType.senderMe;
                              final isOther =
                                  senderType == SenderType.senderOther;
                              final isSystem =
                                  senderType == SenderType.senderSystem;

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: isMine
                                    ? MainAxisAlignment.end
                                    : isOther
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.center,
                                children: [
                                  if (isMine)
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        _getMsgSentAt(createdAt, isDark),
                                        Gaps.h6,
                                      ],
                                    ),
                                  GestureDetector(
                                    onLongPress: () =>
                                        _updateMessageToDeleted(message),
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: Breakpoints.sm / 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isMine
                                            ? const Color(0xFF609EC2)
                                            : isOther
                                                ? Theme.of(context).primaryColor
                                                : systemColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(
                                              Sizes.size20),
                                          topRight: const Radius.circular(
                                              Sizes.size20),
                                          bottomLeft: Radius.circular(
                                            isOther
                                                ? Sizes.size5
                                                : Sizes.size20,
                                          ),
                                          bottomRight: Radius.circular(
                                            isMine ? Sizes.size5 : Sizes.size20,
                                          ),
                                        ),
                                      ),
                                      padding: EdgeInsets.all(isSystem
                                          ? Sizes.size8
                                          : Sizes.size14),
                                      child: Text(
                                        isSystem
                                            ? getLeftTypeSystemMessage(
                                                context,
                                                message.content,
                                              )
                                            : message.content,
                                        textAlign: isSystem
                                            ? TextAlign.center
                                            : TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isSystem
                                              ? Sizes.size12
                                              : Sizes.size16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (isOther)
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Gaps.h6,
                                        _getMsgSentAt(createdAt, isDark),
                                      ],
                                    ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                  Positioned(
                    bottom: 0,
                    width: MediaQuery.of(context).size.width,
                    child: BottomAppBar(
                      color: commonBcgColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Sizes.size4,
                          horizontal: Sizes.size10,
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            var isWiderThanSm = constraints.maxWidth >
                                Breakpoints.sm - Sizes.size28;
                            var circleColor = isDark
                                ? Colors.grey.shade400
                                : _isWriting
                                    ? Colors.grey.shade200
                                    : Colors.grey.shade300;
                            var planeColor =
                                _isWriting ? Colors.blue : Colors.white;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (isWiderThanSm)
                                  Container(
                                    height: Sizes.size48,
                                    constraints: const BoxConstraints(
                                      maxWidth: Breakpoints.sm - Sizes.size80,
                                    ),
                                    child: _getMessageField(isDark, iconColor),
                                  ),
                                if (!isWiderThanSm)
                                  Expanded(
                                    child: SizedBox(
                                      height: Sizes.size48,
                                      child:
                                          _getMessageField(isDark, iconColor),
                                    ),
                                  ),
                                Gaps.h12,
                                IconButton(
                                  padding:
                                      const EdgeInsets.only(top: Sizes.size2),
                                  onPressed: isLoading || !_isWriting
                                      ? null
                                      : _onSendMessage,
                                  icon: FaIcon(
                                    isLoading
                                        ? FontAwesomeIcons.hourglass
                                        : FontAwesomeIcons.solidPaperPlane,
                                    size: Sizes.size22,
                                    color: planeColor,
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            circleColor),
                                    padding: WidgetStateProperty.all<
                                        EdgeInsetsGeometry>(
                                      EdgeInsets.only(
                                        bottom: Sizes.size2,
                                        right: isLoading ? 0 : Sizes.size3,
                                      ),
                                    ),
                                    splashFactory: NoSplash.splashFactory,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          if (_isDropdownOpen) _getDropdown(isDark),
        ],
      ),
    );
  }
}
