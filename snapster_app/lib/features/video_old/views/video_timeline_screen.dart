import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/video_old/view_models/timeline_view_model.dart';
import 'package:snapster_app/features/video_old/views/widgets/video_post.dart';

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

  void _onVideoFinished() {
    // ** 동영상 완료 후 다음 영상으로 자동 넘김
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

  /* RefreshIndicator 의 onRefresh 는 반드시 Future 리턴 */
  Future<void> _onRefresh() {
    // return Future.delayed(const Duration(seconds: 3));
    return ref.watch(timelineProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    /* PageView.builder() => ListView.builder() 와 마찬가지로
    *  일괄적으로 모든 아이템을 생성하는 것이 아니라
    *  스크롤에 따라 아이템을 render
    *  */

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
                // pageSnapping: false, // true: 한번에 하나의 페이지 보게 (걸침 X, 멀티 스크롤 X)
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

    // return RefreshIndicator(
    //   onRefresh: _onRefresh,
    //   displacement: 50,
    //   edgeOffset: 20,
    //   color: Theme.of(context).primaryColor,
    //   child: PageView.builder(
    //     controller: _pageController,
    //     // pageSnapping: false, // true: 한번에 하나의 페이지 보게 (걸침 X, 멀티 스크롤 X)
    //     scrollDirection: Axis.vertical,
    //     itemCount: _itemCount,
    //     onPageChanged: _onPageChanged,
    //     itemBuilder: (context, index) => VideoPost(
    //       onVideoFinished: _onVideoFinished,
    //       pageIndex: index,
    //     ),
    //   ),
    // );
  }
}
