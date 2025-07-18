import 'package:shared_preferences/shared_preferences.dart';

class FcmTokenStorageService {
  final _fcmTokenKey = 'fcm_token';
  final _pendingChatroomIdKey = 'pending_chatroom_id';

  Future<void> saveFcmToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_fcmTokenKey, token);
  }

  Future<String?> readFcmToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_fcmTokenKey);
  }

  Future<void> deleteFcmToken() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_fcmTokenKey);
  }

  Future<void> savePendingChatroomId(int chatroomId) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_pendingChatroomIdKey, chatroomId);
  }

  Future<int?> readPendingChatroomId() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getInt(_pendingChatroomIdKey);
  }

  Future<void> deletePendingChatroomId() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_pendingChatroomIdKey);
  }
}
