import 'package:flutter/cupertino.dart';

void onTapOutsideAndHideKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}
