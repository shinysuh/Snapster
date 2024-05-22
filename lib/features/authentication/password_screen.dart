import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/birthday_screen.dart';
import 'package:tiktok_clone/features/authentication/common/form_button.dart';
import 'package:tiktok_clone/features/authentication/view_models/signup_view_model.dart';
import 'package:tiktok_clone/utils/navigator_redirection.dart';
import 'package:tiktok_clone/utils/tap_to_unfocus.dart';

class PasswordScreen extends ConsumerStatefulWidget {
  static const String routeURL =
      'password'; // '/'(sign up) 안에 nested 돼 있으므로 '/' 필요 X
  static const String routeName = 'password';

  const PasswordScreen({super.key});

  @override
  ConsumerState<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends ConsumerState<PasswordScreen> {
  String _password = '';
  bool _isPasswordValid = true;

  bool _obscureText = true;

  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {
        _password = _passwordController.text;
        _isPasswordValid = _validatePassword();
      });
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _onTapClear() {
    setState(() {
      _passwordController.clear();
    });
  }

  void _onToggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool _validatePassword() {
    return _checkPasswordLength() && _checkRegExp();
  }

  bool _checkPasswordLength() {
    return _password.isNotEmpty &&
        _password.length > 7 &&
        _password.length < 21;
  }

  bool _checkRegExp() {
    var regExp =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return regExp.hasMatch(_password);
  }

  FaIcon getIconByValidity(bool isValid) {
    return isValid
        ? const FaIcon(
            FontAwesomeIcons.circleCheck,
            color: Colors.green,
            size: Sizes.size22,
          )
        : FaIcon(
            FontAwesomeIcons.circleXmark,
            color: Colors.grey.shade500,
            size: Sizes.size22,
          );
  }

  void _onSubmit() {
    if (!_isPasswordValid) return;
    // goToRouteNamed(
    //   context: context,
    //   routeName: BirthdayScreen.routeName,
    // );

    ref.read(signUpForm.notifier).state = {
      ...ref.read(signUpForm.notifier).state,
      'password': _password,
    };

    redirectToScreen(
      context: context,
      targetScreen: const BirthdayScreen(),
    );
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
                'Create Password',
                style: TextStyle(
                  fontSize: Sizes.size20 + Sizes.size2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v36,
              TextField(
                controller: _passwordController,
                cursorColor: Theme.of(context).primaryColor,
                // 특정 keyboard 타입 설정
                keyboardType: TextInputType.text,
                autofocus: true,
                autocorrect: false,
                obscureText: _obscureText,
                onEditingComplete: _onSubmit,
                decoration: InputDecoration(
                  hintText: 'Password',
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
                  suffix: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: _onTapClear,
                        child: FaIcon(
                          FontAwesomeIcons.solidCircleXmark,
                          color: Colors.grey.shade500,
                          size: Sizes.size20,
                        ),
                      ),
                      Gaps.h12,
                      GestureDetector(
                        onTap: _onToggleObscureText,
                        child: FaIcon(
                          _obscureText
                              ? FontAwesomeIcons.eye
                              : FontAwesomeIcons.eyeSlash,
                          color: Colors.grey.shade500,
                          size: _obscureText ? Sizes.size24 : Sizes.size22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gaps.v14,
              const Text(
                'Your password must have:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.v10,
              Row(
                children: [
                  getIconByValidity(_checkPasswordLength()),
                  Gaps.h7,
                  const Text('8 to 20 characters'),
                ],
              ),
              Gaps.v6,
              Row(
                children: [
                  getIconByValidity(_checkRegExp()),
                  Gaps.h7,
                  const Text('Letters, numbers, and special characters'),
                ],
              ),
              Gaps.v36,
              FormButton(
                disabled: !_isPasswordValid,
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
