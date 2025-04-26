import 'dart:io';

import 'package:snapster_app/features/authentication/constants/authorization.dart';

class ApiInfo {
  static const baseUrl = 'http://localhost:8080'; // TODO => 운영은 80

  static Map<String, String> getBasicHeaderWithToken(String? token) {
    return {
      Authorizations.headerKey: '${Authorizations.headerValuePrefix} $token',
      HttpHeaders.contentTypeHeader: 'application/json',
    };
  }
}
