import 'package:flutter/cupertino.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';

class RegulatedMaxWidth extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final Clip? clipBehavior;
  final BoxDecoration? decoration;

  const RegulatedMaxWidth({
    super.key,
    required this.child,
    this.maxWidth,
    this.clipBehavior,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? Breakpoints.md,
        ),
        clipBehavior: clipBehavior ?? Clip.none,
        decoration: decoration,
        child: child,
      ),
    );
  }
}
