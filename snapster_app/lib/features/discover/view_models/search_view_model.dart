import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/discover/providers/search_providers.dart';
import 'package:snapster_app/features/discover/repositories/search_repository.dart';
import 'package:snapster_app/features/video/models/video_post_model.dart';
import 'package:snapster_app/utils/exception_handlers/base_exception_handler.dart';

class SearchViewModel extends AsyncNotifier<List<VideoPostModel>> {
  late final SearchRepository _searchRepository;
  Timer? _debounce;

  @override
  FutureOr<List<VideoPostModel>> build() async {
    _searchRepository = ref.read(searchRepositoryProvider);
    return await _searchByKeywordPrefix("");
  }

  void searchWithDebounce(String keyword,
      [Duration delay = const Duration(milliseconds: 300)]) {
    _debounce?.cancel();
    _debounce = Timer(delay, () => onSearchKeywordChange(keyword));
  }

  Future<void> onSearchKeywordChange(String keyword) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        return await _searchByKeywordPrefix(keyword);
      },
    );
  }

  Future<List<VideoPostModel>> _searchByKeywordPrefix(String keyword) async {
    return await runFutureWithExceptionLogs<List<VideoPostModel>>(
      errorPrefix: '[$keyword] 검색 결과 조회',
      requestFunction: () async =>
          _searchRepository.searchByKeywordPrefix(keyword),
      fallback: [],
    );
  }
}

final searchProvider =
    AsyncNotifierProvider<SearchViewModel, List<VideoPostModel>>(
  () => SearchViewModel(),
);
