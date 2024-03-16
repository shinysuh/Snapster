import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils/tap_to_unfocus.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final List<String> imageUrls = [
    'assets/images/1.jpeg',
    'assets/images/2.jpeg',
    'assets/images/5.jpeg',
    'assets/images/6.jpeg',
    'assets/images/13.jpeg',
    'assets/images/18.jpeg',
  ];

  final tabs = [
    'Top',
    'Users',
    'Videos',
    'Sounds',
    'LIVE',
    'Shopping',
    'Brands',
  ];

  final TextEditingController _textEditingController =
      TextEditingController(text: 'initial text');

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _onChangeSearchKeyword(String searchKeyword) {
    print('onChange: $searchKeyword');
  }

  void _onSubmitSearchKeyword(String searchKeyword) {
    print('Submitted keyword: $searchKeyword');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: GestureDetector(
        onTap: () => onTapOutsideAndDismissKeyboard(context),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 1,
            title: CupertinoSearchTextField(
              controller: _textEditingController,
              itemColor: Colors.black,
              onChanged: _onChangeSearchKeyword,
              onSubmitted: _onSubmitSearchKeyword,
            ),
            bottom: TabBar(
              isScrollable: true,
              splashFactory: NoSplash.splashFactory,
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size16,
              ),
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey.shade500,
              labelStyle: const TextStyle(
                fontSize: Sizes.size16,
                fontWeight: FontWeight.w600,
              ),
              tabs: [
                for (var tab in tabs) Tab(text: tab),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              GridView.builder(
                // 드래그 시에 keyboard dismiss
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
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
                            placeholder: imageUrls[0],
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
                          const CircleAvatar(
                            radius: Sizes.size12,
                            backgroundImage: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQIAr03vzZt9XBfML_UrBmXt80NW0YTgnKV1CJo3mm8gw&s',
                            ),
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
              for (var tab in tabs.skip(1))
                Center(
                  child: Text(
                    tab,
                    style: const TextStyle(
                      fontSize: Sizes.size28,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
