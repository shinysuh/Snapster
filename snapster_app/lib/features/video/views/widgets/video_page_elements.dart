import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:media_kit/media_kit.dart';
import 'package:snapster_app/constants/gaps.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/video/models/video_post_model.dart';
import 'package:snapster_app/features/video/views/widgets/video_caption.dart';
import 'package:snapster_app/features/video_old/views/widgets/video_button.dart';
import 'package:snapster_app/generated/l10n.dart';
import 'package:snapster_app/utils/profile_network_img.dart';

class VideoPageElements extends ConsumerStatefulWidget {
  final VideoPostModel video;
  final Player player;
  final bool isMuted;

  const VideoPageElements({
    super.key,
    required this.video,
    required this.player,
    required this.isMuted,
  });

  @override
  ConsumerState<VideoPageElements> createState() => _VideoPageElementsState();
}

class _VideoPageElementsState extends ConsumerState<VideoPageElements>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final AnimationController _likeAnimationController;
  final _animationDuration = const Duration(milliseconds: 200);

  bool _showPlayButton = false;
  bool _showHeart = false;

  bool _isMuted = false;
  bool _isLiked = false;
  int _likeCount = 0;
  int _commentCount = 0;

  @override
  void initState() {
    super.initState();
    _showPlayButton = widget.player.state.playing;
    _isMuted = widget.isMuted;

    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 2.0,
      value: 2.0,
      duration: _animationDuration,
    );

    _likeAnimationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 2.0,
      value: 2.0,
      duration: _animationDuration,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _likeAnimationController.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (widget.player.state.playing) {
      widget.player.pause();
      _animationController.reverse();
      setState(() {
        _showPlayButton = true;
      });
    } else {
      widget.player.play();
      _animationController.forward(from: 1.0).then((_) {
        setState(() {
          _showPlayButton = false; // 애니메이션 끝나고 숨김
        });
      });
    }

    setState(() {});
  }

  void _toggleMuted() {
    setState(() {
      _isMuted = !_isMuted;
    });

    widget.player.setVolume(_isMuted ? 0 : 100);
  }

  void _onDoubleTap() {
    // 하트 애니메이션 추가
    setState(() {
      _showHeart = true;
    });

    _likeAnimationController.forward(from: 1.0);
    if (!_isLiked) _onTapLike();  // 좋아요 취소는 더블탭으로 안됨

    // 2초 후에 사라지게
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showHeart = false;
        });
      }
    });
  }

  void _onTapLike() {
    // ref
    //     .read(videoPostProvider(_videoId).notifier)
    //     .toggleLikeVideo(widget.videoData.thumbnailURL);

    setState(() {
      //   !_isLiked ? _likeCount++ : _likeCount--; // db를 직접 찌르지 않음 -> 금전적 이유
      _isLiked = !_isLiked;
    });
  }

  void _onChangeCommentCount(int commentCount) {
    // setState(() {
    //   _commentCount = commentCount;
    // });
  }

  void _onTapComments(BuildContext context) async {
    // if (widget.player.state.playing) _togglePlay();
    //
    // await showModalBottomSheet(
    //   context: context,
    //   backgroundColor: Colors.transparent,
    //   isScrollControlled: true,
    //   builder: (context) => VideoComments(
    //     videoId: _videoId,
    //     commentCount: _commentCount,
    //     onChangeCommentCount: _onChangeCommentCount,
    //   ),
    // );
    //
    // _togglePlay();
  }

  Widget _getVideoPlayIcon() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _animationController.value,
                child: child,
              );
            },
            child: _showPlayButton
                ? AnimatedOpacity(
                    duration: _animationDuration,
                    opacity: widget.player.state.playing ? 0 : 1,
                    child: const FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: Sizes.size36,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _getLikeAnimation() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _showHeart ? 1 : 0,
            child: AnimatedBuilder(
              animation: _likeAnimationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _likeAnimationController.value,
                  child: child,
                );
              },
              child: const FaIcon(
                FontAwesomeIcons.solidHeart,
                color: Colors.red,
                size: Sizes.size32,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getUserAndVideoCaption(VideoPostModel video) {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + Sizes.size32,
      left: Sizes.size16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '@${video.userDisplayName}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: Sizes.size20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gaps.v18,
          if (video.description.isNotEmpty)
            VideoCaption(
              description: video.description,
              tags: video.tags,
            ),
        ],
      ),
    );
  }

  Widget _getMutedIcon() {
    return GestureDetector(
      onTap: _toggleMuted,
      child: FaIcon(
        widget.isMuted
            ? FontAwesomeIcons.volumeXmark
            : FontAwesomeIcons.volumeHigh,
        color: Colors.white,
        size: Sizes.size24,
      ),
    );
  }

  Widget _getUploadUserProfile(String profileImageUrl) {
    return CircleAvatar(
      radius: Sizes.size24 + Sizes.size1,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      foregroundImage: getProfileImgByUserProfileImageUrl(
        profileImageUrl.isNotEmpty,
        profileImageUrl,
        false,
      ),
    );
  }

  Widget _getLikeButton() {
    return GestureDetector(
      onTap: _onTapLike,
      child: VideoButton(
        icon: FontAwesomeIcons.solidHeart,
        iconColor: _isLiked ? Colors.red : Colors.white,
        text: S.of(context).likeCount(_likeCount),
      ),
    );
  }

  Widget _getCommentButton() {
    return GestureDetector(
      onTap: () => _onTapComments(context),
      child: VideoButton(
        icon: FontAwesomeIcons.solidCommentDots,
        iconColor: Colors.white,
        text: S.of(context).commentCount(_commentCount),
      ),
    );
  }

  Widget _getShareButton() {
    return VideoButton(
      icon: FontAwesomeIcons.share,
      iconColor: Colors.white,
      text: S.of(context).share,
    );
  }

  List<Widget> _getPageElements() {
    return [
      Positioned.fill(
        child: GestureDetector(
          onTap: () => _togglePlay(),
          onDoubleTap: _onDoubleTap,
        ),
      ),
      _getVideoPlayIcon(),
      _getLikeAnimation(),
      _getUserAndVideoCaption(widget.video),
      Positioned(
        bottom: MediaQuery.of(context).padding.bottom + Sizes.size26,
        right: Sizes.size16,
        child: Column(
          children: [
            _getMutedIcon(),
            Gaps.v24,
            _getUploadUserProfile(widget.video.userProfileImageUrl),
            Gaps.v12,
            _getLikeButton(),
            Gaps.v24,
            _getCommentButton(),
            Gaps.v24,
            _getShareButton(),
            Gaps.v96,
          ],
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ..._getPageElements(),
    ]);
  }
}
