import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';

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
            duration: const Duration(microseconds: 800),
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size16,
            ),
            decoration: BoxDecoration(
              color: isDisabled
                  ? Colors.grey.shade200
                  : Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(Sizes.size5),
            ),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(microseconds: 800),
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
