import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snapster_app/constants/gaps.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/video/models/video_player_state_model.dart';
import 'package:snapster_app/features/video/models/video_post_model.dart';
import 'package:snapster_app/features/video/view_models/video_player_view_model.dart';
import 'package:snapster_app/features/video_old/view_models/playback_config_view_model.dart';
import 'package:snapster_app/features/video_old/views/widgets/video_caption.dart';
import 'package:snapster_app/utils/profile_network_img.dart';

class VideoPageElements extends ConsumerStatefulWidget {
  final VideoPostModel video;
  final VideoPlayerState state;
  final VideoPlayerViewModel videoPlayer;

  const VideoPageElements({
    super.key,
    required this.video,
    required this.state,
    required this.videoPlayer,
  });

  @override
  ConsumerState<VideoPageElements> createState() => _VideoPageElementsState();
}

class _VideoPageElementsState extends ConsumerState<VideoPageElements>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  bool _showPlayButton = false;
  final _animationDuration = const Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 2.0,
      value: 2.0,
      duration: _animationDuration,
    );
    _showPlayButton = ref.watch(playbackConfigProvider).autoplay;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _togglePlay(VideoPlayerViewModel videoPlayer) {
    if (!_showPlayButton) _showPlayButton = true;
    videoPlayer.togglePlay();
  }

  List<Widget> _getPageElements() {
    VideoPlayerViewModel videoPlayer = widget.videoPlayer;
    VideoPlayerState state = widget.state;

    return [
      Positioned.fill(
        child: GestureDetector(
          onTap: () => _togglePlay(videoPlayer),
        ),
      ),
      _getVideoPlayIcon(state.isPlaying),
      _getUserAndVideoCaption(widget.video),
      Positioned(
        bottom: 25,
        right: 15,
        child: Column(
          children: [
            _getMutedIcon(videoPlayer, state.isMuted),
            Gaps.v24,
            _getUploadUserProfile(widget.video.userProfileImageUrl),
            // Gaps.v12,
            // GestureDetector(
            //   onTap: _onTapLike,
            //   child: VideoButton(
            //     icon: FontAwesomeIcons.solidHeart,
            //     iconColor: _isLiked ? Colors.red : Colors.white,
            //     text: S.of(context).likeCount(_likeCount),
            //   ),
            // ),
            // Gaps.v24,
            // GestureDetector(
            //   onTap: () => _onTapComments(context),
            //   child: VideoButton(
            //     icon: FontAwesomeIcons.solidCommentDots,
            //     iconColor: Colors.white,
            //     text: S.of(context).commentCount(_commentCount),
            //   ),
            // ),
            // Gaps.v24,
            // VideoButton(
            //   icon: FontAwesomeIcons.share,
            //   iconColor: Colors.white,
            //   text: S.of(context).share,
            // ),
            Gaps.v20,
          ],
        ),
      )
    ];
  }

  Widget _getVideoPlayIcon(bool isPlaying) {
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
                    opacity: isPlaying ? 0 : 1,
                    child: const FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: Sizes.size72,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _getUserAndVideoCaption(VideoPostModel video) {
    return Positioned(
      bottom: 25,
      left: 15,
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

  Widget _getMutedIcon(VideoPlayerViewModel videoPlayer, bool isMuted) {
    return GestureDetector(
      onTap: videoPlayer.toggleMute,
      child: FaIcon(
        isMuted ? FontAwesomeIcons.volumeXmark : FontAwesomeIcons.volumeHigh,
        color: Colors.white,
        size: Sizes.size24,
      ),
    );
  }

  Widget _getUploadUserProfile(String profileImageUrl) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      foregroundImage: getProfileImgByUserProfileImageUrl(
        profileImageUrl.isNotEmpty,
        profileImageUrl,
        false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ..._getPageElements(),
    ]);
  }
}
