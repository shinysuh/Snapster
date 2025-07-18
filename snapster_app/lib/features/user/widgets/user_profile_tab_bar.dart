import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snapster_app/common/widgets/video_config/video_config.dart';
import 'package:snapster_app/constants/sizes.dart';

class UserProfileTabBar extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: screenModeConfig,
      builder: (context, mode, child) {
        final isDark = mode == ThemeMode.dark;
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor,
            border: Border.symmetric(
              horizontal: BorderSide(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                width: 0.5,
              ),
            ),
          ),
          child: TabBar(
            labelPadding: const EdgeInsets.symmetric(
              vertical: Sizes.size10,
            ),
            indicatorColor: Theme.of(context).tabBarTheme.indicatorColor,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size20,
                ),
                child: Icon(
                  Icons.grid_view_rounded,
                  size: Sizes.size24,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size20,
                ),
                child: FaIcon(
                  FontAwesomeIcons.heart,
                  size: Sizes.size22,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  double get maxExtent => 47;

  @override
  double get minExtent => 47;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
