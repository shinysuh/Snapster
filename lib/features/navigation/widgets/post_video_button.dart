import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class PostVideoButton extends StatelessWidget {
  const PostVideoButton({super.key});

  @override
  Widget build(BuildContext context) {
    const plusIconHeight = Sizes.size32;
    const plusColorPosition = Sizes.size20;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          right: plusColorPosition,
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
        Positioned(
          left: plusColorPosition,
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(Sizes.size8),
          ),
          child: const Center(
            child: FaIcon(
              FontAwesomeIcons.plus,
              color: Colors.black,
              size: Sizes.size18,
            ),
          ),
        )
      ],
    );
  }
}
