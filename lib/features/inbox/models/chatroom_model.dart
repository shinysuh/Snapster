import 'package:tiktok_clone/features/inbox/models/chatter_model.dart';

class ChatroomModel {
  final String chatroomId;
  final ChatterModel personA;
  final ChatterModel personB;
  final int createdAt;
  final int updatedAt;

  ChatroomModel({
    required this.chatroomId,
    required this.personA,
    required this.personB,
    required this.createdAt,
    required this.updatedAt,
  });

  ChatroomModel.fromJson(Map<String, dynamic> json)
      : chatroomId = json['chatroomId'],
        personA = ChatterModel.fromJson(json['personA']),
        personB = ChatterModel.fromJson(json['personB']),
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'];

  Map<String, dynamic> toJson() {
    return {
      'chatroomId': chatroomId,
      'personA': personA.toJson(),
      'personB': personB.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
