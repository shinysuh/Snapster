import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/view_models/chatroom_view_model.dart';
import 'package:tiktok_clone/features/user/models/user_profile_model.dart';

class UserListScreen extends ConsumerStatefulWidget {
  static const String routeURL = '/chatroom-user-list';
  static const String routeName = 'chatroom-user-list';

  const UserListScreen({super.key});

  @override
  ConsumerState<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<UserListScreen> {
  void _onClickUser(UserProfileModel invitee) {
    // chatroom create
    ref.read(chatroomProvider.notifier).createChatroom(
          context,
          invitee,
        );
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.read(chatroomProvider.notifier).fetchAllUsers();

    return const Placeholder();
  }
}
