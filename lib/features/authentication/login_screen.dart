import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/common/auth_button.dart';
import 'package:tiktok_clone/features/authentication/login_form_screen.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/utils/navigator_redirection.dart';
import 'package:tiktok_clone/utils/theme_mode.dart';
import 'package:tiktok_clone/utils/widgets/regulated_max_width.dart';

class LoginScreen extends StatelessWidget {
  static const String routeURL = '/login';
  static const String routeName = 'login';

  const LoginScreen({super.key});

  void _onTapSignUp(BuildContext context) {
    goBackToPreviousRoute(context);
  }

  void _onTapEmailAndPassword(BuildContext context) {
    redirectToScreen(context: context, targetScreen: const LoginFormScreen());
  }

  void _onTapAppleLogin(BuildContext context) {
    // redirectToScreen(context: context, targetScreen: const LoginFormScreen());
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) => Scaffold(
        body: SafeArea(
          child: RegulatedMaxWidth(
            maxWidth: Breakpoints.sm,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.size40),
              child: Column(
                children: [
                  Gaps.v80,
                  Text(
                    S.of(context).logInToTiktok('TikTok'),
                    style: const TextStyle(
                      fontSize: Sizes.size26,
                      fontWeight: FontWeight.w700,
                    ),
                    // style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    //   fontWeight: FontWeight.w700,
                    // ),
                    // style: GoogleFonts.abrilFatface(
                    //   textStyle: const TextStyle(
                    //     fontSize: Sizes.size26,
                    //     fontWeight: FontWeight.w700,
                    //   ),
                    // ),
                  ),
                  Gaps.v20,
                  Opacity(
                    opacity: 0.7,
                    child: Text(
                      S.of(context).loginSubTitle,
                      style: const TextStyle(
                        fontSize: Sizes.size16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Gaps.v40,
                  // 세로 방향 (COLUMN)
                  if (orientation == Orientation.portrait) ...[
                    AuthButton(
                      icon: FontAwesomeIcons.user,
                      text: S.of(context).useEmailPassword,
                      onTapButton: () => _onTapEmailAndPassword(context),
                    ),
                    Gaps.v14,
                    AuthButton(
                      icon: FontAwesomeIcons.apple,
                      text: S.of(context).continueWithApple,
                      onTapButton: () => _onTapAppleLogin(context),
                    ),
                  ],
                  // 가로 방향 (ROW)
                  if (orientation == Orientation.landscape)
                    Row(
                      children: [
                        Expanded(
                          child: AuthButton(
                            icon: FontAwesomeIcons.user,
                            text: S.of(context).useEmailPassword,
                            onTapButton: () => _onTapEmailAndPassword(context),
                          ),
                        ),
                        Gaps.h14,
                        Expanded(
                          child: AuthButton(
                            icon: FontAwesomeIcons.apple,
                            text: S.of(context).continueWithApple,
                            onTapButton: () => _onTapAppleLogin(context),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color:
              isDarkMode(context) ? Colors.grey.shade900 : Colors.grey.shade50,
          height: 130,
          child: Padding(
            padding: const EdgeInsets.only(
              top: Sizes.size32,
              bottom: Sizes.size64,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).dontHaveAnAccount,
                  style: const TextStyle(
                    fontSize: Sizes.size18,
                  ),
                ),
                Gaps.h5,
                GestureDetector(
                  onTap: () => _onTapSignUp(context),
                  child: Text(
                    S.of(context).signUp,
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
      ),
    );
  }
}
