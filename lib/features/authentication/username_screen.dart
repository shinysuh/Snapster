import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/common/form_button.dart';
import 'package:tiktok_clone/features/authentication/email_screen.dart';
import 'package:tiktok_clone/utils/navigator_redirection.dart';
import 'package:tiktok_clone/utils/tap_to_unfocus.dart';

class UsernameScreen extends StatefulWidget {
  static String routeName = '/username';

  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
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
    redirectToRoute(
        context: context,
        route: EmailScreen.routeName,
        args: EmailScreenArgs(username: _username));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapOutsideAndDismissKeyboard(context),
      child: Scaffold(
        appBar: AppBar(
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
                isDisabled: _username.isEmpty,
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
