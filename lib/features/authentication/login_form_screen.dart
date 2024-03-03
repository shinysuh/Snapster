import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/common/form_button.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/utils/navigator_redirection.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, String> formData = {};

  late FocusNode _secondFocus; // 두번째 칸 focus

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

  void _onTapNext() {
    _secondFocus.requestFocus();
  }

  void _setFormData(String field, String? newValue) {
    if (newValue != null) {
      setState(() {
        formData[field] = newValue;
      });
    }
    print(formData.values);
  }

  void _onSubmit() {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate() /*invoke validator*/) {
      _formKey.currentState!.save(); // invoke onSaved
      redirectToScreen(context, const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                    : value == 'jenna'
                        ? null
                        : 'User Info Not Exist',
                onSaved: (newValue) => _setFormData('email', newValue),
              ),
              Gaps.v16,
              TextFormField(
                focusNode: _secondFocus,
                textCapitalization: TextCapitalization.none,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                onEditingComplete: _onSubmit,
                validator: (value) => value == null || value.trim() == ''
                    ? 'Enter your password'
                    : value == '1234'
                        ? null
                        : 'Password Not Matched',
                onSaved: (newValue) => _setFormData('password', newValue),
              ),
              Gaps.v28,
              FormButton(
                isDisabled: false,
                onTapButton: _onSubmit,
                buttonText: 'Log in',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
