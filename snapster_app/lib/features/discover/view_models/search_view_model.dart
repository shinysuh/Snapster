import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/discover/models/search_request_model.dart';
import 'package:snapster_app/features/discover/providers/search_providers.dart';
import 'package:snapster_app/features/discover/repositories/search_repository.dart';
import 'package:snapster_app/features/video/models/video_post_model.dart';
import 'package:snapster_app/utils/exception_handlers/base_exception_handler.dart';

class SearchViewModel extends AsyncNotifier<List<VideoPostModel>> {
  late final SearchRepository _searchRepository;
  Timer? _debounce;

  String _currentKeyword = "";
  bool _hasMore = true;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool get hasMore => _hasMore;

  @override
  FutureOr<List<VideoPostModel>> build() async {
    _searchRepository = ref.read(searchRepositoryProvider);
    return await _searchByKeywordPrefixWithPaging(_currentKeyword, 0);
  }

  void searchWithDebounce(
    String keyword,
    int page, [
    Duration delay = const Duration(milliseconds: 300),
  ]) {
    _currentKeyword = keyword;
    _debounce?.cancel();
    _debounce = Timer(delay, () => onSearchKeywordChange(keyword, page));
  }

  Future<void> onSearchKeywordChange(String keyword, int page) async {
    if (_currentKeyword != keyword) {
      _hasMore = true;
      _currentKeyword = keyword;
    }

    if (_isLoading || !_hasMore) return;
    _isLoading = true;

    if (page == 0) {
      state = const AsyncValue.loading();
    }

    final previous = state.value ?? [];

    state = await AsyncValue.guard(() async {
      final newResults = await _searchByKeywordPrefixWithPaging(keyword, page);
      _hasMore = newResults.isNotEmpty;

      debugPrint("📦 page $page / 추가된 결과 ${newResults.length} / 총 길이: ${[
        ...previous,
        ...newResults
      ].length}");

      // 페이지 0이면 초기화, 그 외엔 검색 결과 누적
      return page == 0 ? newResults : [...previous, ...newResults];
    });
    _isLoading = false;
  }

  Future<List<VideoPostModel>> _searchByKeywordPrefixWithPaging(
    String keyword,
    int page,
  ) async {
    final searchRequest = SearchRequestModel(
      keyword: keyword,
      page: page,
    );

    return await runFutureWithExceptionLogs<List<VideoPostModel>>(
      errorPrefix: '[$keyword] 검색 결과 조회',
      requestFunction: () async =>
          _searchRepository.searchByKeywordPrefixWithPaging(searchRequest),
      fallback: [],
    );
  }
}

final searchProvider =
    AsyncNotifierProvider<SearchViewModel, List<VideoPostModel>>(
  () => SearchViewModel(),
);
