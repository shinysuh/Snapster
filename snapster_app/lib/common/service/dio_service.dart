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

  Dio get dio => _dio;
}
