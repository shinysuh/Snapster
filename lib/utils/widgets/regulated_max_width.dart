import 'package:flutter/cupertino.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';

class RegulatedMaxWidth extends StatelessWidget {
  final Widget child;
  final double? maxWidth;

  const RegulatedMaxWidth({
    super.key,
    required this.child,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? Breakpoints.md,
        ),
        child: child,
      ),
    );
  }
}
