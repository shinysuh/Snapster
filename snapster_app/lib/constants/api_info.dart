import 'dart:io';

import 'package:snapster_app/features/authentication/constants/authorization.dart';

class ApiInfo {
  static const baseUrl = 'https://d3uszapt2fdgux.cloudfront.net';       // 운영
  // static const baseUrl = 'http://localhost:8080';    // 개발

  static const oauthBaseUrl = '$baseUrl/oauth2/authorization';
  static const presignedBaseUrl = '$baseUrl/api/s3/presigned-url?fileName=';

  static const authBaseUrl = '$baseUrl/api/auth';
  static const fileBaseUrl = '$baseUrl/api/file';
  static const userBaseUrl = '$baseUrl/api/user';

  static const feedBaseUrl = '$baseUrl/api/feed';
  static const userFeedBaseUrl = '$feedBaseUrl/user';

  static Map<String, String> getBasicHeaderWithToken(String? token) {
    return {
      Authorizations.headerKey: '${Authorizations.headerValuePrefix} $token',
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    };
  }
}
