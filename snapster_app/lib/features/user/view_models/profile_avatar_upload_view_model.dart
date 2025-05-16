import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/authentication/providers/auth_status_provider.dart';
import 'package:snapster_app/features/file/constants/upload_file_type.dart';
import 'package:snapster_app/features/file/models/uploaded_file_model.dart';
import 'package:snapster_app/features/file/utils/common_upload_process_mixin.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/utils/exception_handlers/base_exception_handler_2.dart';

class ProfileAvatarUploadViewModel extends AsyncNotifier<void>
    with CommonUploadProcessHandlerMixin {
  @override
  FutureOr<void> build() {
    initCommonUpload(ref); // mixin 초기화
  }

  void _updateCurrentUser({
    required AppUser currentUser,
    required bool hasProfileImage,
    required String profileImageUrl,
  }) {
    ref.read(authStateProvider.notifier).updateCurrentUser(
          currentUser.copyWith(
            hasProfileImage: hasProfileImage,
            profileImageUrl: profileImageUrl,
          ),
        );
  }

  Future<void> uploadProfileImage(
    BuildContext context,
    File file,
  ) async {
    await runFutureWithExceptionHandler(
        context: context,
        errMsgPrefix: '프로필 사진 업로드 오류',
        callBackFunction: () async {
          state = const AsyncValue.loading();

          if (currentUser == null) throw Exception('로그인이 필요한 작업입니다.');

          final fileName = UploadFileType.generateProfileFilePath(file);
          state = await AsyncValue.guard(() async {
            // presigned-url 발급
            final presignedUrl = await getPresignedUrl(fileName);

            // 파일 업로드
            await uploadFile(presignedUrl, file);

            // 업로드 파일 정보 저장
            await saveUploadedFileInfo(presignedUrl, UploadFileType.profile);

            // currentUser의 프로필 url 업데이트
            final uploadedFileUrl = presignedUrl.uploadedFileInfo.url;

            // 사용자 정보 업데이트
            _updateCurrentUser(
              currentUser: currentUser!,
              hasProfileImage: uploadedFileUrl.isNotEmpty,
              profileImageUrl: uploadedFileUrl,
            );
          });
        });
  }

  Future<void> deleteProfileImage(BuildContext context) async {
    await runFutureWithExceptionHandler(
        context: context,
        errMsgPrefix: '프로필 사진 삭제 오류',
        callBackFunction: () async {
          state = const AsyncValue.loading();

          if (currentUser == null) throw Exception('로그인이 필요한 작업입니다.');

          state = await AsyncValue.guard(() async {
            fileRepository.updateFileAsDeleted(UploadedFileModel(
              userId: currentUser!.userId,
              fileName: '',
              s3FilePath: '',
              url: currentUser!.profileImageUrl,
            ));
          });

          // 사용자 정보 업데이트
          _updateCurrentUser(
            currentUser: currentUser!,
            hasProfileImage: false,
            profileImageUrl: '',
          );
        });
  }
}

final profileAvatarProvider =
    AsyncNotifierProvider<ProfileAvatarUploadViewModel, void>(
  () => ProfileAvatarUploadViewModel(),
);
