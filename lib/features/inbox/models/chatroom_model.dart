import 'package:tiktok_clone/features/inbox/models/chatter_model.dart';

class ChatroomModel {
  final String chatroomId;
  final ChatterModel personA;
  final ChatterModel personB;
  final int createdAt;

  ChatroomModel({
    required this.chatroomId,
    required this.personA,
    required this.personB,
    required this.createdAt,
  });

  ChatroomModel.fromJson(Map<String, dynamic> json)
      : chatroomId = json['chatroomId'],
        personA = json['personA'],
        personB = json['personB'],
        createdAt = json['createdAt'];

  Map<String, dynamic> toJson() {
    return {
      'chatroomId': chatroomId,
      'personA': personA.toJson(),
      'personB': personB.toJson(),
      'createdAt': createdAt,
    };
  }
}
