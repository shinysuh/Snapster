import 'package:flutter/material.dart';

// push
void redirectToScreen(
    {required BuildContext context,
    required Widget targetScreen,
    bool? isFullScreen}) {
  Navigator.of(context).push(
    MaterialPageRoute(
        builder: (context) => targetScreen,
        fullscreenDialog: isFullScreen ?? false),
  );
}

// pushAndRemoveUntil - 이전 widget 들을 원하는 수만큼 지울 수 있음
void redirectToScreenAndRemovePreviousRoutes({
  required BuildContext context,
  required Widget targetScreen,
}) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => targetScreen),
    (route) => false // false => 이전 routes 모두 삭제
    ,
  );
}

void goBackToPreviousPage(BuildContext context) {
  Navigator.pop(context);
}
