import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/views/activity_screen.dart';
import 'package:tiktok_clone/features/settings/settings_screen.dart';
import 'package:tiktok_clone/features/user/models/user_profile_model.dart';
import 'package:tiktok_clone/features/user/view_models/user_profile_view_model.dart';
import 'package:tiktok_clone/features/user/view_models/user_view_model.dart';
import 'package:tiktok_clone/features/user/views/user_profile_form_screen.dart';
import 'package:tiktok_clone/features/user/widgets/avatar.dart';
import 'package:tiktok_clone/features/user/widgets/follow_info.dart';
import 'package:tiktok_clone/features/user/widgets/profile_button.dart';
import 'package:tiktok_clone/features/user/widgets/user_profile_tab_bar.dart';
import 'package:tiktok_clone/utils/navigator_redirection.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String username;
  final String show;

  const UserProfileScreen({
    super.key,
    required this.username,
    required this.show,
  });

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  final _videoRatio = 4 / 5;

  void _onTapEditProfile(UserProfileModel profile) {
    goToRouteNamed(
      context: context,
      routeName: UserProfileFormScreen.routeName,
      extra: profile,
    );
  }

  void _onTapBell() {
    goToRouteNamed(
      context: context,
      routeName: ActivityScreen.routeName,
    );
  }

  void _onTapGear() {
    redirectToScreen(
      context: context,
      targetScreen: const SettingsScreen(),
      // isFullScreen: true,
    );
  }

  Widget _getUserPic(UserProfileModel user, bool isVertical) {
    return Column(
      children: [
        Gaps.v10,
        Avatar(
          user: user,
          isVertical: isVertical,
          isEditable: false,
        ),
        Gaps.v20,
        _getUserId(user),
      ],
    );
  }

  Widget _getUserId(UserProfileModel user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '@${user.username}',
          style: const TextStyle(
            fontSize: Sizes.size16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gaps.h5,
        const FaIcon(
          FontAwesomeIcons.solidCircleCheck,
          size: Sizes.size18,
          color: Color(0xFF82CFE8),
        ),
      ],
    );
  }

  Widget _getFollowInfo(UserProfileModel user) {
    return SizedBox(
      height: Sizes.size52,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FollowInfo(
            text: '97',
            description: 'Following',
          ),
          VerticalDivider(
            width: Sizes.size32,
            thickness: Sizes.size1,
            color: Colors.grey.shade300,
            indent: Sizes.size14,
            endIndent: Sizes.size14,
          ),
          const FollowInfo(
            text: '10.5M',
            description: 'Followers',
          ),
          VerticalDivider(
            width: Sizes.size32,
            thickness: Sizes.size1,
            color: Colors.grey.shade300,
            indent: Sizes.size14,
            endIndent: Sizes.size14,
          ),
          const FollowInfo(
            text: '149.3M',
            description: 'Likes',
          ),
        ],
      ),
    );
  }

  Widget _getButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: Sizes.size96 + Sizes.size80,
          height: Sizes.size44 + Sizes.size2,
          padding: const EdgeInsets.symmetric(
            vertical: Sizes.size12,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(Sizes.size2),
          ),
          child: const Center(
            child: Text(
              'Follow',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Gaps.h6,
        ProfileButton(
          icon: FontAwesomeIcons.youtube,
          iconSize: Sizes.size20 + Sizes.size1,
          padding: const EdgeInsets.all(Sizes.size10),
          onTap: () {},
        ),
        Gaps.h6,
        ProfileButton(
          icon: FontAwesomeIcons.sortDown,
          iconSize: Sizes.size14,
          padding: const EdgeInsets.only(bottom: Sizes.size8),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _getBio(UserProfileModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.size32),
      child: Column(
        children: [
          if (user.bio.isNotEmpty)
            Text(
              user.bio,
              textAlign: TextAlign.center,
            ),
          Gaps.v14,
          if (user.link.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: Sizes.size3),
                  child: FaIcon(
                    FontAwesomeIcons.link,
                    size: Sizes.size14,
                  ),
                ),
                Gaps.h8,
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: Text(
                    user.link,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }

  List<Widget> _getUserInfo(UserProfileModel user) {
    return [
      _getFollowInfo(user),
      Gaps.v14,
      _getButtons(),
      Gaps.v14,
      _getBio(user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(userProvider).when(
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          data: (user) => Scaffold(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // var width = MediaQuery.of(context).size.width;
                  var width = constraints.maxWidth;
                  var isVertical = width < Breakpoints.md;
                  var colCount = isVertical
                      ? 3
                      : width < Breakpoints.lg
                          ? 4
                          : 5;
                  return DefaultTabController(
                    initialIndex: widget.show == 'likes' ? 1 : 0,
                    length: 2,
                    child: NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) => [
                        SliverAppBar(
                          centerTitle: true,
                          title: Text(user.name),
                          actions: [
                            IconButton(
                              onPressed: () => _onTapEditProfile(user),
                              icon: const FaIcon(
                                FontAwesomeIcons.pen,
                                size: Sizes.size18,
                              ),
                            ),
                            IconButton(
                              onPressed: _onTapBell,
                              icon: const FaIcon(
                                FontAwesomeIcons.bell,
                                size: Sizes.size20,
                              ),
                            ),
                            IconButton(
                              onPressed: _onTapGear,
                              icon: const FaIcon(
                                FontAwesomeIcons.gear,
                                size: Sizes.size20,
                              ),
                            ),
                          ],
                        ),
                        SliverToBoxAdapter(
                          child: isVertical
                              ? Column(
                                  children: [
                                    _getUserPic(user, isVertical),
                                    Gaps.v24,
                                    ..._getUserInfo(user),
                                    Gaps.v20,
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _getUserPic(user, isVertical),
                                    Column(
                                      children: [
                                        ..._getUserInfo(user),
                                        Gaps.v20,
                                      ],
                                    ),
                                  ],
                                ),
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          floating: true,
                          delegate: UserProfileTabBar(),
                        ),
                      ],
                      body: TabBarView(
                        children: [
                          ref
                              .watch(uploadedThumbnailListProvider(user.uid))
                              .when(
                                loading: () => const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                                error: (error, stackTrace) => Center(
                                  child: Text(error.toString()),
                                ),
                                data: (thumbnails) {
                                  return GridView.builder(
                                    // 드래그 시에 keyboard dismiss
                                    keyboardDismissBehavior:
                                        ScrollViewKeyboardDismissBehavior
                                            .onDrag,
                                    itemCount: thumbnails.length,
                                    padding:
                                        const EdgeInsets.only(top: Sizes.size5),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: colCount,
                                      crossAxisSpacing: Sizes.size2,
                                      mainAxisSpacing: Sizes.size2,
                                      childAspectRatio: _videoRatio,
                                    ),
                                    itemBuilder: (context, index) {
                                      var thumbnail = thumbnails[index];
                                      return Stack(
                                        children: [
                                          Column(
                                            children: [
                                              AspectRatio(
                                                aspectRatio: _videoRatio,
                                                child: FadeInImage.assetNetwork(
                                                  fit: BoxFit.cover,
                                                  placeholder:
                                                      'assets/images/18.jpeg',
                                                  image: thumbnail.thumbnailUrl,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Positioned(
                                            bottom: 0,
                                            left: 0,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.play_arrow_outlined,
                                                  color: Colors.white,
                                                  size: Sizes.size26,
                                                ),
                                                Text(
                                                  '2.6K',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: Sizes.size14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                          GridView.builder(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: 20,
                            padding: const EdgeInsets.only(top: Sizes.size5),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: colCount,
                              crossAxisSpacing: Sizes.size2,
                              mainAxisSpacing: Sizes.size2,
                              childAspectRatio: _videoRatio,
                            ),
                            itemBuilder: (context, index) => Stack(
                              children: [
                                Column(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: _videoRatio,
                                      child: const Image(
                                        fit: BoxFit.cover,
                                        image:
                                            AssetImage('assets/images/18.jpeg'),
                                      ),
                                    ),
                                  ],
                                ),
                                const Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.play_arrow_outlined,
                                        color: Colors.white,
                                        size: Sizes.size26,
                                      ),
                                      Text(
                                        '36.1K',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Sizes.size14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
  }
}
