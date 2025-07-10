import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/common/providers/dio_provider.dart';
import 'package:snapster_app/features/authentication/renewal/providers/token_storage_provider.dart';
import 'package:snapster_app/features/discover/repositories/search_repository.dart';
import 'package:snapster_app/features/discover/services/search_service.dart';

final searchServiceProvider = Provider<SearchService>(
  (ref) => SearchService(
    ref.read(tokenStorageServiceProvider),
    ref.read(dioServiceProvider),
  ),
);

final searchRepositoryProvider = Provider<SearchRepository>(
  (ref) => SearchRepository(ref.read(searchServiceProvider)),
);
