import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/navigation/widgets/nav_tab.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final screens = [
    const Center(
      child: Text('home'),
    ),
    const Center(
      child: Text('search'),
    ),
    const Center(
      child: Text('video'),
    ),
    const Center(
      child: Text('inbox'),
    ),
    const Center(
      child: Text('profile'),
    ),
  ];

  int _selectedIndex = 0;

  void _onTapNavigationItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Sizes.size16,
            horizontal: Sizes.size8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavTab(
                isSelected: _selectedIndex == 0,
                label: 'Home',
                icon: FontAwesomeIcons.house,
                onTap: () => _onTapNavigationItem(0),
              ),
              NavTab(
                isSelected: _selectedIndex == 1,
                label: 'Discover',
                icon: FontAwesomeIcons.magnifyingGlass,
                onTap: () => _onTapNavigationItem(1),
              ),
              NavTab(
                isSelected: _selectedIndex == 2,
                label: 'Upload',
                icon: FontAwesomeIcons.squarePlus,
                onTap: () => _onTapNavigationItem(2),
              ),
              NavTab(
                isSelected: _selectedIndex == 3,
                label: 'Inbox',
                icon: FontAwesomeIcons.message,
                onTap: () => _onTapNavigationItem(3),
              ),
              NavTab(
                isSelected: _selectedIndex == 4,
                label: 'Profile',
                icon: FontAwesomeIcons.user,
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
