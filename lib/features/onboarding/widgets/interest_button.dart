import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';

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
    return GestureDetector(
      onTap: _onTapButton,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size16 + Sizes.size1,
          horizontal: Sizes.size20,
        ),
        decoration: BoxDecoration(
          color: _isSelected ? Theme.of(context).primaryColor : Colors.white,
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
            color: _isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
