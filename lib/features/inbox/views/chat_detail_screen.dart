import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/profile_images.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/view_models/message_view_model.dart';
import 'package:tiktok_clone/features/user/view_models/user_view_model.dart';
import 'package:tiktok_clone/utils/tap_to_unfocus.dart';
import 'package:tiktok_clone/utils/theme_mode.dart';
import 'package:tiktok_clone/utils/widgets/regulated_max_width.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  static const String routeName = 'chatDetail';
  static const String routeURL = ':chatId';

  const ChatDetailScreen({
    super.key,
    required this.chatId,
  });

  final String chatId;

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  late final user = ref.read(userProvider.notifier).loginUser;
  final TextEditingController _textEditingController = TextEditingController();
  bool _isWriting = false;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _onChangeMessage(String message) {
    bool hasText = _textEditingController.text.trim().isNotEmpty;
    if (_isWriting && hasText) return;

    setState(() {
      _isWriting = hasText;
    });
  }

  void _onSendMessage() {
    ref
        .read(messageProvider.notifier)
        .sendMessage(context, _textEditingController.text)
        .then((_) => _textEditingController.clear());

    setState(() {
      _isWriting = false;
    });
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

    final isLoading = ref.watch(messageProvider).isLoading;

    return RegulatedMaxWidth(
      maxWidth: Breakpoints.sm,
      child: GestureDetector(
        onTap: () => onTapOutsideAndDismissKeyboard(context),
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
                      foregroundImage: jasonImage,
                      child: const Text('쩨이쓴'),
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
                '쭌희 (${widget.chatId})',
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
                  FaIcon(
                    FontAwesomeIcons.ellipsis,
                    size: Sizes.size20,
                    color: iconColor,
                  ),
                ],
              ),
            ),
          ),
          body: Stack(
            children: [
              ref.watch(chatProvider).when(
                    loading: () => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    error: (error, stackTrace) => Center(
                      child: Text(error.toString()),
                    ),
                    data: (messages) => ListView.separated(
                      reverse: true,
                      padding: EdgeInsets.only(
                        top: Sizes.size20,
                        bottom: MediaQuery.of(context).padding.bottom +
                            Sizes.size96,
                        left: Sizes.size14,
                        right: Sizes.size14,
                      ),
                      itemCount: messages.length,
                      separatorBuilder: (context, index) => Gaps.v10,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isMine = ref
                            .read(messageProvider.notifier)
                            .isMine(context, message.userId);
                        // final isMine = ref.watch(authRepository).user!.uid ==
                        //     message.userId;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: isMine
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: isMine
                                    ? const Color(0xFF609EC2)
                                    : Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(Sizes.size20),
                                  topRight: const Radius.circular(Sizes.size20),
                                  bottomLeft: Radius.circular(
                                      isMine ? Sizes.size20 : Sizes.size5),
                                  bottomRight: Radius.circular(
                                      isMine ? Sizes.size5 : Sizes.size20),
                                ),
                              ),
                              padding: const EdgeInsets.all(Sizes.size14),
                              child: Text(
                                message.text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: Sizes.size16,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
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
                                  child: _getMessageField(isDark, iconColor),
                                ),
                              ),
                            Gaps.h12,
                            IconButton(
                              padding: const EdgeInsets.only(top: Sizes.size2),
                              onPressed: isLoading ? null : _onSendMessage,
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
                            // GestureDetector(
                            //   onTap: _onSendMessage,
                            //   child: Container(
                            //     width: Sizes.size40,
                            //     height: Sizes.size40,
                            //     decoration: BoxDecoration(
                            //       shape: BoxShape.circle,
                            //       color: circleColor,
                            //     ),
                            //     child: Padding(
                            //       padding: const EdgeInsets.symmetric(
                            //         vertical: Sizes.size8,
                            //         horizontal: Sizes.size8,
                            //       ),
                            //       child: FaIcon(
                            //         FontAwesomeIcons.solidPaperPlane,
                            //         size: Sizes.size22,
                            //         color: planeColor,
                            //       ),
                            //     ),
                            //   ),
                            // ),
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
    );
  }
}
