import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void showFirebaseErrorSnack(BuildContext context, Object? error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      // action: SnackBarAction(
      //   label: 'Got it',
      //   onPressed: () {},
      // ),
      showCloseIcon: true,
      content: Text(
        (error as FirebaseException).message ?? 'Oooops! Something went wrong',
      ),
    ),
  );
}

void showSessionErrorSnack(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      // action: SnackBarAction(
      //   label: 'Got it',
      //   onPressed: () {},
      // ),
      backgroundColor: Color(0xFFCE8782),
      showCloseIcon: true,
      content: Text('Session has been expired. Please log in first.'),
    ),
  );
}

void showCustomErrorSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      // action: SnackBarAction(
      //   label: 'Got it',
      //   onPressed: () {},
      // ),
      backgroundColor: const Color(0xFFCE8782),
      showCloseIcon: true,
      content: Text(message),
    ),
  );
}
