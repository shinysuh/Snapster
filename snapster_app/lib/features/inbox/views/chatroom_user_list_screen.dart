import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/constants/breakpoints.dart';
import 'package:snapster_app/constants/gaps.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/inbox/view_models/chatroom_view_model.dart';
import 'package:snapster_app/features/user/models/user_profile_model.dart';
import 'package:snapster_app/generated/l10n.dart';
import 'package:snapster_app/utils/profile_network_img.dart';
import 'package:snapster_app/utils/widgets/regulated_max_width.dart';

class ChatroomUserListScreen extends ConsumerStatefulWidget {
  static const String routeURL = '/chatroom-user-list';
  static const String routeName = 'chatroom-user-list';

  const ChatroomUserListScreen({super.key});

  @override
  ConsumerState<ChatroomUserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<ChatroomUserListScreen> {
  List<UserProfileModel> _users = [];

  @override
  void initState() {
    super.initState();
    _getAllUsers();
  }

  Future<void> _getAllUsers() async {
    _users = await ref.read(chatroomProvider.notifier).fetchAllOtherUsers();
    setState(() {});
  }

  void _onClickUser(UserProfileModel chatPartner) {
    // chatroom create
    ref.read(chatroomProvider.notifier).createChatroom(
          context,
          chatPartner,
        );
  }

  @override
  Widget build(BuildContext context) {
    return RegulatedMaxWidth(
      maxWidth: Breakpoints.sm,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(S.of(context).chooseAProfile),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size10,
          ),
          child: Column(
            children: [
              Gaps.v20,
              for (var user in _users)
                ListTile(
                  onTap: () => _onClickUser(user),
                  leading: CircleAvatar(
                    radius: Sizes.size28,
                    foregroundImage: user.hasAvatar
                        ? getProfileImgByUserId(user.uid, false)
                        : null,
                    child: ClipOval(child: Text(user.name)),
                  ),
                  title: Text(user.username),
                  subtitle: Text(user.name),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
