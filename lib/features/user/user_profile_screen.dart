import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/profile_images.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/user/widgets/follow_info.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _username = '쭌희';
  final _userAccount = 'Jason_2426';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: Text(_username),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const FaIcon(
                  FontAwesomeIcons.gear,
                  size: Sizes.size20,
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                CircleAvatar(
                  radius: Sizes.size48 + Sizes.size2,
                  foregroundColor: Colors.indigo,
                  foregroundImage: jasonImage,
                  child: Text(_userAccount),
                ),
                Gaps.v20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '@$_userAccount',
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
                ),
                Gaps.v24,
                SizedBox(
                  height: Sizes.size48,
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
                ),
                Gaps.v14,
                Row(
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
                    Container(
                      width: Sizes.size44,
                      height: Sizes.size44 + Sizes.size2,
                      padding: const EdgeInsets.all(Sizes.size10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Sizes.size2),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.youtube,
                          size: Sizes.size20 + Sizes.size1,
                        ),
                      ),
                    ),
                    Gaps.h6,
                    Container(
                      width: Sizes.size44,
                      height: Sizes.size44 + Sizes.size2,
                      padding: const EdgeInsets.only(bottom: Sizes.size8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(Sizes.size2),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          )),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.sortDown,
                          size: Sizes.size14,
                        ),
                      ),
                    ),
                  ],
                ),
                Gaps.v14,
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.size32),
                  child: Text(
                    "If you are looking for lovely moments of Jason, \nyou're at the right place:)",
                    textAlign: TextAlign.center,
                  ),
                ),
                Gaps.v14,
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.link,
                      size: Sizes.size14,
                    ),
                    Gaps.h4,
                    Text(
                      'https://www.jason_lee.com',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Gaps.v20,
                Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: Colors.grey.shade200,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: const TabBar(
                    labelColor: Colors.black,
                    labelPadding: EdgeInsets.symmetric(
                      vertical: Sizes.size10,
                    ),
                    indicatorColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizes.size20,
                        ),
                        child: Icon(
                          Icons.grid_4x4_rounded,
                          size: Sizes.size22,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizes.size20,
                        ),
                        child: FaIcon(
                          FontAwesomeIcons.heart,
                          size: Sizes.size22,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        body: TabBarView(
          children: [
            GridView.builder(
              // 드래그 시에 keyboard dismiss
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: 20,
              padding: const EdgeInsets.all(Sizes.size6),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                // crossAxisCount => grid 의 컬럼 개수
                crossAxisCount: 2,
                crossAxisSpacing: Sizes.size8,
                mainAxisSpacing: Sizes.size20,
                childAspectRatio: 9 / 20,
              ),
              // Image.asset(url) 로 asset 폴더 내 이미지 fetch
              // Image.network(url) 로 네트워크 상 이미지 fetch
              // FadeInImage.assetNetwork(placeholder, image) => placeholder 이미지가 assets 폴더에 있음
              itemBuilder: (context, index) => Column(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Sizes.size4),
                    ),
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          placeholder: 'assets/images/1.jpeg',
                          image:
                              "https://media.istockphoto.com/id/477057828/photo/blue-sky-white-cloud.jpg?s=612x612&w=0&k=20&c=GEjySNaROrUD7TJUqoXEiBDI9yMmr2hUviSOox4SDlU="),
                    ),
                  ),
                  Gaps.v10,
                  const Text(
                    "This is a very long caption for my tiktok that I'm uploading just for now",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Sizes.size18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Gaps.v8,
                  DefaultTextStyle(
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: Sizes.size14,
                      fontWeight: FontWeight.w500,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: Sizes.size12,
                          backgroundImage: profileImage,
                        ),
                        Gaps.h4,
                        const Expanded(
                          child: Text(
                            'My Avatar is going to be very long',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Gaps.h4,
                        FaIcon(
                          FontAwesomeIcons.heart,
                          size: Sizes.size14,
                          color: Colors.grey.shade600,
                        ),
                        Gaps.h2,
                        const Text(
                          '5.2K',
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Text('page 2'),
            ),
          ],
        ),
      ),
    );
  }
}
