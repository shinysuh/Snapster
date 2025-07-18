class FileContentType {
  static const String jpeg = 'image/jpeg';
  static const String png = 'image/png';
  static const String gif = 'image/gif';
  static const String webp = 'image/webp';

  static const String mp4 = 'video/mp4';
  static const String avi = 'video/x-msvideo';

  static const String defaultType = 'application/octet-stream';

  static String fromExtension(String ext) {
    switch (ext.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return jpeg;
      case 'png':
        return png;
      case 'gif':
        return gif;
      case 'webp':
        return webp;
      case 'mp4':
      case 'mov':
        return mp4;
      case 'avi':
        return avi;
      default:
        return defaultType;
    }
  }
}
