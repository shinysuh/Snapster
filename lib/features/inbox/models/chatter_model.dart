class ChatterModel {
  final String uid;
  final String name;
  final String username;
  final bool hasAvatar;

  // 방을 나가기 여부(둘 다 나가기면 채팅방 삭제 && 한명만 나가면 해당 유저 isParticipating=false
  // true일 경우, 유저 나갔다는 문구 표시 (userId: system 으로 저장 후, system 문구는 다르게 표시)
  // 다시 초대될 경우 OR 남아있던 대화자가 새로운 메세지를 보낼 경우, 나갔던 유저 isParticipating=true
  final bool isParticipating;

  // 최근에 읽은 메세지
  // - [여기까지 읽음] 기능
  // 위 기능 동작 후, 값 업데이트
  final int recentlyReadAt;

  // 열람 가능한 메세지 시간 (방 나가기 이후 새로 생긴 메세지 epoch)
  // (방 나가기 시, showMsgFrom = 가장 최근메세지 createdAt +1)
  final int showMsgFrom;

  ChatterModel({
    required this.uid,
    required this.name,
    required this.username,
    required this.hasAvatar,
    required this.recentlyReadAt,
    required this.showMsgFrom,
    required this.isParticipating,
  });

  ChatterModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        name = json['name'],
        username = json['username'],
        hasAvatar = json['hasAvatar'],
        isParticipating = json['isParticipating'],
        recentlyReadAt = json['recentlyReadAt'],
        showMsgFrom = json['showMsgFrom'];

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'hasAvatar': hasAvatar,
      'isParticipating': isParticipating,
      'recentlyReadAt': recentlyReadAt,
      'showMsgFrom': showMsgFrom,
    };
  }
}
