import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:snapster_app/constants/api_info.dart';

class DioService {
  late Dio _dio;

  DioService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiInfo.baseUrl,
        headers: {'Accept': 'application/json'},
      ),
    );
  }

  Future<Response> get({
    required String uri,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    return await _dio.get(
      uri,
      options: Options(headers: headers),
      queryParameters: queryParams,
    );
  }

  Future<Response> post({
    required String uri,
    Map<String, dynamic>? headers,
    Object? body,
  }) async {
    return await _dio.post(
      uri,
      options: Options(headers: headers),
      data: jsonEncode(body),
    );
  }

  Future<Response> put({
    required String uri,
    Map<String, dynamic>? headers,
    Object? body,
  }) async {
    return await _dio.put(
      uri,
      options: Options(headers: headers),
      data: jsonEncode(body),
    );
  }

  Future<Response> delete({
    required String uri,
    Map<String, dynamic>? headers,
    Object? body,
  }) async {
    return await _dio.delete(
      uri,
      options: Options(headers: headers),
      data: jsonEncode(body),
    );
  }

  Future<Response> filePut({
    required String uri,
    Map<String, dynamic>? headers,
    Object? body,
  }) async {
    return await _dio.put(
      uri,
      options: Options(headers: headers),
      data: body,
    );
  }
}
