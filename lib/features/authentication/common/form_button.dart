import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class FormButton extends StatelessWidget {
  const FormButton({
    super.key,
    required this.isDisabled,
    required this.onTapNext,
    required this.textActivated,
    this.textDisabled,
  });

  final bool isDisabled;
  final Function onTapNext;
  final String textActivated;
  final String? textDisabled;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: GestureDetector(
        onTap: isDisabled ? () {} : () => onTapNext(),
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
                isDisabled ? textDisabled ?? textActivated : textActivated,
                textAlign: TextAlign.center,
              ),
            )),
      ),
    );
  }
}
