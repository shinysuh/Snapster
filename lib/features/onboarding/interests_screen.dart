import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/interests.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/onboarding/tutorial_screen.dart';
import 'package:tiktok_clone/features/onboarding/widgets/interest_button.dart';
import 'package:tiktok_clone/utils/navigator_redirection.dart';
import 'package:tiktok_clone/utils/theme_mode.dart';

class InterestScreen extends StatefulWidget {
  const InterestScreen({super.key});

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  final ScrollController _scrollController = ScrollController();

  bool _isTitleShown = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 100) {
      if (!_isTitleShown) {
        setState(() {
          _isTitleShown = true;
        });
      }
    } else {
      setState(() {
        _isTitleShown = false;
      });
    }
  }

  void _onTapNext() {
    redirectToScreen(context: context, targetScreen: const TutorialScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _isTitleShown ? 1 : 0,
          child: const Text(
            'Choose your interests',
          ),
        ),
      ),
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.only(
              right: Sizes.size24,
              left: Sizes.size24,
              bottom: Sizes.size16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.v32,
                const Text(
                  'Choose your interests',
                  style: TextStyle(
                    fontSize: Sizes.size40 + Sizes.size2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gaps.v20,
                const Text(
                  'Get better video recommendations',
                  style: TextStyle(
                    fontSize: Sizes.size20,
                    color: Colors.black54,
                  ),
                ),
                Gaps.v48,
                Wrap(
                  spacing: Sizes.size14,
                  runSpacing: Sizes.size20,
                  children: [
                    for (var interest in interests)
                      InterestButton(interest: interest)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: Sizes.size40,
            top: Sizes.size16,
            left: Sizes.size24,
            right: Sizes.size24,
          ),
          child: FractionallySizedBox(
            widthFactor: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BottomButton(
                  text: 'Skip',
                  onTap: _onTapNext,
                ),
                Gaps.h20,
                BottomButton(
                  buttonColor: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  text: 'Next',
                  onTap: _onTapNext,
                ),
              ],
            ),
          ),
          // 편한 기능의 버튼 CupertinoButton(custom) / TextButton(google like)
          // CupertinoButton(
          //   onPressed: () {},
          //   color: Theme.of(context).primaryColor,
          //   child: const Text('Next'),
          // ),
        ),
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  const BottomButton({
    super.key,
    this.buttonColor,
    this.textColor,
    required this.text,
    required this.onTap,
  });

  final Color? buttonColor, textColor;
  final String text;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size16,
          horizontal: Sizes.size64 + Sizes.size4,
        ),
        decoration: BoxDecoration(
            color: buttonColor ??
                (isDarkMode(context) ? Colors.grey.shade700 : Colors.white),
            border: Border.all(
              color: Colors.black12,
            )),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: Sizes.size16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
