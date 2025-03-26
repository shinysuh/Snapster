import 'package:flutter/cupertino.dart';

void onTapOutsideAndDismissKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}
