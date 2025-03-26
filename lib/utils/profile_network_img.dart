import 'package:flutter/cupertino.dart';

NetworkImage getProfileImgByUserId(String userId, bool fetchRealTime) {
  var imageURL =
      'https://firebasestorage.googleapis.com/v0/b/tiktok-clone-jenn.appspot.com/o/avatars%2F$userId?alt=media&token=74240f15-3f4d-4f81-9cf0-577b153413c0';
  if (fetchRealTime) imageURL += '&haha=${DateTime.now().toString()}';
  return NetworkImage(imageURL);
}
