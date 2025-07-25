import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/constants/breakpoints.dart';
import 'package:snapster_app/constants/gaps.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/authentication/common/auth_buttons_by_orientation.dart';
import 'package:snapster_app/features/authentication/views/login/login_form_screen.dart';
import 'package:snapster_app/features/authentication/views/signup/sign_up_screen.dart';
import 'package:snapster_app/generated/l10n.dart';
import 'package:snapster_app/utils/navigator_redirection.dart';
import 'package:snapster_app/utils/theme_mode.dart';
import 'package:snapster_app/utils/widgets/regulated_max_width.dart';

class LoginScreen extends ConsumerWidget {
  static const String routeURL = '/login';
  static const String routeName = 'login';

  const LoginScreen({super.key});

  void _onTapSignUp(BuildContext context) {
    goToRouteNamed(
      context: context,
      routeName: SignUpScreen.routeName,
    );
  }

  void _onTapEmailAndPassword(BuildContext context) {
    redirectToScreen(context: context, targetScreen: const LoginFormScreen());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    S.of(context).loginToSnapster('Snapster'),
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
                  AuthButtonsByOrientation(
                    orientation: orientation,
                    isNewUser: false,
                    onTapEmailAndPassword: _onTapEmailAndPassword,
                  )
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
