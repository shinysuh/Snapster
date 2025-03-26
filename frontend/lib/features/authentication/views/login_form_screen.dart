import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/common/form_button.dart';
import 'package:tiktok_clone/features/authentication/view_models/login_view_model.dart';
import 'package:tiktok_clone/utils/tap_to_unfocus.dart';

class LoginFormScreen extends ConsumerStatefulWidget {
  const LoginFormScreen({super.key});

  @override
  ConsumerState<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends ConsumerState<LoginFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, String> formData = {};

  late FocusNode _secondFocus; // 두번째 칸 focus

  final _initialEmail = 'jenna@qwer.qwer';
  final _initialPassword = 'qwer1234?';

  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _secondFocus = FocusNode();
  }

  @override
  void dispose() {
    _secondFocus.dispose();
    super.dispose();
  }

  void _onToggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _onTapNext() {
    _secondFocus.requestFocus();
  }

  void _setFormData(String field, String? newValue) {
    if (newValue != null) {
      setState(() {
        formData[field] = newValue;
      });
    }
    // print(formData.values);
  }

  void _onSubmit() {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate() /*invoke validator*/) {
      _formKey.currentState!.save(); // invoke onSaved

      ref.read(loginProvider.notifier).login(
            context,
            formData['email'] ?? '',
            formData['password'] ?? '',
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapOutsideAndDismissKeyboard(context),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Log in'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Gaps.v28,
                TextFormField(
                  initialValue: _initialEmail,
                  autofocus: true,
                  textCapitalization: TextCapitalization.none,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    // hintStyle: TextStyle(
                    //   color: Colors.grey.shade500,
                    // ),
                    // enabledBorder: UnderlineInputBorder(
                    //   borderSide: BorderSide(
                    //     color: Colors.grey.shade400,
                    //   ),
                    // ),
                    // focusedBorder: UnderlineInputBorder(
                    //   borderSide: BorderSide(
                    //     color: Colors.grey.shade400,
                    //   ),
                    // ),
                  ),
                  onEditingComplete: _onTapNext,
                  validator: (value) => value == null || value.trim() == ''
                      ? 'Enter your email'
                      : null,
                  // : value == 'jenna'
                  //     ? null
                  //     : 'User Info Not Exist',
                  onSaved: (newValue) => _setFormData('email', newValue),
                ),
                Gaps.v16,
                TextFormField(
                  obscureText: _obscureText,
                  initialValue: _initialPassword,
                  focusNode: _secondFocus,
                  textCapitalization: TextCapitalization.none,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                  onEditingComplete: _onSubmit,
                  validator: (value) => value == null || value.trim() == ''
                      ? 'Enter your password'
                      : null,
                  // : value == '1234'
                  //     ? null
                  //     : 'Password Not Matched',
                  onSaved: (newValue) => _setFormData('password', newValue),
                ),
                Gaps.v28,
                FormButton(
                  disabled: ref.watch(loginProvider).isLoading,
                  onTapButton: _onSubmit,
                  buttonText: 'Log in',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
