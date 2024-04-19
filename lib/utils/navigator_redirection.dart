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
void goToRouteNamed({
  required BuildContext context,
  required String routeName,
  Object? extra,
  Map<String, String>? params,
}) {
  context.pushNamed(routeName, extra: extra, params: params ?? {});
}

void goBackToPreviousRoute(BuildContext context) {
  context.pop();
}

// pushAndRemoveUntil 처럼 이전 route 들 접근 불가 => go 랑 같음
void goRouteReplacementNamed({
  required BuildContext context,
  required String routeName,
}) {
  context.pushReplacementNamed(routeName);
}

// push 는 pop 이 가능하지만 go 는 route stack 의 이전 routes 모두 삭제 (pop 불가능)
void goToRouteWithoutStack({
  required BuildContext context,
  required String location,
}) {
  context.go(location);
  // context.goNamed(location);
}

void goToRouteNamedWithoutStack({
  required BuildContext context,
  required String routeName,
}) {
  context.goNamed(routeName);
}
