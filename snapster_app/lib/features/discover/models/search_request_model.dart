class SearchRequestModel {
  final String keyword;
  final int page;

  SearchRequestModel({
    required this.keyword,
    required this.page,
  });

  Map<String, dynamic> toJson() {
    return {
      'keyword': keyword,
      'page': page,
    };
  }

  SearchRequestModel.fromJson(Map<String, dynamic> json)
      : keyword = json['keyword'],
        page = json['page'];

  SearchRequestModel copyWith({
    String? keyword,
    int? page,
  }) {
    return SearchRequestModel(
      keyword: keyword ?? this.keyword,
      page: page ?? this.page,
    );
  }
}
