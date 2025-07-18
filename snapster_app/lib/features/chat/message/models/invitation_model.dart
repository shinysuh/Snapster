class InvitationModel {
  final int chatroomId;
  final String type;

  InvitationModel({
    required this.chatroomId,
    required this.type,
  });

  InvitationModel.fromJson(Map<String, dynamic> json)
      : chatroomId = json['chatroomId'],
        type = json['type'];
}
