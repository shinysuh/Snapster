import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:snapster_app/constants/breakpoints.dart';
import 'package:snapster_app/constants/gaps.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/constants/system_message_types.dart';
import 'package:snapster_app/features/inbox/models/chat_partner_model.dart';
import 'package:snapster_app/features/inbox/models/chatroom_model.dart';
import 'package:snapster_app/features/inbox/models/message_model.dart';
import 'package:snapster_app/features/inbox/view_models/chatroom_view_model.dart';
import 'package:snapster_app/features/inbox/view_models/message_view_model.dart';
import 'package:snapster_app/generated/l10n.dart';
import 'package:snapster_app/utils/profile_network_img.dart';
import 'package:snapster_app/utils/system_message.dart';
import 'package:snapster_app/utils/tap_to_unfocus.dart';
import 'package:snapster_app/utils/theme_mode.dart';
import 'package:snapster_app/utils/widgets/regulated_max_width.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  static const String routeName = 'chatDetail';
  static const String routeURL = ':chatroomId';

  final String chatroomId;
  final ChatPartnerModel chatroomBasicInfo;

  const ChatDetailScreen({
    super.key,
    required this.chatroomId,
    required this.chatroomBasicInfo,
  });

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  late ChatPartnerModel _chatroomBasic;
  late ChatroomModel? _chatroomInfo;
  bool _isWriting = false;
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _chatroomBasic = widget.chatroomBasicInfo;
    _getChatroomInfo(_chatroomBasic.chatPartner.uid);
  }

  Future<void> _getChatroomInfo(String partnerId) async {
    _chatroomInfo =
        await ref.read(chatroomProvider.notifier).fetchChatroomByPartnerId(
              context,
              partnerId,
            );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

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
    final isPartnerParticipating = _chatroomBasic.chatPartner.isParticipating;

    var reInvitationConfirm = true;

    if (!isPartnerParticipating) {
      // 상대 다시 초대 여부
      reInvitationConfirm = await _getReInvitationConfirm();
    }

    if (reInvitationConfirm && mounted) {
      ref
          .read(messageProvider(widget.chatroomId).notifier)
          .sendMessage(context, _textEditingController.text)
          .then((_) => _textEditingController.clear());

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

  Future<bool> _getReInvitationConfirm() async {
    if (_chatroomInfo == null) return false;

    var chatroom = _chatroomInfo;
    var partner = _chatroomBasic.chatPartner;
    var now = DateTime.now().millisecondsSinceEpoch;

    var isPartnerPersonA = _chatroomInfo!.chatroomId.startsWith(partner.uid);

    var reInvited = false;

    await _getAlert(
      title: S.of(context).reInvitationConfirmMsg,
      confirmActionCallback: () async {
        await ref.read(chatroomProvider.notifier).reJoinChatroom(
              context: context,
              chatroom: ChatroomModel(
                chatroomId: chatroom!.chatroomId,
                personA: isPartnerPersonA ? partner : chatroom.personA,
                personB: isPartnerPersonA ? chatroom.personB : partner,
                updatedAt: now,
              ),
              isPersonARejoining: isPartnerPersonA,
              now: now,
            );

        _setPartnerParticipationInfo(true);

        _closeDialog();
        reInvited = true;
      },
      destructiveActionCallback: _closeDialog,
    );

    return reInvited;
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
    // TODO - 방 나가기 로직 (alert 포함)
    // showCupertinoDialog(
    //   context: context,
    //   builder: (context) => CupertinoAlertDialog(
    //     title: Text(S.of(context).exitChatroom),
    //     // content: const Text('Please confirm'),
    //     actions: [
    //       CupertinoDialogAction(
    //         onPressed: _closeExitDialog,
    //         child: const Text("No"),
    //       ),
    //       CupertinoDialogAction(
    //         onPressed: () {
    //           ref
    //               .read(chatroomProvider.notifier)
    //               .exitChatroom(context, chatroom);
    //           _closeExitDialog();
    //         },
    //         isDestructiveAction: true,
    //         child: const Text("Yes"),
    //       ),
    //     ],
    //   ),
    // );
  }

  void _setPartnerParticipationInfo(bool isParticipating) {
    _chatroomBasic = _chatroomBasic.copyWith(
      chatPartner: _chatroomBasic.chatPartner.copyWith(
        isParticipating: isParticipating,
      ),
    );
  }

  List<MessageModel> _getAllowedMessages(List<MessageModel> messages) {
    if (messages.isEmpty || _chatroomBasic.showMsgFrom == 0) return messages;

    if (messages.first.userId == MessageViewModel.systemId) {
      final text = messages.first.text;

      if (isLeftTypeSystemMessage(text) &&
          text
              .split(systemMessageDivider)[0]
              .startsWith(_chatroomBasic.chatPartner.username)) {
        _setPartnerParticipationInfo(false);
      }
    }

    List<MessageModel> allowedMessages = [];

    var idx = 0;

    for (; idx < messages.length; idx++) {
      var msg = messages[idx];
      if (!(msg.createdAt > _chatroomBasic.showMsgFrom)) break;

      allowedMessages.add(msg);
    }

    return allowedMessages;
  }

  void _updateMessageToDeleted(MessageModel message) {
    var threeMinutes = 180000;
    var now = DateTime.now().millisecondsSinceEpoch;
    bool isDeletable = now - message.createdAt < threeMinutes;

    // 보낸지 3분 이내에 삭제 가능
    if (!isDeletable) return;
    _getAlert(
      title: S.of(context).deleteMessageConfirm,
      confirmActionCallback: () async {
        await ref
            .read(messageProvider(widget.chatroomId).notifier)
            .updateMessageToDeleted(
              context,
              message,
            );
        _closeDialog();
      },
      destructiveActionCallback: _closeDialog,
    );
  }

  Widget _getMsgSentAt(int createdAt, bool isDark) {
    var sentAt = DateTime.fromMillisecondsSinceEpoch(createdAt);
    return Text(
      DateFormat(
        S.of(context).hourMinuteAPM,
        'en_US',
      ).format(sentAt),
      style: TextStyle(
        fontSize: Sizes.size12,
        color: isDark
            ? Colors.white.withOpacity(0.6)
            : Colors.black.withOpacity(0.4),
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
              color: Colors.black.withOpacity(0.2),
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

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    var commonBcgColor = isDark
        ? Theme.of(context).appBarTheme.backgroundColor
        : Colors.grey.shade50;
    var iconColor = isDark ? Colors.grey.shade400 : Colors.grey.shade900;

    final isLoading = ref.watch(messageProvider(widget.chatroomId)).isLoading;

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
                      Padding(
                        padding: const EdgeInsets.all(Sizes.size4),
                        child: CircleAvatar(
                          radius: Sizes.size24,
                          foregroundImage: getProfileImgByUserId(
                            _chatroomBasic.chatPartner.uid,
                            false,
                          ),
                          child: ClipOval(
                            child: Text(_chatroomBasic.chatPartner.name),
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
                    _chatroomBasic.chatPartner.username,
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
                  ref.watch(chatProvider(widget.chatroomId)).when(
                        loading: () => const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                        error: (error, stackTrace) => Center(
                          child: Text(error.toString()),
                        ),
                        data: (messages) {
                          messages = _getAllowedMessages(messages);
                          return ListView.separated(
                            reverse: true,
                            padding: EdgeInsets.only(
                              top: Sizes.size20,
                              bottom: MediaQuery.of(context).padding.bottom +
                                  Sizes.size96,
                              left: Sizes.size20,
                              right: Sizes.size20,
                            ),
                            itemCount: messages.length,
                            separatorBuilder: (context, index) => Gaps.v10,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              final messageSender = ref
                                  .read(messageProvider(widget.chatroomId)
                                      .notifier)
                                  .getMessageSender(context, message.userId);
                              final isMine =
                                  messageSender == MessageSenderType.me;
                              final isPartner =
                                  messageSender == MessageSenderType.partner;
                              final isSystem = !isMine && !isPartner;
                              final systemColor = isDark
                                  ? Colors.white.withOpacity(0.4)
                                  : Colors.black.withOpacity(0.3);
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: isMine
                                    ? MainAxisAlignment.end
                                    : isPartner
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.center,
                                children: [
                                  if (isMine)
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        _getMsgSentAt(
                                          message.createdAt,
                                          isDark,
                                        ),
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
                                            : isPartner
                                                ? Theme.of(context).primaryColor
                                                : systemColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(
                                              Sizes.size20),
                                          topRight: const Radius.circular(
                                              Sizes.size20),
                                          bottomLeft: Radius.circular(
                                            isPartner
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
                                                message.text,
                                              )
                                            : message.text,
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
                                  if (isPartner)
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Gaps.h6,
                                        _getMsgSentAt(
                                          message.createdAt,
                                          isDark,
                                        ),
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
                                        MaterialStateProperty.all<Color>(
                                            circleColor),
                                    padding: MaterialStateProperty.all<
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
