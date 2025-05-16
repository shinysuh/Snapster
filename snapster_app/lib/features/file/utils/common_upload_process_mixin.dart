import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/authentication/providers/auth_status_provider.dart';
import 'package:snapster_app/features/file/constants/upload_file_type.dart';
import 'package:snapster_app/features/file/models/presigned_url_model.dart';
import 'package:snapster_app/features/file/models/video_post_model.dart';
import 'package:snapster_app/features/file/providers/file_provider.dart';
import 'package:snapster_app/features/file/repositories/file_repository.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';

mixin CommonUploadProcessHandlerMixin on AsyncNotifier<void> {
  late final FileRepository fileRepository;
  late final AppUser? currentUser;

  void initCommonUpload(ref) {
    fileRepository = ref.read(fileRepositoryProvider);
    currentUser = ref.watch(authStateProvider).user;
  }

  Future<PresignedUrlModel> getPresignedUrl(String fileName) async {
    final presignedUrl = await fileRepository.getPresignedUrl(fileName);
    if (presignedUrl == null) throw Exception('Failed to get URL');
    return presignedUrl;
  }

  Future<void> uploadFile(PresignedUrlModel presignedUrl, File file) async {
    final success =
        await fileRepository.uploadFile(presignedUrl.presignedUrl, file);
    if (!success) throw Exception('Upload to S3 Storage Failed');
  }

  Future<void> saveUploadedFileInfo(
    PresignedUrlModel presignedUrl,
    String uploadType,
  ) async {
    final saveSuccess = await fileRepository.saveUploadedFileInfo(
      presignedUrl.uploadedFileInfo.copyWith(
        type: uploadType,
      ),
    );
    if (!saveSuccess) {
      throw Exception('Couldn\'t save uploaded file info');
    }
  }

  Future<void> saveVideoFileInfo(
    PresignedUrlModel presignedUrl,
    VideoPostModel videoInfo,
  ) async {
    final saveSuccess = await fileRepository.saveVideoFileInfo(
      videoInfo: videoInfo,
      uploadedFileInfo: presignedUrl.uploadedFileInfo.copyWith(
        type: UploadFileType.video,
      ),
    );
    if (!saveSuccess) {
      throw Exception('Couldn\'t save video file info');
    }
  }
}
