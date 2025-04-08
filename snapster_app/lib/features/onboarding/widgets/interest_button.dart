import 'package:flutter/material.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/utils/theme_mode.dart';

class InterestButton extends StatefulWidget {
  const InterestButton({
    super.key,
    required this.interest,
  });

  final String interest;

  @override
  State<InterestButton> createState() => _InterestButtonState();
}

class _InterestButtonState extends State<InterestButton> {
  bool _isSelected = false;

  void _onTapButton() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    return GestureDetector(
      onTap: _onTapButton,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size16 + Sizes.size1,
          horizontal: Sizes.size20,
        ),
        decoration: BoxDecoration(
          color: _isSelected
              ? Theme.of(context).primaryColor
              : isDark
                  ? Colors.grey.shade700
                  : Colors.white,
          border: Border.all(
            color: Colors.black.withOpacity(0.07),
          ),
          borderRadius: BorderRadius.circular(
            Sizes.size32,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              spreadRadius: 5,
              offset: const Offset(5, 5),
            ),
          ],
        ),
        child: Text(
          widget.interest,
          style: TextStyle(
            fontSize: Sizes.size16,
            fontWeight: FontWeight.w600,
            color: _isSelected
                ? Colors.white
                : isDark
                    ? Colors.white.withOpacity(0.8)
                    : Colors.black87,
          ),
        ),
      ),
    );
  }
}
