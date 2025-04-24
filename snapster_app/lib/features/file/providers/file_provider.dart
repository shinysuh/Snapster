import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/authentication/services/token_storage_service.dart';
import 'package:snapster_app/features/file/repositories/file_repository.dart';
import 'package:snapster_app/features/file/services/file_service.dart';

final fileServiceProvider = Provider<FileService>((ref) {
  return FileService(tokenStorageService: TokenStorageService());
});

final fileRepositoryProvider = Provider<FileRepository>((ref) {
  final fileService = ref.read(fileServiceProvider);
  return FileRepository(fileService);
});
