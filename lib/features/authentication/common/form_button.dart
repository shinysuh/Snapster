import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils/theme_mode.dart';

class FormButton extends StatelessWidget {
  const FormButton({
    super.key,
    required this.isDisabled,
    required this.onTapButton,
    required this.buttonText,
  });

  final bool isDisabled;
  final Function onTapButton;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: GestureDetector(
        onTap: isDisabled ? () {} : () => onTapButton(),
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size16,
            ),
            decoration: BoxDecoration(
              color: isDisabled
                  ? isDarkMode(context)
                      ? Colors.grey.shade800
                      : Colors.grey.shade200
                  : Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(Sizes.size5),
            ),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: isDisabled ? Colors.grey.shade400 : Colors.white,
                fontSize: Sizes.size16,
                fontWeight: FontWeight.w600,
              ),
              child: Text(
                buttonText,
                textAlign: TextAlign.center,
              ),
            )),
      ),
    );
  }
}
