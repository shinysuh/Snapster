import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/authentication/providers/http_auth_provider.dart';
import 'package:snapster_app/features/file/constants/upload_folder.dart';
import 'package:snapster_app/features/file/services/file_service.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/utils/base_exception_handler.dart';

class AvatarUploadViewModel extends AsyncNotifier<void> {
  late final FileService _fileService;

  @override
  FutureOr<void> build() {
    _fileService = FileService();
  }

  String _getFileName(File file) {
    final currentUser = ref.read(currentUserProvider);
    final fileExtension = file.path.split('.').last;
    return UploadFolder.generateProfileFileName(
        '${currentUser?.userId}.$fileExtension');
  }

  Future<AppUser?> getCurrentUser() async {
    return ref.read(currentUserProvider);
  }

  Future<void> uploadAvatar(
    BuildContext context,
    File file,
  ) async {
    try {
      state = const AsyncValue.loading();

      final fileName = _getFileName(file);
      state = await AsyncValue.guard(() async {
        final presignedUrl = await _fileService.fetchPresignedUrl(fileName);
        if (presignedUrl == null) throw Exception('Failed to get URL');

        final success = await _fileService.uploadFileToS3(presignedUrl, file);
        if (!success) throw Exception('Upload to Storage Failed');

        // TODO - UPLOADED_FILE 테이블에 업로드 파일 정보 저장 api 호출 필요
      });
    } catch (e) {
      final errMessage = '업로드에 실패했어요😢: $e';
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
      // TODO - 삭제 API 구현 후 요청
    });
  }
}

final avatarUploadProvider = AsyncNotifierProvider<AvatarUploadViewModel, void>(
  () => AvatarUploadViewModel(),
);
