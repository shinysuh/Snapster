import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/common/auth_button.dart';
import 'package:tiktok_clone/features/authentication/common/common_redirection.dart';
import 'package:tiktok_clone/features/authentication/email_screen.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/username_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  void _onTapLogin(BuildContext context) {
    redirectToScreen(context, const LoginScreen());
  }

  void _onTapEmailAndPassword(BuildContext context) {
    redirectToScreen(context, const UsernameScreen());
  }

  void _onTapAppleLogin(BuildContext context) {
    redirectToScreen(context, const EmailScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.size40),
          child: Column(
            children: [
              Gaps.v80,
              const Text(
                'Sign Up for TikTok',
                style: TextStyle(
                  fontSize: Sizes.size26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v20,
              const Text(
                'Create a profile, follow other accounts, make your own videos, and more.',
                style: TextStyle(
                  fontSize: Sizes.size16,
                  color: Colors.black45,
                ),
                textAlign: TextAlign.center,
              ),
              Gaps.v40,
              AuthButton(
                icon: FontAwesomeIcons.user,
                text: 'Use email & password',
                onTapButton: () => _onTapEmailAndPassword(context),
              ),
              Gaps.v14,
              AuthButton(
                icon: FontAwesomeIcons.apple,
                text: 'Continue with apple',
                onTapButton: () => _onTapAppleLogin(context),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 130,
        // elevation: 2,
        // color: Colors.grey.shade50,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.grey.shade50,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Sizes.size10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account?',
                style: TextStyle(
                  fontSize: Sizes.size18,
                ),
              ),
              Gaps.h5,
              GestureDetector(
                onTap: () => _onTapLogin(context),
                child: Text(
                  'Log in',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: Sizes.size18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
