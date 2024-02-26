import 'package:flutter/material.dart';

void redirectToScreen(BuildContext context, Widget targetScreen) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => targetScreen,
  ));
}

void goBackToPreviousPage(BuildContext context) {
  Navigator.pop(context);
}
