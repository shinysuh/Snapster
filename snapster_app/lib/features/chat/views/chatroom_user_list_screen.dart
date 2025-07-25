import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/constants/breakpoints.dart';
import 'package:snapster_app/constants/gaps.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/chat/chatroom/view_models/chatroom_view_model.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/features/user/view_models/http_user_profile_view_model.dart';
import 'package:snapster_app/generated/l10n.dart';
import 'package:snapster_app/utils/profile_network_img.dart';
import 'package:snapster_app/utils/widgets/regulated_max_width.dart';

class ChatroomUserListScreen extends ConsumerStatefulWidget {
  static const String routeURL = '/chatroom-user-list';
  static const String routeName = 'chatroom-user-list';

  final AppUser currentUser;

  const ChatroomUserListScreen({
    super.key,
    required this.currentUser,
  });

  @override
  ConsumerState<ChatroomUserListScreen> createState() =>
      _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<ChatroomUserListScreen> {
  List<AppUser> _otherUsers = [];

  @override
  void initState() {
    super.initState();
    _getAllUsers();
  }

  Future<void> _getAllUsers() async {
    _otherUsers = await ref
        .read(httpUserProfileProvider.notifier)
        .getAllOtherUsers(context);

    setState(() {});
  }

  void _onClickUser(AppUser other) {
    // 1:1 채팅방 입장
    ref.read(httpChatroomProvider.notifier).enterOneOnOneChatroom(
          context: context,
          currentUser: widget.currentUser,
          receiver: other,
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
              for (var other in _otherUsers)
                ListTile(
                  onTap: () => _onClickUser(other),
                  leading: CircleAvatar(
                    radius: Sizes.size28,
                    foregroundImage: getProfileImgByUserProfileImageUrl(
                      other.hasProfileImage,
                      other.profileImageUrl,
                      false,
                    ),
                    child: ClipOval(child: Text(other.displayName)),
                  ),
                  title: Text(other.displayName),
                  subtitle: Text(other.username),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
