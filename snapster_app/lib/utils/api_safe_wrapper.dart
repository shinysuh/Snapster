import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

bool handleVoidResponse({
  required Response response,
  required String errorPrefix,
}) {
  bool result = response.statusCode == HttpStatus.ok;
  if (!result) {
    debugPrint('$errorPrefix 실패: ${response.statusCode} ${response.data}');
  }
  return result;
}

T? handleSingleResponse<T>({
  required Response response,
  required T Function(dynamic json) fromJson,
  required String errorPrefix,
}) {
  if (response.statusCode == HttpStatus.ok) {
    return fromJson(response.data);
  } else {
    debugPrint('$errorPrefix 실패: ${response.statusCode} ${response.data}');
    return null;
  }
}

List<T> handleListResponse<T>({
  required Response response,
  required T Function(dynamic json) fromJson,
  required String errorPrefix,
}) {
  if (response.statusCode == HttpStatus.ok) {
    final data = response.data;
    if (data is List) {
      return data.map((e) => fromJson(e)).toList();
    } else {
      debugPrint('$errorPrefix 실패: 예상한 List 타입이 아님. data = $data');
      return [];
    }
  } else {
    debugPrint('$errorPrefix 실패: ${response.statusCode} ${response.data}');
    return [];
  }
}
