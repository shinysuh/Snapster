import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/common/widgets/navigation/widgets/nav_tab.dart';
import 'package:tiktok_clone/common/widgets/navigation/widgets/post_video_button.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/navigation_tabs.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/discover/discover_screen.dart';
import 'package:tiktok_clone/features/inbox/inbox_screen.dart';
import 'package:tiktok_clone/features/user/user_profile_screen.dart';
import 'package:tiktok_clone/features/video/views/video_recording_screen.dart';
import 'package:tiktok_clone/features/video/views/video_timeline_screen.dart';
import 'package:tiktok_clone/utils/navigator_redirection.dart';
import 'package:tiktok_clone/utils/theme_mode.dart';
import 'package:tiktok_clone/utils/widgets/regulated_max_width.dart';

class MainNavigationScreen extends StatefulWidget {
  static const String routeName = 'mainNavigation';

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
    // redirectToScreen(
    //   context: context,
    //   targetScreen: Scaffold(
    //     appBar: AppBar(
    //       title: const Text('record video'),
    //     ),
    //   ),
    //   isFullScreen: true,
    // );
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
    return Scaffold(
      // resizeToAvoidBottomInset : 키보드가 나타날 때 body 크기를 resize 할지 여부
      resizeToAvoidBottomInset: false,
      backgroundColor: _isScreenDark() ? Colors.black : Colors.white,
      body: Stack(
        children: [
          // Offstage 사용 시, 다른 화면의 state 초기화 없이도 하나의 화면 출력 가능
          // BUT, 너무 많은 리소스를 사용하는 화면이 있을 경우, 모든 화면이 느려질 수 있다.(주의)
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
          padding: const EdgeInsets.only(
            top: Sizes.size16,
            bottom: Sizes.size28,
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
    );
    /*
    // CupertinoTabScaffole 사용을 원하면 main.dart에서 MaterialApp 대신 CupertinoApp 사용 필수
     return CupertinoTabScaffold(
      // iOS design
      tabBuilder: (context, index) => screens[index],
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'home',
            tooltip: 'Home page',
            backgroundColor: Colors.amber,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: 'Search',
            tooltip: 'Search',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.plus_square),
            label: '',
            tooltip: 'Upload your videos',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cube_box),
            label: 'Inbox',
            tooltip: 'Check your inbox',
            backgroundColor: Colors.teal,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
            label: 'Profile',
            tooltip: 'Check your profile',
            backgroundColor: Colors.purple,
          ),
        ],
      ),
    );
    */

    // material designs 2 & 3
    /*
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        // material 3 design
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onTapNavigationItem,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.house),
            label: 'Home',
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
            label: 'Search',
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.squarePlus),
            label: 'Upload',
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.inbox),
            label: 'Inbox',
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.user),
            label: 'Profile',
          ),
        ],
      ),
*/
    /*
      // material 2 design
      BottomNavigationBar(
        // selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _selectedIndex,
        onTap: _onTapNavigationItem,
        // type: BottomNavigationBarType.fixed,
        type: BottomNavigationBarType.shifting,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house),
            label: 'home',
            tooltip: 'Home page',
            backgroundColor: Colors.amber,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
            label: 'Search',
            tooltip: 'Search',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.squarePlus),
            label: '',
            tooltip: 'Upload your videos',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.inbox),
            label: 'Inbox',
            tooltip: 'Check your inbox',
            backgroundColor: Colors.teal,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.user),
            label: 'Profile',
            tooltip: 'Check your profile',
            backgroundColor: Colors.purple,
          ),
        ],
      ),
      */
    // );
  }
}
