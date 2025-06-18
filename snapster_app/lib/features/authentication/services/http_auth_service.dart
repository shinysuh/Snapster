import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:snapster_app/constants/api_info.dart';
import 'package:snapster_app/features/authentication/services/i_auth_service.dart';
import 'package:snapster_app/features/chat/notification/models/fcm_token_model.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/utils/text_util.dart';

class HttpAuthService implements IAuthService {
  static const _baseUrl = ApiInfo.authBaseUrl;
  final _basicHeaders = {'Content-Type': 'application/json'};

  final http.Client _client;

  HttpAuthService({http.Client? client}) : _client = client ?? http.Client();

  @override
  AppUser? get currentUser => throw UnimplementedError();

  @override
  bool get isLoggedIn => throw UnimplementedError();

  @override
  Future<String> signUp(String email, String password) async {
    final res = await _client.post(
      Uri.parse('$_baseUrl/signup'),
      headers: _basicHeaders,
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body)['token'] as String;
    }
    throw Exception('SignUp failed: ${res.body}');
  }

  @override
  Future<void> signIn(String email, String password) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<void> signOut(BuildContext context) {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Stream<AppUser?> authStateChanges() {
    // 토큰 삭제만 해도 충분하면 빈 구현
    throw UnimplementedError();
  }

  @override
  Future<void> checkLoginUser(BuildContext context) {
    // TODO: implement checkLoginUser
    throw UnimplementedError();
  }

  @override
  Future<AppUser> getUserFromToken(String token) async {
    final res = await _client.get(
      Uri.parse('$_baseUrl/me'),
      headers: ApiInfo.getBasicHeaderWithToken(token),
    );
    if (res.statusCode == 200) {
      return AppUser.fromJson(
        jsonDecode(
          getUtfDecodedBody(res.bodyBytes),
        ),
      );
    } else {
      throw Exception('Fetch user failed: ${res.body}');
    }
  }

  @override
  Future<void> registerFcmToken(String accessToken, String fcmToken) async {
    final res = await _client.post(
      Uri.parse('${ApiInfo.notificationBaseUrl}/fcm/save'),
      headers: ApiInfo.getBasicHeaderWithToken(accessToken),
      body: jsonEncode(FcmTokenModel(userId: '', fcmToken: fcmToken)),
    );
    if (res.statusCode != 200) {
      throw Exception('FCM token registration failed: ${res.body}');
    }
  }

  @override
  Future<void> updateFcmToken({
    required String accessToken,
    required String oldFcmToken,
    required String newFcmToken,
  }) async {
    final res = await _client.post(
      Uri.parse('${ApiInfo.notificationBaseUrl}/fcm/refresh'),
      headers: ApiInfo.getBasicHeaderWithToken(accessToken),
      body: jsonEncode(
        FcmTokenModel(
          userId: '',
          fcmToken: newFcmToken,
          oldToken: oldFcmToken,
        ),
      ),
    );
    if (res.statusCode != 200) {
      throw Exception('FCM token update failed: ${res.body}');
    }
  }

  @override
  Future<void> deleteFcmToken({
    required String accessToken,
    required FcmTokenModel fcm,
  }) async {
    final res = await _client.post(
      Uri.parse('${ApiInfo.notificationBaseUrl}/fcm/delete'),
      headers: ApiInfo.getBasicHeaderWithToken(accessToken),
      body: jsonEncode(fcm),
    );
    if (res.statusCode != 200) {
      throw Exception('FCM token removal failed: ${res.body}');
    }
  }
}
