import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class VideoComments extends StatefulWidget {
  const VideoComments({super.key});

  @override
  State<VideoComments> createState() => _VideoCommentsState();
}

class _VideoCommentsState extends State<VideoComments> {
  void _closePopup() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.8,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.size14),
      ),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade50,
          title: const Text(
            '22796 comments',
            style: TextStyle(
              fontSize: Sizes.size16,
              fontWeight: FontWeight.w600,
            ),
          ),
          // automaticallyImplyLeading: 자동으로 back 버튼 생성 여부
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: _closePopup,
              icon: const FaIcon(
                FontAwesomeIcons.xmark,
                size: Sizes.size22,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.size10,
                horizontal: Sizes.size16,
              ),
              itemCount: 10,
              separatorBuilder: (context, index) => Gaps.v20,
              itemBuilder: (context, index) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: Sizes.size18,
                    child: Text('commenter_id'),
                  ),
                  Gaps.h10,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'jenna123',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: Sizes.size14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gaps.v3,
                        const Text(
                            'He is such an adorable creature. The prettiest baby I\'ve ever seen XD'),
                      ],
                    ),
                  ),
                  Gaps.v10,
                  Column(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.heart,
                        color: Colors.grey.shade500,
                        size: Sizes.size20,
                      ),
                      Gaps.v2,
                      Text(
                        '52.2K',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              width: size.width,
              child: BottomAppBar(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.size16,
                    vertical: Sizes.size10,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: Sizes.size18,
                        backgroundColor: Colors.grey.shade500,
                        foregroundColor: Colors.white,
                        foregroundImage: const NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQIAr03vzZt9XBfML_UrBmXt80NW0YTgnKV1CJo3mm8gw&s'),
                        child: const Text('jenna_suh'),
                      ),
                      Gaps.h10,
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.text,
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                            hintText: 'Add comment...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Sizes.size8),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: Sizes.size12,
                              horizontal: Sizes.size10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
