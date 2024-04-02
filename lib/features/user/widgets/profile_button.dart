import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils/theme_mode.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.iconSize,
    required this.padding,
  });

  final IconData icon;
  final double iconSize;
  final EdgeInsets padding;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Sizes.size44,
      height: Sizes.size44 + Sizes.size2,
      padding: padding,
      decoration: BoxDecoration(
        color: isDarkMode(context) ? Colors.grey.shade700 : Colors.white,
        borderRadius: BorderRadius.circular(Sizes.size2),
        border: Border.all(
          color:
              isDarkMode(context) ? Colors.grey.shade700 : Colors.grey.shade300,
        ),
      ),
      child: Center(
        child: FaIcon(
          icon,
          size: iconSize,
        ),
      ),
    );
  }
}
