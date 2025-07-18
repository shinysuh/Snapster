import 'dart:io';

import 'package:snapster_app/features/authentication/renewal/constants/authorization.dart';

class ApiInfo {
  // static const baseUrl = 'https://d3uszapt2fdgux.cloudfront.net';      // 운영
  static const baseUrl = 'http://localhost:8080'; // 개발
  // static const baseUrl = 'http://10.0.2.2:8080'; // 개발 - 안드로이드
  // static const baseUrl = 'https://76c7c886d179.ngrok-free.app'; // ngrok 테스트 (fcm)

  static const oauthBaseUrl = '$baseUrl/oauth2/authorization';
  static const presignedBaseUrl = '$baseUrl/api/s3/presigned-url?fileName=';

  static const authBaseUrl = '$baseUrl/api/auth';
  static const fileBaseUrl = '$baseUrl/api/file';
  static const userBaseUrl = '$baseUrl/api/user';

  static const feedBaseUrl = '$baseUrl/api/feed';
  static const userFeedBaseUrl = '$feedBaseUrl/user';

  static const chatroomBaseUrl = '$baseUrl/api/chat/chatroom';
  static const chatParticipantBaseUrl = '$baseUrl/api/chat/participant';
  static const chatMessageBaseUrl = '$baseUrl/api/chat/message';

  static const webSocketUrl = '$baseUrl/websocket';
  static const stompBaseUrl = '/app/chat/send';

  static const notificationBaseUrl = '$baseUrl/api/notification';

  static const searchBaseUrl = '$baseUrl/api/search';

  static Map<String, String> getBasicHeaderWithToken(String? token) {
    return {
      Authorizations.headerKey: '${Authorizations.headerValuePrefix} $token',
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    };
  }
}
