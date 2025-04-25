import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/authentication/providers/auth_status_provider.dart';
import 'package:snapster_app/features/authentication/providers/http_auth_provider.dart';
import 'package:snapster_app/features/file/constants/upload_folder.dart';
import 'package:snapster_app/features/file/providers/file_provider.dart';
import 'package:snapster_app/features/file/repositories/file_repository.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/utils/base_exception_handler.dart';

class AvatarUploadViewModel extends AsyncNotifier<void> {
  late final FileRepository _fileRepository;
  late final AppUser? _currentUser;

  @override
  FutureOr<void> build() {
    _fileRepository = ref.read(fileRepositoryProvider);
    _currentUser = ref.watch(authStateProvider).user;
  }

  String _getFileName(AppUser currentUser, File file) {
    final fileExtension = file.path.split('.').last;
    return UploadFolder.generateProfileFileName(
        '${currentUser.userId}.$fileExtension');
  }

  Future<void> uploadProfileImage(
    BuildContext context,
    File file,
  ) async {
    try {
      state = const AsyncValue.loading();

      if (_currentUser == null) throw Exception('로그인이 필요한 작업입니다.');

      final fileName = _getFileName(_currentUser, file);
      state = await AsyncValue.guard(() async {
        // presigned-url 발급
        final presignedUrl = await _fileRepository.getPresignedUrl(fileName);
        if (presignedUrl == null) throw Exception('Failed to get URL');

        // 파일 업로드
        final success =
            await _fileRepository.uploadFile(presignedUrl.presignedUrl, file);
        if (!success) throw Exception('Upload to Storage Failed');

        // 업로드 파일 정보 저장
        final saveSuccess = await _fileRepository
            .saveUploadedFileInfo(presignedUrl.uploadedFileInfo);
        if (!saveSuccess) throw Exception('Couldn\'t save uploaded file info');

        // currentUser의 프로필 url 업데이트
        final uploadedFileUrl = presignedUrl.uploadedFileInfo.url;
        ref.read(localEditableUserProvider.notifier).update(
              (user) => user.copyWith(
                profileImageUrl: uploadedFileUrl,
                hasProfileImage: uploadedFileUrl.isNotEmpty,
              ),
            );

        // ref
        //     .read(authRepositoryProvider)
        //     .updateUserProfileImage(uploadedFileUrl);

        // await ref
        //     .read(authStateProvider.notifier)
        //     .updateProfileImage(presignedUrl.uploadedFileInfo.url);
      });

      debugPrint('####### 프로필 사진 업로드 성공');
    } catch (e) {
      final errMessage = '프로필 사진 업로드 실패: $e';
      if (context.mounted) {
        showCustomErrorSnack(context, errMessage);
      } else {
        debugPrint(errMessage);
      }
    }
  }

  Future<void> deleteAvatar(String fileName) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      /*
            TODO
             1) 삭제 API 구현 후 요청
             2) 사용자 hasProfileImage = false 로 수정
         */
    });
  }
}

final avatarUploadProvider = AsyncNotifierProvider<AvatarUploadViewModel, void>(
  () => AvatarUploadViewModel(),
);
