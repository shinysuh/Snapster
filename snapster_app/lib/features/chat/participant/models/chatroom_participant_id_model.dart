class ChatroomParticipantIdModel {
  final int chatroomId;
  final int userId;

  ChatroomParticipantIdModel({
    required this.chatroomId,
    required this.userId,
  });

  ChatroomParticipantIdModel.fromJson(Map<String, dynamic> json)
      : chatroomId = json['chatroomId'],
        userId = json['userId'];

  Map<String, dynamic> toJson() {
    return {
      'chatroomId': chatroomId,
      'userId': userId,
    };
  }
}
