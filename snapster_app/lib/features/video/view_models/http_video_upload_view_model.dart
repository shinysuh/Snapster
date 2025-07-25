import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/common/widgets/navigation/views/main_navigation_screen.dart';
import 'package:snapster_app/features/feed/view_models/feed_view_model.dart';
import 'package:snapster_app/features/file/constants/upload_file_type.dart';
import 'package:snapster_app/features/file/utils/common_upload_process_mixin.dart';
import 'package:snapster_app/features/video/models/video_post_model.dart';
import 'package:snapster_app/utils/exception_handlers/base_exception_handler.dart';
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
    await runFutureVoidWithExceptionHandler(
        context: context,
        errorPrefix: '비디오 업로드',
        requestFunction: () async {
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
                  streamingId: '0',
                  streamingUrl: '',
                  userId: presignedUrl.uploadedFileInfo.userId,
                  userDisplayName: currentUser?.displayName ?? 'unknown',
                  userProfileImageUrl: currentUser?.profileImageUrl ?? '',
                  likes: 0,
                  comments: 0,
                  createdAt: presignedUrl.uploadedFileInfo.uploadedAt ?? '',
                ));

            // user feed 갱신 => 백엔드에서 streaming file 저장 후 리프레시 되게 15초 딜레이
            Future.delayed(const Duration(seconds: 15), () {
              ref.read(feedProvider(currentUser!.userId).notifier).refresh();
            });

            if (context.mounted) {
              goToRouteWithoutStack(
                context: context,
                location: MainNavigationScreen.homeRouteURL,
              );
            }
          });
        });
  }
}

final httpVideoUploadProvider =
    AsyncNotifierProvider<HttpVideoUploadViewModel, void>(
  () => HttpVideoUploadViewModel(),
);
