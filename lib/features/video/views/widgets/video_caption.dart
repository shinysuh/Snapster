import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class VideoCaption extends StatefulWidget {
  final String description;
  final List<dynamic> tags;

  const VideoCaption({
    super.key,
    required this.description,
    required this.tags,
  });

  @override
  State<VideoCaption> createState() => _VideoCaptionState();
}

class _VideoCaptionState extends State<VideoCaption> {
  final double maxOpenedHeight = 250.0;
  final double closedHeight = 30.0;
  final int _cutLength = 20;
  final ScrollController _scrollController = ScrollController();

  String _caption = '';
  bool _isCaptionOpened = false;
  bool _isWithEllipsis = true;
  List<dynamic> _tags = [
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
    _caption = widget.description;
    // _caption = 'weailgrh v aei udhgvo eidsrf jvzcilsdzjc';
    // _caption += 'weailgrh v aei udhgvo eidsrf jvzcilsdzjc' * 13;
    _isWithEllipsis = _caption.length > _cutLength;
    _tags = widget.tags;
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

  double _calculateTextHeight(String text, TextStyle style, double maxWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: null,
      textDirection: TextDirection.ltr,
    )..layout(
        maxWidth: maxWidth,
      );
    return textPainter.size.height + 38;
  }

  Widget _getDisplayCaption() {
    if (_caption.isEmpty) return Container();
    var displayCaption = _caption;

    if (!_isCaptionOpened && _isWithEllipsis) {
      displayCaption = displayCaption.substring(0, _cutLength);
    }

    return _isCaptionOpened
        ? _getOpenedCaption(displayCaption)
        : _getClosedCaption(displayCaption);
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

  Widget _getClosedCaption(String caption) {
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
        if (_isWithEllipsis)
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
    const TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: Sizes.size16,
    );

    final double textHeight = _calculateTextHeight(
      _caption,
      textStyle,
      Breakpoints.sm / 2,
    );

    final double containerHeight = _isCaptionOpened
        ? (textHeight +
                (_tags.isNotEmpty
                    ? 18.0 +
                        _calculateTextHeight(
                            _tags.join(' '), textStyle, Breakpoints.sm / 2)
                    : 0))
            .clamp(closedHeight, maxOpenedHeight)
        : closedHeight;

    return GestureDetector(
      onTap: _isWithEllipsis ? _toggleCaption : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: containerHeight,
        child: _getDisplayCaption(),
      ),
    );
  }
}
