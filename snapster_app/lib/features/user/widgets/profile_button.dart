import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/utils/theme_mode.dart';

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
    final isDark = isDarkMode(context);
    return Container(
      width: Sizes.size44,
      height: Sizes.size44 + Sizes.size2,
      padding: padding,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade700 : Colors.white,
        borderRadius: BorderRadius.circular(Sizes.size2),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
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
