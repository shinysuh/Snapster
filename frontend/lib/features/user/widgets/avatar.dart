import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/user/models/user_profile_model.dart';
import 'package:tiktok_clone/features/user/view_models/avatar_view_model.dart';
import 'package:tiktok_clone/utils/profile_network_img.dart';

class Avatar extends ConsumerWidget {
  final UserProfileModel user;
  final bool isVertical;
  final bool isEditable;

  const Avatar({
    super.key,
    required this.user,
    required this.isVertical,
    required this.isEditable,
  });

  Future<void> _onTapAvatar(WidgetRef ref) async {
    final xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 300,
      maxWidth: 300,
    );

    if (xFile != null) {
      final file = File(xFile.path);
      await ref.read(avatarProvider.notifier).uploadAvatar(file, user);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isLoading = ref.watch(avatarProvider).isLoading;

    return GestureDetector(
      onTap: isLoading || !isEditable ? null : () => _onTapAvatar(ref),
      child: isLoading
          ? Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator.adaptive(),
            )
          : CircleAvatar(
              radius: isVertical ? Sizes.size48 + Sizes.size2 : Sizes.size64,
              foregroundColor: Colors.indigo,
              foregroundImage:
                  user.hasAvatar ? getProfileImgByUserId(user.uid, true) : null,
              child: ClipOval(child: Text(user.name)),
            ),
    );
  }
}
