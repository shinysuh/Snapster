import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/profile_images.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/utils/tap_to_unfocus.dart';
import 'package:tiktok_clone/utils/theme_mode.dart';
import 'package:tiktok_clone/utils/widgets/regulated_max_width.dart';

class VideoComments extends StatefulWidget {
  const VideoComments({super.key});

  @override
  State<VideoComments> createState() => _VideoCommentsState();
}

class _VideoCommentsState extends State<VideoComments> {
  bool _isWriting = false;

  final ScrollController _scrollController = ScrollController();

  void _closePopup() {
    Navigator.of(context).pop();
  }

  void _onTapSubmitComment() {
    _dismissKeyboard();
  }

  void _dismissKeyboard() {
    onTapOutsideAndDismissKeyboard(context);
    setState(() {
      _isWriting = false;
    });
  }

  void _onStartWriting() {
    setState(() {
      _isWriting = true;
    });
  }

  Widget _getCommentField(bool isDark) {
    var iconColor = isDark ? Colors.grey.shade400 : Colors.grey.shade900;
    return TextField(
      onTap: _onStartWriting,
      expands: true,
      minLines: null,
      maxLines: null,
      textInputAction: TextInputAction.newline,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        hintText: 'Add comment...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.size8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Sizes.size10,
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: Sizes.size14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.at,
                color: iconColor,
              ),
              Gaps.h14,
              FaIcon(
                FontAwesomeIcons.gift,
                color: iconColor,
              ),
              Gaps.h14,
              FaIcon(
                FontAwesomeIcons.faceSmile,
                color: iconColor,
              ),
              if (_isWriting) Gaps.h14,
              if (_isWriting)
                GestureDetector(
                  onTap: _onTapSubmitComment,
                  child: FaIcon(
                    FontAwesomeIcons.circleArrowUp,
                    color: Theme.of(context).primaryColor,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = isDarkMode(context);

    return SizedBox(
      height: size.height * 0.7,
      child: RegulatedMaxWidth(
        maxWidth: Breakpoints.sm,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            Sizes.size14,
          ),
        ),
        child: Scaffold(
          backgroundColor: isDark ? null : Colors.grey.shade50,
          appBar: AppBar(
            backgroundColor: isDark
                ? Theme.of(context).appBarTheme.surfaceTintColor
                : Colors.grey.shade50,
            centerTitle: true,
            title: Text(
              S.of(context).commentTitle(22796, 22796),
              style: const TextStyle(
                fontSize: Sizes.size16,
                fontWeight: FontWeight.w600,
              ),
            ),
            // automaticallyImplyLeading: 자동으로 back 버튼 생성 여부
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: _closePopup,
                icon: const FaIcon(
                  FontAwesomeIcons.xmark,
                  size: Sizes.size22,
                ),
              ),
            ],
          ),
          body: GestureDetector(
            onTap: _dismissKeyboard,
            child: Stack(
              children: [
                Scrollbar(
                  controller: _scrollController,
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(
                      top: Sizes.size10,
                      bottom: Sizes.size96 + Sizes.size24,
                      left: Sizes.size16,
                      right: Sizes.size16,
                    ),
                    itemCount: 10,
                    separatorBuilder: (context, index) => Gaps.v20,
                    itemBuilder: (context, index) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: Sizes.size18,
                          backgroundColor: isDark ? Colors.grey.shade500 : null,
                          child: const Text('쩨나'),
                        ),
                        Gaps.h10,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'jenna123',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: Sizes.size14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Gaps.v3,
                              const Text(
                                  'He is such an adorable creature. The prettiest baby I\'ve ever seen XD'),
                            ],
                          ),
                        ),
                        Gaps.v10,
                        Column(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.heart,
                              color: Colors.grey.shade500,
                              size: Sizes.size20,
                            ),
                            Gaps.v2,
                            Text(
                              S.of(context).commentLikeCount(52200),
                              style: TextStyle(
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  width: size.width,
                  child: Container(
                    color: Theme.of(context).bottomAppBarTheme.surfaceTintColor,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: Sizes.size16,
                        right: Sizes.size16,
                        top: Sizes.size10,
                        bottom: Sizes.size32,
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          var isWiderThanSm = constraints.maxWidth >
                              Breakpoints.sm - Sizes.size32;
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: Sizes.size18,
                                backgroundColor: Colors.grey.shade500,
                                foregroundColor: Colors.white,
                                foregroundImage: profileImage,
                                child: const Text('쩨나'),
                              ),
                              Gaps.h10,
                              if (isWiderThanSm)
                                Container(
                                  height: Sizes.size44,
                                  constraints: const BoxConstraints(
                                    maxWidth: Breakpoints.sm - Sizes.size80,
                                  ),
                                  child: _getCommentField(isDark),
                                ),
                              if (!isWiderThanSm)
                                Expanded(
                                  child: SizedBox(
                                    height: Sizes.size44,
                                    child: _getCommentField(isDark),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
