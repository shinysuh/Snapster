import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/common/auth_button.dart';
import 'package:tiktok_clone/features/authentication/login_form_screen.dart';
import 'package:tiktok_clone/utils/navigator_redirection.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _onTapSignUp(BuildContext context) {
    goBackToPreviousPage(context);
  }

  void _onTapEmailAndPassword(BuildContext context) {
    redirectToScreen(context: context, targetScreen: const LoginFormScreen());
  }

  void _onTapAppleLogin(BuildContext context) {
    // redirectToScreen(context: context, targetScreen: const LoginFormScreen());
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
                'Log in to TikTok',
                style: TextStyle(
                  fontSize: Sizes.size26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v20,
              const Text(
                'Manage your account, check notifications, comment on videos, and more.',
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Sizes.size32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Don\'t have an account?',
                style: TextStyle(
                  fontSize: Sizes.size18,
                ),
              ),
              Gaps.h5,
              GestureDetector(
                onTap: () => _onTapSignUp(context),
                child: Text(
                  'Sign up',
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
