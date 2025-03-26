import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/common/widgets/navigation/widgets/nav_tab.dart';
import 'package:tiktok_clone/common/widgets/navigation/widgets/post_video_button.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/navigation_tabs.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/discover/discover_screen.dart';
import 'package:tiktok_clone/features/inbox/views/inbox_screen.dart';
import 'package:tiktok_clone/features/user/views/user_profile_screen.dart';
import 'package:tiktok_clone/features/video/views/video_recording_screen.dart';
import 'package:tiktok_clone/features/video/views/video_timeline_screen.dart';
import 'package:tiktok_clone/utils/navigator_redirection.dart';
import 'package:tiktok_clone/utils/tap_to_unfocus.dart';
import 'package:tiktok_clone/utils/theme_mode.dart';
import 'package:tiktok_clone/utils/widgets/regulated_max_width.dart';

class MainNavigationScreen extends StatefulWidget {
  static const String routeName = 'mainNavigation';
  static const String homeRouteURL = '/home';

  final String tab;

  const MainNavigationScreen({
    super.key,
    required this.tab,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  bool _isPostVideoClicked = false;
  late int _selectedIndex = tabs.indexOf(widget.tab);

  void _onTapNavigationItem(int index) {
    var tab = tabs[index];
    goToRouteWithoutStack(context: context, location: '/$tab');
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onTapPostVideoButton() {
    _onReleasePostVideoButton();
    goToRouteNamed(context: context, routeName: VideoRecordingScreen.routeName);
  }

  void _onTapDownPostVideoButton() {
    setState(() {
      _isPostVideoClicked = true;
    });
  }

  void _onReleasePostVideoButton() {
    setState(() {
      _isPostVideoClicked = false;
    });
  }

  bool _isPageHidden(int index) {
    return _selectedIndex != index;
  }

  bool _isScreenDark() {
    return _selectedIndex == 0 || isDarkMode(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapOutsideAndDismissKeyboard(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: _isScreenDark() ? Colors.black : Colors.white,
        body: Stack(
          children: [
            Offstage(
              offstage: _isPageHidden(0),
              child: const RegulatedMaxWidth(
                maxWidth: Breakpoints.sm,
                child: VideoTimelineScreen(),
              ),
            ),
            Offstage(
              offstage: _isPageHidden(1),
              child: const RegulatedMaxWidth(
                child: DiscoverScreen(),
              ),
            ),
            Offstage(
              offstage: _isPageHidden(3),
              child: const RegulatedMaxWidth(
                maxWidth: Breakpoints.sm,
                child: InboxScreen(),
              ),
            ),
            Offstage(
              offstage: _isPageHidden(4),
              child: const RegulatedMaxWidth(
                child: UserProfileScreen(username: 'json_2426', show: 'posts'),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: _isScreenDark() ? Colors.black : Colors.white,
          child: Padding(
            padding: EdgeInsets.only(
              top: Sizes.size16,
              bottom: MediaQuery.of(context).padding.bottom + Sizes.size12,
              left: Sizes.size20,
              right: Sizes.size20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NavTab(
                  isHome: _isScreenDark(),
                  isSelected: _selectedIndex == 0,
                  label: 'Home',
                  icon: FontAwesomeIcons.house,
                  selectedIcon: FontAwesomeIcons.house,
                  onTap: () => _onTapNavigationItem(0),
                ),
                Gaps.h8,
                NavTab(
                  isHome: _isScreenDark(),
                  isSelected: _selectedIndex == 1,
                  label: 'Discover',
                  icon: FontAwesomeIcons.compass,
                  selectedIcon: FontAwesomeIcons.solidCompass,
                  onTap: () {
                    _onTapNavigationItem(1);
                    // redirectToScreen(
                    //   context: context,
                    //   targetScreen: const DiscoverScreen(),
                    // );
                  },
                ),
                Gaps.h32,
                GestureDetector(
                  onTapDown: (details) => _onTapDownPostVideoButton(),
                  onTapCancel: _onReleasePostVideoButton,
                  onTap: _onTapPostVideoButton,
                  child: PostVideoButton(
                    isClicked: _isPostVideoClicked,
                    inverted: !_isScreenDark(),
                  ),
                ),
                Gaps.h32,
                NavTab(
                  isHome: _isScreenDark(),
                  isSelected: _selectedIndex == 3,
                  label: 'Inbox',
                  icon: FontAwesomeIcons.message,
                  selectedIcon: FontAwesomeIcons.solidMessage,
                  onTap: () => _onTapNavigationItem(3),
                ),
                Gaps.h8,
                NavTab(
                  isHome: _isScreenDark(),
                  isSelected: _selectedIndex == 4,
                  label: 'Profile',
                  icon: FontAwesomeIcons.user,
                  selectedIcon: FontAwesomeIcons.solidUser,
                  onTap: () => _onTapNavigationItem(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
