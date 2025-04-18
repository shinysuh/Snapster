import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/constants/gaps.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/authentication/common/form_button.dart';
import 'package:snapster_app/features/authentication/view_models/signup_view_model.dart';
import 'package:snapster_app/features/authentication/views/sign_up/email_screen.dart';
import 'package:snapster_app/utils/navigator_redirection.dart';
import 'package:snapster_app/utils/tap_to_unfocus.dart';

class UsernameScreen extends ConsumerStatefulWidget {
  static const String routeURL =
      'username'; // '/'(sign up) 안에 nested 돼 있으므로 '/' 필요 X
  static const String routeName = 'username';

  const UsernameScreen({super.key});

  @override
  ConsumerState<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends ConsumerState<UsernameScreen> {
  String _username = '';

  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState(); // at the beginning of everything
    _usernameController.addListener(() {
      setState(() {
        _username = _usernameController.text;
      });
    });
  }

  @override
  void dispose() {
    /*
       위젯이 사라질 때 _usernameController dispose
       메모리를 위패 필수 => 잊었을 경우 eventually 앱이 crash 됨
       This removes all the eventListeners
    */
    _usernameController.dispose();
    super.dispose(); // better do this at the end => cleaning up
  }

  void _onSubmit() {
    if (_username.isEmpty) return;

    ref.read(signUpForm.notifier).state = {'username': _username};

    redirectToScreen(
      context: context,
      targetScreen: EmailScreen(username: _username),
    );
    // goToRouteNamed(
    //   context: context,
    //   routeName: EmailScreen.routeName,
    //   extra: EmailScreenArgs(username: _username),
    // );
    // redirectToRoute(
    //     context: context,
    //     route: EmailScreen.routeName,
    //     args: EmailScreenArgs(username: _username));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapOutsideAndDismissKeyboard(context),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Sign up',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v40,
              const Text(
                'Create Username',
                style: TextStyle(
                  fontSize: Sizes.size20 + Sizes.size2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v6,
              const Text(
                'You can always change this later.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: Sizes.size16,
                ),
              ),
              Gaps.v36,
              TextField(
                controller: _usernameController,
                cursorColor: Theme.of(context).primaryColor,
                keyboardType: TextInputType.text,
                autofocus: true,
                autocorrect: false,
                onEditingComplete: _onSubmit,
                decoration: InputDecoration(
                  hintText: 'Username',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
              Gaps.v36,
              FormButton(
                disabled: _username.isEmpty,
                onTapButton: _onSubmit,
                buttonText: 'Next',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
