import 'package:flutter/cupertino.dart';
import 'package:tiktok_clone/constants/system_message_types.dart';
import 'package:tiktok_clone/generated/l10n.dart';

String getLeftTypeSystemMessage(BuildContext context, String message) {
  var msgElms = message.split(systemMessageDivider);
  if (msgElms.length < 2) return message;
  var username = msgElms[0];
  var type = msgElms[1].toString();
  return type == SystemMessageType.left.name
      ? S.of(context).userHasLeftChatroom(username)
      : message;
}

bool isLeftTypeSystemMessage(String message) {
  var msgElms = message.split(systemMessageDivider);
  if (msgElms.length < 2) return false;
  var type = msgElms[1].toString();
  return type == SystemMessageType.left.name;
}
