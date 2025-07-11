import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:snapster_app/constants/breakpoints.dart';
import 'package:snapster_app/constants/gaps.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/discover/view_models/search_view_model.dart';
import 'package:snapster_app/features/video/models/video_post_model.dart';
import 'package:snapster_app/utils/tap_to_unfocus.dart';
import 'package:snapster_app/utils/theme_mode.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  late final isDark = isDarkMode(context);
  final List<String> imageUrls = [
    'assets/images/1.jpeg',
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

  String _searchKeyword = '';

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _onChangeSearchKeyword(String searchKeyword) async {
    print('searchKeyword: $searchKeyword');
    setState(() {
      _searchKeyword = searchKeyword;
    });
    await _searchByKeywordPrefix(searchKeyword);
  }

  Future<void> _searchByKeywordPrefix(String searchKeyword) async {
    await ref
        .read(searchProvider.notifier)
        .onSearchKeywordChange(searchKeyword);
  }

  void _onSubmitSearchKeyword(String searchKeyword) {
    print('Submitted keyword: $searchKeyword');
  }

  void _onClearSearchKeyword() {
    _textEditingController.clear();
  }

  Widget _getSearchPanel(bool isDark) {
    return CupertinoSearchTextField(
      controller: _textEditingController,
      // itemColor: Colors.black,
      onChanged: _onChangeSearchKeyword,
      onSubmitted: _onSubmitSearchKeyword,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _getCustomizedSearchPanel(bool isDark) {
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
                fontSize: Sizes.size18,
              ),
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Sizes.size8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size10,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(
                    top: kIsWeb ? Sizes.size8 : Sizes.size11,
                    left: Sizes.size8,
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.magnifyingGlass,
                    size: Sizes.size20,
                    color: isDark ? Colors.grey.shade300 : Colors.black,
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
                      color:
                          isDark ? Colors.grey.shade400 : Colors.grey.shade600,
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

  Widget _getSearchGridView({
    required int colCount,
    required List<VideoPostModel> searchResults,
  }) {
    const aspectRation_1 = 9 / 18;
    const aspectRation_2 = 9 / 13;

    return GridView.builder(
      // 드래그 시에 keyboard dismiss
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: searchResults.length,
      padding: const EdgeInsets.all(Sizes.size6),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // crossAxisCount => grid 의 컬럼 개수
        crossAxisCount: colCount,
        crossAxisSpacing: Sizes.size8,
        mainAxisSpacing: Sizes.size8,
        childAspectRatio: aspectRation_1,
      ),
      itemBuilder: (context, index) => LayoutBuilder(
        builder: (context, constraints) {
          final result = searchResults[index];
          return Column(
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Sizes.size4),
                ),
                child: AspectRatio(
                  aspectRatio: aspectRation_2,
                  child: Image.network(
                    result.thumbnailUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Gaps.v10,
              Text(
                '${result.title}${result.description.isNotEmpty ? ' : ${result.description}' : ''}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: Sizes.size18,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
              Gaps.v8,
              if (constraints.maxWidth < 210 || constraints.maxWidth > 230)
                DefaultTextStyle(
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
                    fontSize: Sizes.size14,
                    fontWeight: FontWeight.w500,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: Sizes.size12,
                        backgroundImage:
                            NetworkImage(result.userProfileImageUrl),
                      ),
                      Gaps.h4,
                      Expanded(
                        child: Text(
                          result.userDisplayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Gaps.h4,
                      FaIcon(
                        FontAwesomeIcons.heart,
                        size: Sizes.size14,
                        color: isDark
                            ? Colors.grey.shade300
                            : Colors.grey.shade600,
                      ),
                      Gaps.h2,
                      Text(
                        NumberFormat.compact().format(result.likes),
                      )
                    ],
                  ),
                ),
            ],
          );
        },
      ),
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
              child: _getSearchPanel(isDark),
            ),
            bottom: TabBar(
              tabAlignment: TabAlignment.start,
              onTap: (value) => onTapOutsideAndDismissKeyboard(context),
              isScrollable: true,
              splashFactory: NoSplash.splashFactory,
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size16,
              ),
              // indicatorColor: isDark ? Colors.white : Colors.black,
              // labelColor: isDark ? Colors.white : Colors.black,
              // unselectedLabelColor: Colors.grey.shade500,
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
                  RefreshIndicator(
                    onRefresh: () => _searchByKeywordPrefix(_searchKeyword),
                    child: ref.watch(searchProvider).when(
                        loading: () => const Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                        error: (error, stackTrace) => Center(
                              child: Text('SEARCH ERROR: ${error.toString()}'),
                            ),
                        data: (searchResults) => _getSearchGridView(
                              colCount: colCount,
                              searchResults: searchResults,
                            )),
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
