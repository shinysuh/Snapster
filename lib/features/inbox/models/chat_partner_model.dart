import 'package:tiktok_clone/features/inbox/models/chatter_model.dart';

class ChatPartnerModel {
  final String chatroomId;
  final ChatterModel chatPartner;
  final int updatedAt;

  ChatPartnerModel({
    required this.chatroomId,
    required this.chatPartner,
    required this.updatedAt,
  });

  ChatPartnerModel.fromJson(Map<String, dynamic> json)
      : chatroomId = json['chatroomId'],
        chatPartner = ChatterModel.fromJson(json['chatPartner']),
        updatedAt = json['updatedAt'];
}
