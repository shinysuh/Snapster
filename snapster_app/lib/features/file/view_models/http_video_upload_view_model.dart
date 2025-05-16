import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/common/widgets/navigation/views/main_navigation_screen.dart';
import 'package:snapster_app/features/file/constants/upload_file_type.dart';
import 'package:snapster_app/features/file/models/video_post_model.dart';
import 'package:snapster_app/features/file/utils/common_upload_process_mixin.dart';
import 'package:snapster_app/utils/exception_handlers/base_exception_handler_2.dart';
import 'package:snapster_app/utils/navigator_redirection.dart';

class HttpVideoUploadViewModel extends AsyncNotifier<void>
    with CommonUploadProcessHandlerMixin {
  @override
  FutureOr<void> build() {
    initCommonUpload(ref); // mixin 초기화
  }

  Future<void> uploadVideo({
    required BuildContext context,
    required File file,
    required String title,
    required String description,
  }) async {
    await runFutureWithExceptionHandler(
        context: context,
        errMsgPrefix: '비디오 업로드 오류',
        callBackFunction: () async {
          state = const AsyncValue.loading();

          if (currentUser == null) throw Exception('로그인이 필요한 작업입니다.');

          final fileName = UploadFileType.generateVideoFilePath(file);
          state = await AsyncValue.guard(() async {
            // presigned-url 발급
            final presignedUrl = await getPresignedUrl(fileName);

            // 파일 업로드
            await uploadFile(presignedUrl, file);

            // 업로드 비디오 파일 정보 저장
            await saveVideoFileInfo(
                presignedUrl,
                VideoPostModel(
                  id: '',
                  title: title,
                  description: description,
                  tags: [],
                  videoId: '0',
                  videoUrl: presignedUrl.uploadedFileInfo.url,
                  thumbnailId: '0',
                  thumbnailUrl: '',
                  userDisplayName: currentUser?.displayName ?? 'unknown',
                  userId: presignedUrl.uploadedFileInfo.userId,
                  likes: 0,
                  comments: 0,
                  createdAt: presignedUrl.uploadedFileInfo.uploadedAt ?? '',
                ));

            if (context.mounted) {
              goRouteReplacementRoute(
                  context: context,
                  routeURL: MainNavigationScreen.homeRouteURL);
            }
          });
        });
  }
}

final httpVideoUploadProvider =
    AsyncNotifierProvider<HttpVideoUploadViewModel, void>(
  () => HttpVideoUploadViewModel(),
);
