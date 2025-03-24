// import 'package:flutter/material.dart';
// import 'package:tiktok_clone/constants/sizes.dart';
//
// class UserProfileScreen extends StatefulWidget {
//   const UserProfileScreen({super.key});
//
//   @override
//   State<UserProfileScreen> createState() => _UserProfileScreenState();
// }
//
// class _UserProfileScreenState extends State<UserProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       slivers: [
//         SliverAppBar(
//           snap: true,
//           floating: true,
//           stretch: true,
//           // pinned: true,
//           backgroundColor: Colors.pink.shade100,
//           collapsedHeight: 80,
//           expandedHeight: 250,
//           flexibleSpace: FlexibleSpaceBar(
//             titlePadding: const EdgeInsets.symmetric(
//               vertical: Sizes.size10,
//             ),
//             stretchModes: const [
//               StretchMode.blurBackground,
//               StretchMode.zoomBackground,
//               StretchMode.fadeTitle,
//             ],
//             title: const Text('Jason!'),
//             background: Image.asset(
//               'assets/images/18.jpeg',
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         const SliverToBoxAdapter(
//           child: Column(
//             children: [
//               CircleAvatar(
//                 radius: 20,
//                 backgroundColor: Colors.red,
//               ),
//             ],
//           ),
//         ),
//         SliverFixedExtentList(
//           delegate: SliverChildBuilderDelegate(
//             childCount: 10,
//                 (context, index) => Container(
//               alignment: Alignment.center,
//               color: Colors.indigo[100 * (index % 9)],
//               child: Text('Item $index'),
//             ),
//           ),
//           itemExtent: 100,
//         ),
//         SliverPersistentHeader(
//           delegate: CustomDelegate(),
//           pinned: true,
//           // floating: true,
//         ),
//         SliverGrid(
//           delegate: SliverChildBuilderDelegate(
//             childCount: 30,
//                 (context, index) => Container(
//               alignment: Alignment.center,
//               color: Colors.pink[100 * (index % 9)],
//               child: Text('Item $index'),
//             ),
//           ),
//           gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//             maxCrossAxisExtent: 100,
//             mainAxisSpacing: 20,
//             crossAxisSpacing: 20,
//             childAspectRatio: 1,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class CustomDelegate extends SliverPersistentHeaderDelegate {
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: Colors.amber,
//       child: const FractionallySizedBox(
//         heightFactor: 1,
//         child: Center(
//           child: Text('title'),
//         ),
//       ),
//     );
//   }
//
//   @override
//   double get maxExtent => 150;
//
//   @override
//   double get minExtent => 80;
//
//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     return false;
//     // throw UnimplementedError();
//   }
// }
