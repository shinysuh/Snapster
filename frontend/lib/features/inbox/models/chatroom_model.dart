import 'package:tiktok_clone/features/inbox/models/chatter_model.dart';

class ChatroomModel {
  final String chatroomId;
  final ChatterModel personA;
  final ChatterModel personB;
  int? createdAt;
  final int updatedAt;

  ChatroomModel({
    required this.chatroomId,
    required this.personA,
    required this.personB,
    this.createdAt,
    required this.updatedAt,
  });

  ChatroomModel.fromJson(Map<String, dynamic> json)
      : chatroomId = json['chatroomId'],
        personA = ChatterModel.fromJson(json['personA']),
        personB = ChatterModel.fromJson(json['personB']),
        createdAt = json['createdAt'] ?? 0,
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

  ChatroomModel copyWith({
    String? chatroomId,
    ChatterModel? personA,
    ChatterModel? personB,
    int? createdAt,
    int? updatedAt,
  }) {
    return ChatroomModel(
      chatroomId: chatroomId ?? this.chatroomId,
      personA: personA ?? this.personA,
      personB: personB ?? this.personB,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
