class UploadFileType {
  static const profile = 'profile';
  static const thumbnail = 'thumbnail';
  static const video = 'video';
  static const story = 'story';

  static String generateProfileFileName(String fileName) {
    return '$profile/$fileName';
  }

  static String generateThumbnailFileName(String fileName) {
    return '$thumbnail/$fileName';
  }

  static String generatePostFileName(String fileName) {
    return '$video/$fileName';
  }

  static String generateStoryFileName(String fileName) {
    return '$story/$fileName';
  }
}
