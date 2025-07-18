import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/chat/message/models/chat_message_model.dart';
import 'package:snapster_app/utils/theme_mode.dart';

class NotificationPopup extends ConsumerStatefulWidget {
  final ChatMessageModel message;
  final OverlayEntry entry;
  final VoidCallback? onTap;

  const NotificationPopup({
    super.key,
    required this.message,
    required this.entry,
    this.onTap,
  });

  static void show({
    required OverlayState overlay,
    required ChatMessageModel message,
    VoidCallback? onTap,
    Color? popupColor,
  }) {
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: NotificationPopup(
            message: message,
            onTap: onTap,
            entry: entry,
          ),
        ),
      ),
    );

    overlay.insert(entry);
  }

  @override
  ConsumerState<NotificationPopup> createState() => _NotificationPopupState();
}

class _NotificationPopupState extends ConsumerState<NotificationPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _controller.reverse();
        _removeSelf();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _removeSelf() {
    widget.entry.remove();
  }

  Widget _getMessage(Color textColor) {
    final message = widget.message;
    final sender = message.senderDisplayName.isNotEmpty
        ? message.senderDisplayName
        : '새 메시지';

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '[ $sender ]  ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          TextSpan(
            text: message.content,
            style: TextStyle(color: textColor),
          ),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final maxPopupWidth = screenWidth * 0.8; // 화면 너비의 80%

    final popupColor = isDark ? Colors.grey.shade700 : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return SlideTransition(
      position: _offsetAnimation,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Material(
          elevation: Sizes.size6,
          borderRadius: BorderRadius.circular(Sizes.size20),
          color: popupColor,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: maxPopupWidth,
            ),
            decoration: BoxDecoration(
              color: popupColor,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size8,
              vertical: Sizes.size4,
            ),
            margin: const EdgeInsets.symmetric(
                horizontal: Sizes.size20, vertical: Sizes.size10),
            child: _getMessage(textColor),
          ),
        ),
      ),
    );
  }
}
