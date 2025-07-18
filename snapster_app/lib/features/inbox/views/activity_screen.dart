import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snapster_app/constants/activities.dart';
import 'package:snapster_app/constants/breakpoints.dart';
import 'package:snapster_app/constants/gaps.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/utils/theme_mode.dart';
import 'package:snapster_app/utils/widgets/regulated_max_width.dart';

class ActivityScreen extends StatefulWidget {
  static const String routeName = 'activity';
  static const String routeURL = '/activity';

  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  /* 초기화 시 this 를 참조하기 위해서는 반드시 late 으로 선언되어야 한다 */
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final Animation<double> _arrowAnimation = Tween(
    begin: 0.0,
    end: 0.5,
  ).animate(_animationController);

  late final Animation<Offset> _panelAnimation = Tween(
    begin: const Offset(0, -1),
    end: Offset.zero,
  ).animate(_animationController);

  late final Animation<Color?> _barrierAnimation = ColorTween(
    begin: Colors.transparent,
    end: Colors.black38,
  ).animate(_animationController);

  final List<String> _notifications = List.generate(20, (index) => '${index}h');

  bool _showBarrier = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleAnimation() async {
    if (_arrowAnimation.isCompleted) {
      // animation 이 완전히 끝나고 barrier 해제 (await)
      await _animationController.reverse();
    } else {
      // animation 이 시작되는 동시에 barrier 생성
      _animationController.forward();
    }

    setState(() {
      _showBarrier = !_showBarrier;
    });
  }

  void _onDismissed(DismissDirection direction, String notification) {
    setState(() {
      _notifications.remove(notification);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    return RegulatedMaxWidth(
      maxWidth: Breakpoints.sm,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: GestureDetector(
            onTap: _toggleAnimation,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('All activity'),
                Gaps.h2,
                RotationTransition(
                  turns: _arrowAnimation,
                  child: const FaIcon(
                    FontAwesomeIcons.chevronDown,
                    size: Sizes.size14,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                Gaps.v14,
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.size20,
                  ),
                  child: Text(
                    'New',
                    style: TextStyle(
                        fontSize: Sizes.size14, color: Colors.grey.shade600),
                  ),
                ),
                Gaps.v14,
                for (var notification in _notifications)
                  Dismissible(
                    key: Key(notification),
                    onDismissed: (direction) =>
                        _onDismissed(direction, notification),
                    background: Container(
                      alignment: Alignment.centerLeft,
                      color: Colors.green,
                      child: const Padding(
                        padding: EdgeInsets.only(left: Sizes.size10),
                        child: FaIcon(
                          FontAwesomeIcons.check,
                          color: Colors.white,
                          size: Sizes.size32,
                        ),
                      ),
                    ),
                    secondaryBackground: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: const Padding(
                        padding: EdgeInsets.only(right: Sizes.size10),
                        child: FaIcon(
                          FontAwesomeIcons.trashCan,
                          color: Colors.white,
                          size: Sizes.size32,
                        ),
                      ),
                    ),
                    child: ListTile(
                      minVerticalPadding: Sizes.size16,
                      leading: Container(
                        width: Sizes.size52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? Colors.grey.shade800 : Colors.white,
                          border: Border.all(
                            color: isDark
                                ? Colors.grey.shade800
                                : Colors.grey.shade400,
                            width: Sizes.size1,
                          ),
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.bell,
                            size: Sizes.size26,
                          ),
                        ),
                      ),
                      title: RichText(
                        text: TextSpan(
                          text: 'Account updates:',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: Sizes.size16 + Sizes.size1,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            const TextSpan(
                              text: '  Upload longer videos',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            TextSpan(
                              text: ' $notification',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: const FaIcon(
                        FontAwesomeIcons.chevronRight,
                        size: Sizes.size16,
                      ),
                    ),
                  ),
              ],
            ),
            if (_showBarrier)
              AnimatedModalBarrier(
                color: _barrierAnimation,
                dismissible: true,
                onDismiss: _toggleAnimation,
              ),
            SlideTransition(
              position: _panelAnimation,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .appBarTheme
                      .backgroundColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(
                      Sizes.size5,
                    ),
                    bottomRight: Radius.circular(
                      Sizes.size5,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var tab in panelItems)
                      ListTile(
                        title: Row(
                          children: [
                            Icon(
                              tab['icon'],
                              size: Sizes.size16,
                            ),
                            Gaps.h20,
                            Text(
                              tab['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
