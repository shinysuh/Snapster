enum FileContentType {
  jpg('image/jpeg'),
  jpeg('image/jpeg'),
  png('image/png'),
  webp('image/webp'),
  gif('image/gif'),
  mp4('video/mp4'),
  avi('video/x-msvideo'),
  basic('application/octet-stream');

  final String extension;

  const FileContentType(this.extension);

  static String fromExtension(String ext) {
    return FileContentType.values
        .firstWhere((e) => e.name == ext.toLowerCase(),
            orElse: () => FileContentType.basic)
        .extension;
  }
}
