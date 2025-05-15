import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/authentication/providers/auth_status_provider.dart';
import 'package:snapster_app/features/file/constants/upload_file_type.dart';
import 'package:snapster_app/features/file/models/uploaded_file_model.dart';
import 'package:snapster_app/features/file/providers/file_provider.dart';
import 'package:snapster_app/features/file/repositories/file_repository.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/utils/exception_handlers/base_exception_handler_2.dart';

class ProfileAvatarUploadViewModel extends AsyncNotifier<void> {
  late final FileRepository _fileRepository;
  late final AppUser? _currentUser;

  @override
  FutureOr<void> build() {
    _fileRepository = ref.read(fileRepositoryProvider);
    _currentUser = ref.watch(authStateProvider).user;
  }

  String _getFileName(AppUser currentUser, File file) {
    final fileExtension = file.path.split('.').last;
    return UploadFileType.generateProfileFileName(
        '${currentUser.userId}.$fileExtension');
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

          if (_currentUser == null) throw Exception('로그인이 필요한 작업입니다.');

          final fileName = _getFileName(_currentUser, file);
          state = await AsyncValue.guard(() async {
            // presigned-url 발급
            final presignedUrl =
                await _fileRepository.getPresignedUrl(fileName);
            if (presignedUrl == null) throw Exception('Failed to get URL');

            // 파일 업로드
            final success = await _fileRepository.uploadFile(
                presignedUrl.presignedUrl, file);
            if (!success) throw Exception('Upload to Storage Failed');

            // 업로드 파일 정보 저장
            final saveSuccess = await _fileRepository.saveUploadedFileInfo(
              presignedUrl.uploadedFileInfo.copyWith(
                type: UploadFileType.profile,
              ),
            );
            if (!saveSuccess) {
              throw Exception('Couldn\'t save uploaded file info');
            }

            // currentUser의 프로필 url 업데이트
            final uploadedFileUrl = presignedUrl.uploadedFileInfo.url;

            // 사용자 정보 업데이트
            _updateCurrentUser(
              currentUser: _currentUser,
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

          if (_currentUser == null) throw Exception('로그인이 필요한 작업입니다.');

          state = await AsyncValue.guard(() async {
            _fileRepository.updateFileAsDeleted(UploadedFileModel(
              userId: _currentUser.userId,
              fileName: '',
              s3FilePath: '',
              url: _currentUser.profileImageUrl,
            ));
          });

          // 사용자 정보 업데이트
          _updateCurrentUser(
            currentUser: _currentUser,
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
