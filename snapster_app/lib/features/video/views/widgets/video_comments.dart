import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snapster_app/constants/breakpoints.dart';
import 'package:snapster_app/constants/gaps.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/user/models/user_profile_model.dart';
import 'package:snapster_app/features/user/view_models/user_view_model.dart';
import 'package:snapster_app/features/video/view_models/comment_view_model.dart';
import 'package:snapster_app/generated/l10n.dart';
import 'package:snapster_app/utils/profile_network_img.dart';
import 'package:snapster_app/utils/tap_to_unfocus.dart';
import 'package:snapster_app/utils/theme_mode.dart';
import 'package:snapster_app/utils/widgets/regulated_max_width.dart';

class VideoComments extends ConsumerStatefulWidget {
  final String videoId;
  final int commentCount;
  final void Function(int) onChangeCommentCount;

  const VideoComments({
    super.key,
    required this.videoId,
    required this.commentCount,
    required this.onChangeCommentCount,
  });

  @override
  ConsumerState<VideoComments> createState() => _VideoCommentsState();
}

class _VideoCommentsState extends ConsumerState<VideoComments> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();

  bool _isWriting = false;
  late int _commentCount = widget.commentCount;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _closePopup() {
    Navigator.of(context).pop();
  }

  Future<void> _onTapSubmitComment(UserProfileModel user) async {
    if (_textEditingController.text.trim().isEmpty) return;

    await ref.read(commentProvider(widget.videoId).notifier).saveComment(
          context: context,
          user: user,
          comment: _textEditingController.text,
        );

    widget.onChangeCommentCount(widget.commentCount + 1);
    _textEditingController.clear();
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

  Widget _getCommentField(UserProfileModel user, bool isDark) {
    var iconColor = isDark ? Colors.grey.shade400 : Colors.grey.shade900;
    return TextField(
      controller: _textEditingController,
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
                  onTap: () => _onTapSubmitComment(user),
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
              S.of(context).commentTitle(_commentCount, _commentCount),
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
                  child: ref.watch(commentListProvider(widget.videoId)).when(
                        loading: () => const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                        error: (error, stackTrace) => Center(
                          child: Text(error.toString()),
                        ),
                        data: (comments) {
                          _commentCount = comments.length;
                          return ListView.separated(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(
                              top: Sizes.size10,
                              bottom: Sizes.size96 + Sizes.size24,
                              left: Sizes.size16,
                              right: Sizes.size16,
                            ),
                            itemCount: comments.length,
                            separatorBuilder: (context, index) => Gaps.v20,
                            itemBuilder: (context, index) {
                              var comment = comments[index];
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: Sizes.size20,
                                    backgroundColor:
                                        isDark ? Colors.grey.shade500 : null,
                                    foregroundImage: getProfileImgByUserId(
                                      comment.userId,
                                      false,
                                    ),
                                    child:
                                        ClipOval(child: Text(comment.username)),
                                  ),
                                  Gaps.h10,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comment.username,
                                          style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: Sizes.size14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Gaps.v3,
                                        Text(comment.text),
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
                                        S
                                            .of(context)
                                            .commentLikeCount(comment.likes),
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
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
                      child: ref.watch(userProvider).when(
                          loading: () => const Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                          error: (error, stackTrace) => Center(
                                child: Text(error.toString()),
                              ),
                          data: (user) => LayoutBuilder(
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
                                        foregroundImage: getProfileImgByUserId(
                                          user.uid,
                                          false,
                                        ),
                                        child: ClipOval(child: Text(user.name)),
                                      ),
                                      Gaps.h10,
                                      if (isWiderThanSm)
                                        Container(
                                          height: Sizes.size44,
                                          constraints: const BoxConstraints(
                                            maxWidth:
                                                Breakpoints.sm - Sizes.size80,
                                          ),
                                          child: _getCommentField(user, isDark),
                                        ),
                                      if (!isWiderThanSm)
                                        Expanded(
                                          child: SizedBox(
                                            height: Sizes.size44,
                                            child:
                                                _getCommentField(user, isDark),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              )),
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
