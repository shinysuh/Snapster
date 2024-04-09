import 'package:flutter/material.dart';

// pushNamed
void redirectToRoute({
  required BuildContext context,
  required String route,
}) {
  Navigator.of(context).pushNamed(route);
}

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

void routeWithFadeSlideAnimation({
  required BuildContext context,
  required Widget targetScreen,
  Duration? duration,
}) {
  Navigator.of(context).push(PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
    transitionDuration: duration ?? const Duration(milliseconds: 500),
    reverseTransitionDuration: duration ?? const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween(
        begin: const Offset(0, -1),
        end: Offset.zero,
      ).animate(animation);
      return SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  ));
}
