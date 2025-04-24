import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snapster_app/constants/authorization.dart';

class TokenStorageService {
  final _tokenKey = Authorizations.authTokenKey;

  final FlutterSecureStorage _storage;

  TokenStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  // 토큰 읽기
  Future<String?> readToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // 토큰 저장
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // 토큰 삭제
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
