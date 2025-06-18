import 'package:shared_preferences/shared_preferences.dart';

class FcmTokenStorageService {
  final _key = 'fcm_token';

  Future<void> saveFcmToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_key, token);
  }

  Future<String?> readFcmToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_key);
  }

  Future<void> deleteFcmToken() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_key);
  }
}
