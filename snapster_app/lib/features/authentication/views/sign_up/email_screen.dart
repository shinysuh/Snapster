import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/constants/gaps.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/authentication/common/form_button.dart';
import 'package:snapster_app/features/authentication/view_models/signup_view_model.dart';
import 'package:snapster_app/features/authentication/views/sign_up/password_screen.dart';
import 'package:snapster_app/utils/navigator_redirection.dart';
import 'package:snapster_app/utils/tap_to_unfocus.dart';
import 'package:snapster_app/utils/validation.dart';

class EmailScreenArgs {
  final String username;

  EmailScreenArgs({
    required this.username,
  });
}

class EmailScreen extends ConsumerStatefulWidget {
  static const String routeURL =
      'email'; // '/'(sign up) 안에 nested 돼 있으므로 '/' 필요 X
  static const String routeName = 'email';
  final String username;

  const EmailScreen({
    super.key,
    required this.username,
  });

  @override
  ConsumerState<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends ConsumerState<EmailScreen> {
  String _email = '';
  bool _isEmailValid = true;

  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        _email = _emailController.text;
        _isEmailValid = validateEmailAddress(_email);
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_email.isEmpty || !_isEmailValid) return;
    // goToRouteNamed(
    //   context: context,
    //   routeName: PasswordScreen.routeName,
    // );

    ref.read(signUpForm.notifier).state = {
      ...ref.read(signUpForm.notifier).state,
      'email': _email,
    };

    redirectToScreen(
      context: context,
      targetScreen: const PasswordScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ModalRoute.of(context) => Navigator 1(pushNamed) 사용 시
    // final args = ModalRoute.of(context)!.settings.arguments as EmailScreenArgs;
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
                disabled: _email.isEmpty || !_isEmailValid,
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
