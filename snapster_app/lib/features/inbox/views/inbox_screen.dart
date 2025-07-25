import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snapster_app/constants/gaps.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/chat/views/chats_screen.dart';
import 'package:snapster_app/features/inbox/views/activity_screen.dart';
import 'package:snapster_app/utils/navigator_redirection.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  void _onTapDM(BuildContext context) {
    goToRouteNamed(
      context: context,
      routeName: ChatsScreen.routeName,
      // routeName: ChatsScreen.routeName,
    );
  }

  void _onTapActivity(BuildContext context) {
    goToRouteNamed(
      context: context,
      routeName: ActivityScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Inbox'),
        actions: [
          IconButton(
              onPressed: () => _onTapDM(context),
              icon: const FaIcon(FontAwesomeIcons.paperPlane))
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () => _onTapActivity(context),
            title: const Text(
              'Activity',
              style: TextStyle(
                fontSize: Sizes.size16,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: FaIcon(
              FontAwesomeIcons.chevronRight,
              size: Sizes.size14,
              color: Colors.grey.shade700,
            ),
          ),
          Container(
            height: Sizes.size1,
            color: Colors.grey.shade200,
          ),
          Gaps.v10,
          ListTile(
            onTap: () {},
            leading: Container(
              width: Sizes.size52,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.users,
                  color: Colors.white,
                ),
              ),
            ),
            title: const Text(
              'New Followers',
              style: TextStyle(
                fontSize: Sizes.size16,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text(
              'Messages from your followers will appear here',
              style: TextStyle(
                fontSize: Sizes.size14,
              ),
            ),
            trailing: FaIcon(
              FontAwesomeIcons.chevronRight,
              size: Sizes.size14,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
