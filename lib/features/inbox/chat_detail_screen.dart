import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/profile_images.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class ChatDetailScreen extends StatelessWidget {
  const ChatDetailScreen({super.key});

  /*
    TODO - 코드 챌린지 (프로필 사진 / 메세지 전송 필드)
       1) 프로필 사진 -  Stack 으로 감싼 후 active now 일 경우 표시되는 초록 점 구현 (positioned 와 container 사용)
            >> 초록 점이 프로필 우측 하단에 위치하며, 흰 테둘레가 있는 초록점으로 구현됨
       2) 메세지 전송 필드 - 댓글 필드 참조
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: Sizes.size8,
          leading: Stack(
            // 아래 Positioned 대신 사용 가능
            // alignment: AlignmentDirectional.bottomEnd,
            children: [
              Padding(
                padding: const EdgeInsets.all(Sizes.size4),
                child: CircleAvatar(
                  radius: Sizes.size24,
                  foregroundImage: jasonImage,
                  child: const Text('쩨이쓴'),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  height: Sizes.size20,
                  width: Sizes.size20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.shade400,
                    border: Border.all(
                      color: Colors.white,
                      width: Sizes.size3,
                    ),
                  ),
                ),
              ),
              // Positioned(
              //   // left:1,
              //   // right: 3,
              //   // top:10,
              //   child: Container(
              //     width: Sizes.size16,
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: Colors.green.shade300,
              //     ),
              //   ),
              // ),
            ],
          ),
          title: const Text(
            '쭌희',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: const Text('Active now'),
          trailing: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.flag,
                size: Sizes.size22,
                color: Colors.black,
              ),
              Gaps.h32,
              FaIcon(
                FontAwesomeIcons.ellipsis,
                size: Sizes.size20,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView.separated(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size20,
              horizontal: Sizes.size14,
            ),
            itemCount: 2,
            separatorBuilder: (context, index) => Gaps.v10,
            itemBuilder: (context, index) {
              final isMine = index % 3 < 2;
              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment:
                    isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isMine
                          ? const Color(0xFF609EC2)
                          : Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(Sizes.size20),
                        topRight: const Radius.circular(Sizes.size20),
                        bottomLeft: Radius.circular(
                            isMine ? Sizes.size20 : Sizes.size5),
                        bottomRight: Radius.circular(
                            isMine ? Sizes.size5 : Sizes.size20),
                      ),
                    ),
                    padding: const EdgeInsets.all(Sizes.size14),
                    child: const Text(
                      '쭌희 이모 곧 4주차',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Sizes.size16,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: BottomAppBar(
              color: Colors.grey.shade50,
              child: Row(
                children: [
                  const Expanded(child: TextField()),
                  Gaps.h20,
                  Stack(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.paperPlane,
                        color: Colors.grey.shade700,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
