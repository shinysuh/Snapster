class UploadFolder {
  static const profile = 'profiles';
  static const thumbnail = 'thumbnails';
  static const post = 'posts';
  static const story = 'stories';

  static String generateProfileFileName(String fileName) {
    return '$profile/$fileName';
  }

  static String generateThumbnailFileName(String fileName) {
    return '$thumbnail/$fileName';
  }

  static String generatePostFileName(String fileName) {
    return '$post/$fileName';
  }

  static String generateStoryFileName(String fileName) {
    return '$story/$fileName';
  }
}
