import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/video/view_models/timeline_view_model.dart';
import 'package:tiktok_clone/features/video/views/widgets/video_post.dart';

class VideoTimelineScreen extends ConsumerStatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  VideoTimelineScreenState createState() => VideoTimelineScreenState();
}

class VideoTimelineScreenState extends ConsumerState<VideoTimelineScreen> {
  static const basicItemCount = 0;
  int _itemCount = basicItemCount;

  final PageController _pageController = PageController();
  final Duration _scrollDuration = const Duration(milliseconds: 200);
  final Curve _scrollCurve = Curves.linear;

  void _onPageChanged(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
      duration: _scrollDuration,
      curve: _scrollCurve,
    );

    if (pageIndex == _itemCount - 1) {
      ref.read(timelineProvider.notifier).fetchNextPage();
    }
  }

  // ** 동영상 완료 후 다음 영상으로 자동 넘김 (not using)
  void _onVideoFinished() {
    _pageController.nextPage(
      duration: _scrollDuration,
      curve: _scrollCurve,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() {
    return ref.watch(timelineProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(timelineProvider).when(
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: Colors.white,
            ),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              'Could not load videos: \n$error',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          data: (videos) {
            _itemCount = videos.length;
            final isEmpty = _itemCount < 2 && videos.first.id.isEmpty;
            return RefreshIndicator(
              onRefresh: _onRefresh,
              displacement: 50,
              edgeOffset: 20,
              color: Theme.of(context).primaryColor,
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: videos.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final videoData = videos[index];
                  return VideoPost(
                    isEmpty: isEmpty,
                    onVideoFinished: _onVideoFinished,
                    pageIndex: index,
                    videoData: videoData,
                  );
                },
              ),
            );
          },
        );
  }
}
