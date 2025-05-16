import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snapster_app/constants/breakpoints.dart';
import 'package:snapster_app/constants/gaps.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/authentication/providers/auth_status_provider.dart';
import 'package:snapster_app/features/feed/view_models/feed_view_model.dart';
import 'package:snapster_app/features/inbox/views/activity_screen.dart';
import 'package:snapster_app/features/settings/settings_screen.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/features/user/view_models/user_profile_view_model.dart';
import 'package:snapster_app/features/user/views/user_profile_form_screen.dart';
import 'package:snapster_app/features/user/widgets/follow_info.dart';
import 'package:snapster_app/features/user/widgets/profile_avatar.dart';
import 'package:snapster_app/features/user/widgets/profile_button.dart';
import 'package:snapster_app/features/user/widgets/user_profile_tab_bar.dart';
import 'package:snapster_app/features/video/models/video_post_model.dart';
import 'package:snapster_app/features/video_old/models/thumbnail_link_model.dart';
import 'package:snapster_app/utils/navigator_redirection.dart';

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
  final _username = '쭌희';
  final _userAccount = 'Jason_2426';
  final _videoRatio = 4 / 5;

  void _onTapEditProfile(AppUser user) {
    goToRouteNamed(
      context: context,
      routeName: UserProfileFormScreen.routeName,
      extra: user,
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

  Widget _getUserPic(AppUser user, bool isVertical) {
    return Column(
      children: [
        Gaps.v10,
        ProfileAvatar(
          user: user,
          isVertical: isVertical,
          isEditable: false,
        ),
        Gaps.v20,
        _getUserId(user),
      ],
    );
  }

  Widget _getUserId(AppUser user) {
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

  Widget _getFollowInfo(AppUser user) {
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
          // Expanded => flex 보다 고정 값이 더 보기 좋을 듯 (화면 회전 시 등등)
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

  Widget _getBio(AppUser user) {
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

  List<Widget> _getUserInfo(AppUser user) {
    return [
      _getFollowInfo(user),
      Gaps.v14,
      _getButtons(),
      Gaps.v14,
      _getBio(user),
    ];
  }

  Widget _getPlayCount(String count) {
    return Positioned(
      bottom: 0,
      left: 0,
      child: Row(
        children: [
          const Icon(
            Icons.play_arrow_outlined,
            color: Colors.white,
            size: Sizes.size26,
          ),
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: Sizes.size14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getFeedGridViewByTabBar({
    required int colCount,
    required String playCount,
    required List<VideoPostModel> feedData,
  }) {
    return GridView.builder(
      // 드래그 시에 keyboard dismiss
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: feedData.length,
      padding: const EdgeInsets.only(top: Sizes.size5),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // crossAxisCount => grid 의 컬럼 개수
        crossAxisCount: colCount,
        crossAxisSpacing: Sizes.size2,
        mainAxisSpacing: Sizes.size2,
        childAspectRatio: _videoRatio,
      ),
      itemBuilder: (context, index) {
        var feed = feedData[index];
        return Stack(
          children: [
            Column(
              children: [
                AspectRatio(
                  aspectRatio: _videoRatio,
                  child: Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      feed.thumbnailUrl,
                    ),
                  ),
                ),
              ],
            ),
            _getPlayCount('2.6K'),
          ],
        );
      },
    );
  }

  Widget _getGridViewByTabBar({
    required int colCount,
    required String playCount,
    required List<ThumbnailLinkModel> thumbnailData,
  }) {
    return GridView.builder(
      // 드래그 시에 keyboard dismiss
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: thumbnailData.length,
      padding: const EdgeInsets.only(top: Sizes.size5),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // crossAxisCount => grid 의 컬럼 개수
        crossAxisCount: colCount,
        crossAxisSpacing: Sizes.size2,
        mainAxisSpacing: Sizes.size2,
        childAspectRatio: _videoRatio,
      ),
      // Image.asset(url) 로 asset 폴더 내 이미지 fetch
      // Image.network(url) 로 네트워크 상 이미지 fetch
      // FadeInImage.assetNetwork(placeholder, image) => placeholder 이미지가 assets 폴더에 있음
      itemBuilder: (context, index) {
        var thumbnail = thumbnailData[index];
        return Stack(
          children: [
            Column(
              children: [
                AspectRatio(
                  aspectRatio: _videoRatio,
                  child: Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      thumbnail.thumbnailUrl,
                    ),
                  ),
                  // child: FadeInImage.assetNetwork(
                  //   fit: BoxFit.cover,
                  //   placeholder:
                  //       'assets/images/18.jpeg',
                  //   image: thumbnail.thumbnailUrl,
                  //   // "https://thumbs.dreamstime.com/b/vertical-photo-clear-night-sky-milky-way-huge-amount-stars-landscape-205856007.jpg",
                  // ),
                ),
              ],
            ),
            _getPlayCount('2.6K'),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final isDark = isDarkMode(context);
    final authState = ref.watch(authStateProvider);

    if (authState.status == AuthStatus.loading) {
      return const CircularProgressIndicator();
    }

    if (authState.status == AuthStatus.unauthenticated) {
      return const Center(child: Text("로그인이 필요합니다."));
    }

    // authenticated일 때만 currentUserProvider 구독
    // final userAsync = ref.watch(currentUserProvider);

    final user = authState.user;

    if (user == null) {
      debugPrint("########## user null");
      return const Center(child: Text('유저 정보가 없습니다.'));
    }

    return Scaffold(
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
              /* NestedScrollView => Sliver 와 TabBarView 를 동시에 사용할 때 적용 */
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    centerTitle: true,
                    // backgroundColor: isDark ? Colors.black : Colors.white,
                    title: Text(user.displayName),
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
                        .watch(feedViewModelProvider(user.userId))
                        // .watch(uploadedThumbnailListProvider(user.userId))
                        .when(
                          loading: () => const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                          error: (error, stackTrace) => Center(
                            child: Text('FEED ERROR: ${error.toString()}'),
                          ),
                          data: (feeds) => _getFeedGridViewByTabBar(
                            colCount: colCount,
                            playCount: '2.6K',
                            feedData: feeds,
                          ),
                        ),
                    ref.watch(likedThumbnailListProvider(user.userId)).when(
                          loading: () => const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                          error: (error, stackTrace) => Center(
                            child: Text(error.toString()),
                          ),
                          data: (likes) => _getGridViewByTabBar(
                            colCount: colCount,
                            playCount: '36.1K',
                            thumbnailData: likes,
                          ),
                        ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );

    // return userAsync.when(
    //   loading: () {
    //     debugPrint("########## loading");
    //     return const Center(
    //       child: CircularProgressIndicator.adaptive(),
    //     );
    //   },
    //   error: (error, stackTrace) => Center(
    //     child: Text(error.toString()),
    //   ),
    //   data: (user) {
    //     debugPrint("########## user data: $user"); // 데이터 상태 확인
    //     if (user == null) {
    //       debugPrint("########## user null");
    //       return const Center(child: Text('No user data available'));
    //     }
    //     return Scaffold(
    //       backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
    //       body: SafeArea(
    //         child: LayoutBuilder(
    //           builder: (context, constraints) {
    //             // var width = MediaQuery.of(context).size.width;
    //             var width = constraints.maxWidth;
    //             var isVertical = width < Breakpoints.md;
    //             var colCount = isVertical
    //                 ? 3
    //                 : width < Breakpoints.lg
    //                     ? 4
    //                     : 5;
    //             return DefaultTabController(
    //               initialIndex: widget.show == 'likes' ? 1 : 0,
    //               length: 2,
    //               /* NestedScrollView => Sliver 와 TabBarView 를 동시에 사용할 때 적용 */
    //               child: NestedScrollView(
    //                 headerSliverBuilder: (context, innerBoxIsScrolled) => [
    //                   SliverAppBar(
    //                     centerTitle: true,
    //                     // backgroundColor: isDark ? Colors.black : Colors.white,
    //                     title: Text(user.displayName),
    //                     actions: [
    //                       IconButton(
    //                         onPressed: () => _onTapEditProfile(user),
    //                         icon: const FaIcon(
    //                           FontAwesomeIcons.pen,
    //                           size: Sizes.size18,
    //                         ),
    //                       ),
    //                       IconButton(
    //                         onPressed: _onTapBell,
    //                         icon: const FaIcon(
    //                           FontAwesomeIcons.bell,
    //                           size: Sizes.size20,
    //                         ),
    //                       ),
    //                       IconButton(
    //                         onPressed: _onTapGear,
    //                         icon: const FaIcon(
    //                           FontAwesomeIcons.gear,
    //                           size: Sizes.size20,
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                   SliverToBoxAdapter(
    //                     child: isVertical
    //                         ? Column(
    //                             children: [
    //                               _getUserPic(user, isVertical),
    //                               Gaps.v24,
    //                               ..._getUserInfo(user),
    //                               Gaps.v20,
    //                             ],
    //                           )
    //                         : Row(
    //                             mainAxisAlignment: MainAxisAlignment.center,
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             children: [
    //                               _getUserPic(user, isVertical),
    //                               Column(
    //                                 children: [
    //                                   ..._getUserInfo(user),
    //                                   Gaps.v20,
    //                                 ],
    //                               ),
    //                             ],
    //                           ),
    //                   ),
    //                   SliverPersistentHeader(
    //                     pinned: true,
    //                     floating: true,
    //                     delegate: UserProfileTabBar(),
    //                   ),
    //                 ],
    //                 body: TabBarView(
    //                   children: [
    //                     ref
    //                         .watch(uploadedThumbnailListProvider(user.userId))
    //                         .when(
    //                           loading: () => const Center(
    //                             child: CircularProgressIndicator.adaptive(),
    //                           ),
    //                           error: (error, stackTrace) => Center(
    //                             child: Text(error.toString()),
    //                           ),
    //                           data: (thumbnails) => _getGridViewByTabBar(
    //                             colCount: colCount,
    //                             playCount: '2.6K',
    //                             thumbnailData: thumbnails,
    //                           ),
    //                         ),
    //                     ref.watch(likedThumbnailListProvider(user.userId)).when(
    //                           loading: () => const Center(
    //                             child: CircularProgressIndicator.adaptive(),
    //                           ),
    //                           error: (error, stackTrace) => Center(
    //                             child: Text(error.toString()),
    //                           ),
    //                           data: (likes) => _getGridViewByTabBar(
    //                             colCount: colCount,
    //                             playCount: '36.1K',
    //                             thumbnailData: likes,
    //                           ),
    //                         ),
    //                   ],
    //                 ),
    //               ),
    //             );
    //           },
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}
