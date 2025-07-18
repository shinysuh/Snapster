class MultipleParticipantsRequestModel {
  final int chatroomId;
  final List<int> userIds;

  MultipleParticipantsRequestModel({
    required this.chatroomId,
    required this.userIds,
  });

  factory MultipleParticipantsRequestModel.fromJson(Map<String, dynamic> json) {
    return MultipleParticipantsRequestModel(
      chatroomId: json['chatroomId'] as int,
      userIds: (json['userIds'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatroomId': chatroomId,
      'userIds': userIds,
    };
  }
}
