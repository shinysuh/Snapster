import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/video/views/widgets/video_tags.dart';

class VideoCaption extends StatefulWidget {
  const VideoCaption({super.key});

  @override
  State<VideoCaption> createState() => _VideoCaptionState();
}

class _VideoCaptionState extends State<VideoCaption> {
  bool _isCaptionOpened = false;

  final ScrollController _scrollController = ScrollController();
  final _caption =
      'This is my baby nephew! He was born in Feb 2024 and just turn to 3 weeks old:) So happy to finally have a little nephew whom I can give my love and passion. Soooo adorable!! Let\'s make these sentences longer and longer until they become seven lines.';
  final _tags = [
    'baby_face',
    'lovely',
    'adorable',
    'auntie_crying',
    'first_nephew',
    'cannot_imagine_life_without_him',
    'newborn',
    'pumpkin',
    'cutie_pie',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrollCaption);
  }

  void _onScrollCaption() {
    // print(_scrollController.offset);
    if (_scrollController.offset > 100) {}
  }

  void _toggleCaption() {
    setState(() {
      _isCaptionOpened = !_isCaptionOpened;
    });
  }

  String _getCaption() {
    var displayCaption = _caption;
    var length = 27;
    if (!_isCaptionOpened && displayCaption.length > length) {
      displayCaption = displayCaption.substring(0, length);
    } else {}
    return displayCaption;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCaption,
      child: IgnoreBaseline(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: _isCaptionOpened ? 250 : 30, // TODO - 스크롤 적용 후 수정
          width: 320,
          child: _isCaptionOpened
              /*
                 TODO - 캡션 toggle 시에 스크롤 적용 해야 함
              */
              ? Column(
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        // controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              RichText(
                                overflow: TextOverflow.fade,
                                maxLines: 7, // TODO - 스크롤 적용 후 수정
                                strutStyle: const StrutStyle(
                                  fontSize: Sizes.size16,
                                ),
                                text: TextSpan(
                                  text: _getCaption(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: Sizes.size16,
                                  ),
                                ),
                              ),
                              Gaps.v14,
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Wrap(
                                  runAlignment: WrapAlignment.start,
                                  spacing: Sizes.size12,
                                  runSpacing: Sizes.size3,
                                  children: [
                                    for (var tag in _tags) VideoTags(tag: tag)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          _getCaption(),
                          // maxLines: 5,
                          // overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: Sizes.size16,
                          ),
                        ),
                        const Text(
                          '... See More',
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Sizes.size16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
