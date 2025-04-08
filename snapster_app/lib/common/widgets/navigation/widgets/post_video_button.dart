import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snapster_app/constants/sizes.dart';

class PostVideoButton extends StatefulWidget {
  const PostVideoButton({
    super.key,
    required this.isClicked,
    required this.inverted,
  });

  final bool isClicked;
  final bool inverted;

  @override
  State<PostVideoButton> createState() => _PostVideoButtonState();
}

class _PostVideoButtonState extends State<PostVideoButton> {
  @override
  Widget build(BuildContext context) {
    const plusIconHeight = Sizes.size32;
    const plusColorPosition = Sizes.size20;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 100),
          right: widget.isClicked
              ? plusColorPosition + Sizes.size4
              : plusColorPosition,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size8,
            ),
            height: plusIconHeight,
            width: Sizes.size24 + Sizes.size1,
            decoration: BoxDecoration(
              color: const Color(0xFF61D4F0),
              borderRadius: BorderRadius.circular(Sizes.size7),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 100),
          left: widget.isClicked
              ? plusColorPosition + Sizes.size4
              : plusColorPosition,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size8,
            ),
            height: plusIconHeight,
            width: Sizes.size24 + Sizes.size1,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(Sizes.size8),
            ),
          ),
        ),
        Container(
          height: plusIconHeight,
          padding: const EdgeInsets.symmetric(horizontal: Sizes.size12),
          decoration: BoxDecoration(
            color: widget.inverted ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(Sizes.size8),
          ),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.plus,
              color: widget.inverted ? Colors.white : Colors.black,
              size: Sizes.size18,
            ),
          ),
        )
      ],
    );
  }
}
