import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/profile_images.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils/tap_to_unfocus.dart';
import 'package:tiktok_clone/utils/theme_mode.dart';

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
      TextEditingController(text: '');

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

  void _onClearSearchKeyword() {
    _textEditingController.clear();
  }

  Widget _getSearchPanel() {
    // return CupertinoSearchTextField(
    //   controller: _textEditingController,
    //   itemColor: Colors.black,
    //   onChanged: _onChangeSearchKeyword,
    //   onSubmitted: _onSubmitSearchKeyword,
    // );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SizedBox(
            height: Sizes.size44,
            child: TextField(
              controller: _textEditingController,
              maxLines: 1,
              cursorColor: Theme.of(context).primaryColor,
              textInputAction: TextInputAction.send,
              onChanged: _onChangeSearchKeyword,
              onSubmitted: _onSubmitSearchKeyword,
              clipBehavior: Clip.hardEdge,
              style: const TextStyle(
                color: Colors.black,
                fontSize: Sizes.size18,
              ),
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Sizes.size8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size10,
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(
                    top: kIsWeb ? Sizes.size8 : Sizes.size12,
                    left: Sizes.size8,
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.magnifyingGlass,
                    size: Sizes.size20,
                    color: Colors.black,
                  ),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(
                    top: kIsWeb ? Sizes.size9 : Sizes.size11,
                    left: kIsWeb ? Sizes.size10 : Sizes.size20,
                  ),
                  child: GestureDetector(
                    onTap: _onClearSearchKeyword,
                    child: FaIcon(
                      FontAwesomeIcons.solidCircleXmark,
                      size: Sizes.size20,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Gaps.h22,
        const FaIcon(
          FontAwesomeIcons.sliders,
          size: Sizes.size28,
        ),
        Gaps.h8,
      ],
    );
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
            // ConstrainedBox -> Container 의 경우 그냥 내부에서 constraints 사용 가능
            title: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: Breakpoints.sm,
              ),
              child: _getSearchPanel(),
            ),
            bottom: TabBar(
              onTap: (value) => onTapOutsideAndDismissKeyboard(context),
              isScrollable: true,
              splashFactory: NoSplash.splashFactory,
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size16,
              ),
              indicatorColor: isDarkMode(context) ? Colors.white : Colors.black,
              labelColor: isDarkMode(context) ? Colors.white : Colors.black,
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
          body: LayoutBuilder(
            builder: (context, constraints) {
              // var width = MediaQuery.of(context).size.width;
              var width = constraints.maxWidth;
              var colCount = width < Breakpoints.sm
                  ? 2
                  : width < Breakpoints.md
                      ? 3
                      : 4;
              return TabBarView(
                children: [
                  GridView.builder(
                    // 드래그 시에 keyboard dismiss
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: 20,
                    padding: const EdgeInsets.all(Sizes.size6),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      // crossAxisCount => grid 의 컬럼 개수
                      crossAxisCount: colCount,
                      crossAxisSpacing: Sizes.size8,
                      mainAxisSpacing: Sizes.size20,
                      childAspectRatio: 9 / 22,
                    ),
                    // Image.asset(url) 로 asset 폴더 내 이미지 fetch
                    // Image.network(url) 로 네트워크 상 이미지 fetch
                    // FadeInImage.assetNetwork(placeholder, image) => placeholder 이미지가 assets 폴더에 있음
                    itemBuilder: (context, index) => LayoutBuilder(
                      builder: (context, constraints) => Column(
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
                          if (constraints.maxWidth < 200 ||
                              constraints.maxWidth > 230)
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
              );
            },
          ),
        ),
      ),
    );
  }
}
