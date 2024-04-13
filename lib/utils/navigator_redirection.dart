import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// pushNamed
/* ** 주의 : Web 에서는 사용 지양(뒤로가기 지원이 되지 않음) */
void redirectToRoute({
  required BuildContext context,
  required String route,
  Object? args,
}) {
  Navigator.pushNamed(context, route, arguments: args);
}

// push
/* ** 주의 : Web 에서는 사용 지양(url이 변하지 않아 Web에 사용하기 적절하지 않음) */
void redirectToScreen(
    {required BuildContext context,
    required Widget targetScreen,
    bool? isFullScreen}) {
  Navigator.push(
    context,
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
  Navigator.pushAndRemoveUntil(
    context,
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
  Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
        transitionDuration: duration ?? const Duration(milliseconds: 500),
        reverseTransitionDuration:
            duration ?? const Duration(milliseconds: 500),
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

/* Go Router */
void goBackToPreviousRoute(BuildContext context) {
  context.pop();
}

void goToNewPageWithoutStack(BuildContext context, String location) {
  context.go(location);
  // context.goNamed(location);
}
