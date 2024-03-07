import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/navigation/stf_screen.dart';
import 'package:tiktok_clone/features/navigation/widgets/nav_tab.dart';
import 'package:tiktok_clone/features/navigation/widgets/post_video_button.dart';
import 'package:tiktok_clone/utils/navigator_redirection.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  void _onTapNavigationItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onTapPostVideoButton() {
    redirectToScreen(
      context: context,
      targetScreen: Scaffold(
        appBar: AppBar(
          title: const Text('record video'),
        ),
      ),
      isFullScreen: true,
    );
  }

  bool _isPageHidden(int index) {
    return _selectedIndex != index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Offstage 사용 시, 다른 화면의 state 초기화 없이도 하나의 화면 출력 가능
          // BUT, 너무 많은 리소스를 사용하는 화면이 있을 경우, 모든 화면이 느려질 수 있다.(주의)
          // Offstage(
          //   offstage: _isPageHidden(0),
          //   child: Container(),
          // ),
          StfScreen(
            selectedIndex: _selectedIndex,
            pageIndex: 0,
            pageName: 'Home',
          ),
          StfScreen(
            selectedIndex: _selectedIndex,
            pageIndex: 1,
            pageName: 'Discover',
          ),
          StfScreen(
            selectedIndex: _selectedIndex,
            pageIndex: 3,
            pageName: 'Inbox',
          ),
          StfScreen(
            selectedIndex: _selectedIndex,
            pageIndex: 4,
            pageName: 'Profile',
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Sizes.size16,
            horizontal: Sizes.size8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NavTab(
                isSelected: _selectedIndex == 0,
                label: 'Home',
                icon: FontAwesomeIcons.house,
                selectedIcon: FontAwesomeIcons.house,
                onTap: () => _onTapNavigationItem(0),
              ),
              NavTab(
                isSelected: _selectedIndex == 1,
                label: 'Discover',
                icon: FontAwesomeIcons.compass,
                selectedIcon: FontAwesomeIcons.solidCompass,
                onTap: () => _onTapNavigationItem(1),
              ),
              Gaps.h24,
              GestureDetector(
                onTap: _onTapPostVideoButton,
                child: const PostVideoButton(),
              ),
              Gaps.h24,
              NavTab(
                isSelected: _selectedIndex == 3,
                label: 'Inbox',
                icon: FontAwesomeIcons.message,
                selectedIcon: FontAwesomeIcons.solidMessage,
                onTap: () => _onTapNavigationItem(3),
              ),
              NavTab(
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
