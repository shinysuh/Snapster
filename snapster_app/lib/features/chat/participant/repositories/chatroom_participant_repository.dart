import 'package:snapster_app/features/chat/participant/models/chatroom_participant_id_model.dart';
import 'package:snapster_app/features/chat/participant/models/chatroom_participant_model.dart';
import 'package:snapster_app/features/chat/participant/models/multiple_participant_request_model.dart';
import 'package:snapster_app/features/chat/participant/services/chatroom_participant_service.dart';

class ChatroomParticipantRepository {
  final ChatroomParticipantService _chatroomParticipantService;

  ChatroomParticipantRepository(this._chatroomParticipantService);

  Future<List<ChatroomParticipantModel>> getAllByChatroom(
    int chatroomId,
  ) async {
    return await _chatroomParticipantService.fetchAllByChatroom(chatroomId);
  }

  Future<bool> addParticipant(ChatroomParticipantIdModel id) async {
    return await _chatroomParticipantService.addParticipant(id);
  }

  Future<List<ChatroomParticipantModel>> addParticipants(
    MultipleParticipantsRequestModel addRequest,
  ) async {
    return await _chatroomParticipantService.addParticipants(addRequest);
  }

  Future<bool> leaveChatroom(ChatroomParticipantIdModel id) async {
    return await _chatroomParticipantService.leaveChatroom(id);
  }

  Future<bool> updateLastReadMessage(
    ChatroomParticipantModel participant,
  ) async {
    return await _chatroomParticipantService.updateLastReadMessage(participant);
  }
}
