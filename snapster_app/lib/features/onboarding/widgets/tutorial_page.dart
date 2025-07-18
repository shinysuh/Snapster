import 'package:flutter/cupertino.dart';
import 'package:snapster_app/constants/gaps.dart';
import 'package:snapster_app/constants/sizes.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage({
    super.key,
    required this.title,
    required this.content,
  });

  final String title, content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gaps.v80,
        Text(
          title,
          style: const TextStyle(
            fontSize: Sizes.size40,
            fontWeight: FontWeight.bold,
          ),
        ),
        Gaps.v16,
        Text(
          content,
          style: const TextStyle(
            fontSize: Sizes.size20,
          ),
        ),
      ],
    );
  }
}
