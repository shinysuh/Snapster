import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/common/form_button.dart';
import 'package:tiktok_clone/features/authentication/view_models/signup_view_model.dart';
import 'package:tiktok_clone/utils/tap_to_unfocus.dart';

class BirthdayScreen extends ConsumerStatefulWidget {
  static const String routeURL =
      'birthday'; // '/'(sign up) 안에 nested 돼 있으므로 '/' 필요 X
  static const String routeName = 'birthday';

  const BirthdayScreen({super.key});

  @override
  ConsumerState<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends ConsumerState<BirthdayScreen> {
  late DateTime initDate;
  final TextEditingController _birthdayController = TextEditingController();

  String _birthday = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      var now = DateTime.now();
      initDate = DateTime(now.year - 12, now.month, now.day); // 12세 제한
      _setTextFieldDate(initDate);
    });
  }

  @override
  void dispose() {
    _birthdayController.dispose();
    super.dispose();
  }

  void _setTextFieldDate(DateTime dateValue) {
    final textDate = dateValue.toString().split(' ').first;
    _birthdayController.value = TextEditingValue(text: textDate);
    setState(() {
      _birthday = textDate;
    });
  }

  void _onSubmit() {
    ref.read(signUpForm.notifier).state = {
      ...ref.read(signUpForm.notifier).state,
      'birthday': _birthday,
    };
    ref.read(signUpProvider.notifier).signUp(context);
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
                'When\'s your birthday?',
                style: TextStyle(
                  fontSize: Sizes.size20 + Sizes.size2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v6,
              const Text(
                'Your birthday won\'t be shown publicly.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: Sizes.size16,
                ),
              ),
              Gaps.v36,
              TextField(
                controller: _birthdayController,
                cursorColor: Theme.of(context).primaryColor,
                keyboardType: TextInputType.text,
                enabled: false,
                // autofocus: true,
                // autocorrect: false,
                onEditingComplete: _onSubmit,
                decoration: InputDecoration(
                  // hintText: 'Username',
                  // hintStyle: TextStyle(
                  //   color: Colors.grey.shade500,
                  // ),
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
                disabled: ref.watch(signUpProvider).isLoading,
                onTapButton: _onSubmit,
                buttonText: 'Sign Up',
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            height: 400,
            child: CupertinoDatePicker(
              initialDateTime: initDate,
              maximumDate: initDate,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (DateTime value) => _setTextFieldDate(value),
            )),
      ),
    );
  }
}
