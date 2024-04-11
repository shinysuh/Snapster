import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/common/form_button.dart';
import 'package:tiktok_clone/features/authentication/password_screen.dart';
import 'package:tiktok_clone/utils/navigator_redirection.dart';
import 'package:tiktok_clone/utils/tap_to_unfocus.dart';

class EmailScreenArgs {
  final String username;

  EmailScreenArgs({
    required this.username,
  });
}

class EmailScreen extends StatefulWidget {
  static String routeName = '/email';
  final String username;

  const EmailScreen({
    super.key,
    required this.username,
  });

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  String _email = '';
  bool _isEmailValid = true;

  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        _email = _emailController.text;
        _isEmailValid = _validateEmailAddress();
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _validateEmailAddress() {
    final regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    return _email.isNotEmpty && regExp.hasMatch(_email);

    // if (_email.isEmpty) return null;
    // if (!regExp.hasMatch(_email)) return 'Invalid Email Format';
  }

  void _onSubmit() {
    if (_email.isEmpty || !_isEmailValid) return;
    redirectToScreen(context: context, targetScreen: const PasswordScreen());
  }

  @override
  Widget build(BuildContext context) {
    // ModalRoute.of(context) => Navigator 1(pushNamed) 사용 시
    // final args = ModalRoute.of(context)!.settings.arguments as EmailScreenArgs;
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
              Text(
                'Enter Your Email, ${widget.username}',
                style: const TextStyle(
                  fontSize: Sizes.size20 + Sizes.size2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v36,
              TextField(
                controller: _emailController,
                cursorColor: Theme.of(context).primaryColor,
                // 특정 keyboard 타입 설정
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                autocorrect: false,
                onEditingComplete: _onSubmit,
                decoration: InputDecoration(
                  hintText: 'Email Address',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                  errorText: _email.isEmpty || _isEmailValid
                      ? null
                      : 'Invalid Email Address',
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
                isDisabled: _email.isEmpty || !_isEmailValid,
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
