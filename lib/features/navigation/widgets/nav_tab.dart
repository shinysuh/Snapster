import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';

class NavTab extends StatelessWidget {
  const NavTab({
    super.key,
    required this.isSelected,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final bool isSelected;
  final String label;
  final IconData icon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          color: Colors.black,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 100),
            opacity: isSelected ? 1 : 0.65,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  icon,
                  color: Colors.white,
                ),
                Gaps.v5,
                Text(
                  label,
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
