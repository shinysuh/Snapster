import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/features/user/view_models/avatar_view_model.dart';
import 'package:snapster_app/features/user/view_models/profile_avatar_upload_view_model.dart';
import 'package:snapster_app/utils/profile_network_img.dart';

class ProfileAvatar extends ConsumerWidget {
  final AppUser user;
  final bool isVertical;
  final bool isEditable;

  const ProfileAvatar({
    super.key,
    required this.user,
    required this.isVertical,
    required this.isEditable,
  });

  Future<void> _onTapAvatar(BuildContext context, WidgetRef ref) async {
    final xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 300,
      maxWidth: 300,
    );

    if (xFile != null && context.mounted) {
      final file = File(xFile.path);
      await ref
          .read(profileAvatarProvider.notifier)
          .uploadProfileImage(context, file);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isLoading = ref.watch(avatarProvider).isLoading;

    return GestureDetector(
      onTap: isLoading || !isEditable ? null : () => _onTapAvatar(context, ref),
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
              foregroundImage: getProfileImgByUserProfileImageUrl(
                user.hasProfileImage,
                user.profileImageUrl,
                true,
              ),
              child: ClipOval(child: Text(user.displayName)),
            ),
    );
  }
}
