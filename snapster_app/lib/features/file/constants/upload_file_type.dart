import 'dart:io';

class UploadFileType {
  static const profile = 'profile';
  static const thumbnail = 'thumbnail';
  static const video = 'video';
  static const story = 'story';

  static String generateProfileFilePath(File file) {
    return '$profile/${getOriginalFileName(file)}';
  }

  static String generateThumbnailFilePath(File file) {
    return '$thumbnail/${getOriginalFileName(file)}';
  }

  static String generateVideoFilePath(File file) {
    return '$video/${getOriginalFileName(file)}';
  }

  static String generateStoryFilePath(File file) {
    return '$story/${getOriginalFileName(file)}';
  }

  static String getOriginalFileName(File file) {
    return file.uri.pathSegments.last;
  }
}
