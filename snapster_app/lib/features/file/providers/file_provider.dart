import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/common/providers/dio_provider.dart';
import 'package:snapster_app/features/authentication/renewal/providers/token_storage_provider.dart';
import 'package:snapster_app/features/file/repositories/file_repository.dart';
import 'package:snapster_app/features/file/services/file_service.dart';

final fileServiceProvider = Provider<FileService>((ref) {
  return FileService(
    ref.read(tokenStorageServiceProvider),
    ref.read(dioServiceProvider),
  );
});

final fileRepositoryProvider = Provider<FileRepository>((ref) {
  final fileService = ref.read(fileServiceProvider);
  return FileRepository(fileService);
});
