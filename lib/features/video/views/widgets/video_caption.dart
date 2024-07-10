import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class VideoCaption extends StatefulWidget {
  final String description;

  const VideoCaption({
    super.key,
    required this.description,
  });

  @override
  State<VideoCaption> createState() => _VideoCaptionState();
}

class _VideoCaptionState extends State<VideoCaption> {
  final maxOpenedHeight = 250.0;
  final closedHeight = 30.0;

  bool _isCaptionOpened = false;

  final ScrollController _scrollController = ScrollController();
  late final String _caption = widget.description;

  final _tags = [
    // 'baby_face',
    // 'lovely',
    // 'adorable',
    // 'auntie_crying',
    // 'first_nephew',
    // 'cannot_imagine_life_without_him',
    // 'newborn',
    // 'pumpkin',
    // 'cutie_pie',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleCaption() {
    setState(() {
      _isCaptionOpened = !_isCaptionOpened;
    });
  }

  Widget _getDisplayCaption() {
    if (_caption.isEmpty) return Container();
    var cutLength = 25;
    var displayCaption = _caption;

    // var tmpRepeat = 13;
    // displayCaption += 'weailgrh v aei udhgvo eidsrf jvzcilsdzjc' * tmpRepeat;

    var isWithEllipsis = displayCaption.length > cutLength;

    if (!_isCaptionOpened && isWithEllipsis) {
      displayCaption = displayCaption.substring(0, cutLength);
    }

    return _isCaptionOpened
        ? _getOpenedCaption(displayCaption)
        : _getClosedCaption(displayCaption, isWithEllipsis);
  }

  Widget _getOpenedCaption(String caption) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: Breakpoints.sm / 2,
        ),
        child: Column(
          children: [
            Text(
              caption,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Colors.white,
                fontSize: Sizes.size16,
              ),
            ),
            Gaps.v18,
            if (_tags.isNotEmpty) _getTags(),
          ],
        ),
      ),
    );
  }

  Widget _getClosedCaption(String caption, bool isWithEllipsis) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          caption,
          textAlign: TextAlign.left,
          style: const TextStyle(
            color: Colors.white,
            fontSize: Sizes.size16,
          ),
        ),
        if (isWithEllipsis)
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
    );
  }

  Widget _getTags() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: Sizes.size16,
        runSpacing: Sizes.size3,
        children: [
          for (var tag in _tags)
            Text(
              '#$tag',
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: Sizes.size16,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCaption,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: _isCaptionOpened ? maxOpenedHeight : closedHeight,
        child: _getDisplayCaption(),
      ),
    );
  }
}
