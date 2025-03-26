import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/features/authentication/common/auth_button.dart';
import 'package:tiktok_clone/features/authentication/view_models/social_auth_view_model.dart';
import 'package:tiktok_clone/generated/l10n.dart';

class AuthButtonsByOrientation extends ConsumerWidget {
  final Orientation orientation;
  final bool isNewUser;
  final Function onTapEmailAndPassword;

  const AuthButtonsByOrientation({
    super.key,
    required this.orientation,
    required this.isNewUser,
    required this.onTapEmailAndPassword,
  });

  List<AuthButton> getAuthButtons(BuildContext context, WidgetRef ref) {
    return [
      AuthButton(
        icon: FontAwesomeIcons.user,
        text: S.of(context).useEmailPassword,
        onTapButton: () => onTapEmailAndPassword(context),
      ),
      AuthButton(
        icon: FontAwesomeIcons.google,
        text: S.of(context).continueWithGoogle,
        onTapButton: () => ref
            .read(socialAuthProvider.notifier)
            .googleSignIn(context, isNewUser),
      ),
      AuthButton(
        icon: FontAwesomeIcons.github,
        text: S.of(context).continueWithGithub,
        onTapButton: () => ref
            .read(socialAuthProvider.notifier)
            .githubSignIn(context, isNewUser),
      ),
    ];
  }

  // 세로 방향 (COLUMN)
  List<Widget> getPortraitButtons(BuildContext context, WidgetRef ref) {
    var authButtons = getAuthButtons(context, ref);

    List<Widget> list = [];
    var idx = 0;
    for (AuthButton btn in authButtons) {
      idx++;
      list.add(btn);
      if (idx < authButtons.length) list.add(Gaps.v14);
    }

    return list;
  }

  // 가로 방향 (ROW)
  List<Widget> getLandscapeButtons(BuildContext context, WidgetRef ref) {
    var authButtons = getAuthButtons(context, ref);

    List<Widget> list = [];

    for (var i = 1; i < authButtons.length + 1; i += 2) {
      list.add(Row(
        children: [
          Expanded(
            child: authButtons[i - 1],
          ),
          if (i < authButtons.length) ...[
            Gaps.h14,
            Expanded(
              child: authButtons[i],
            ),
          ]
        ],
      ));

      if (i < authButtons.length) list.add(Gaps.v14);
    }

    return list;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: orientation == Orientation.portrait
          ? getPortraitButtons(context, ref)
          : getLandscapeButtons(context, ref),
    );
  }
}
