import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snapster_app/constants/gaps.dart';

class NavTab extends StatelessWidget {
  const NavTab({
    super.key,
    required this.isHome,
    required this.isSelected,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.onTap,
  });

  final bool isHome;
  final bool isSelected;
  final String label;
  final IconData icon, selectedIcon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          color: isHome ? Colors.black : Colors.white,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 100),
            opacity: isSelected ? 1 : 0.65,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  isSelected ? selectedIcon : icon,
                  color: isHome ? Colors.white : Colors.black,
                ),
                Gaps.v5,
                Text(
                  label,
                  style: TextStyle(
                    color: isHome ? Colors.white : Colors.black,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
