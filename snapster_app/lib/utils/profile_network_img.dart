import 'package:flutter/cupertino.dart';

NetworkImage getProfileImgByUserId(String userId, bool fetchRealTime) {
  /* NetworkImage - 한번 fetch 후 이미지를 캐싱한다
            -> 프로필 있는 상태에서 사진 업로드하면 이전 사진 뜨는 issue
              >>> fix: URL 마지막에 DateTime.now() 를 추가해 새로운 URL 로 인식하게 함
     */
  var imageURL =
      'https://firebasestorage.googleapis.com/v0/b/tiktok-clone-jenn.appspot.com/o/avatars%2F$userId?alt=media&token=74240f15-3f4d-4f81-9cf0-577b153413c0';
  if (fetchRealTime) imageURL += '&haha=${DateTime.now().toString()}';
  return NetworkImage(imageURL);
}

NetworkImage getProfileImgByUserProfileImageUrl(
    String profileImageUrl, bool fetchRealTime) {
  if (fetchRealTime) {
    final separator = profileImageUrl.contains('?') ? '&' : '?';
    profileImageUrl += '${separator}cacheBuster=${DateTime.now().millisecondsSinceEpoch}';
  }
  return NetworkImage(profileImageUrl);
}
