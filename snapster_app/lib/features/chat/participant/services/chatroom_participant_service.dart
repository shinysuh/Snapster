import 'package:snapster_app/common/services/dio_service.dart';
import 'package:snapster_app/constants/api_info.dart';
import 'package:snapster_app/features/authentication/services/token_storage_service.dart';
import 'package:snapster_app/features/chat/participant/models/chatroom_participant_id_model.dart';
import 'package:snapster_app/features/chat/participant/models/chatroom_participant_model.dart';
import 'package:snapster_app/features/chat/participant/models/multiple_participant_request_model.dart';
import 'package:snapster_app/utils/api_safe_wrapper.dart';

class ChatroomParticipantService {
  static const _baseUrl = ApiInfo.chatParticipantBaseUrl;

  final TokenStorageService _tokenStorageService;
  final DioService _dioService;

  ChatroomParticipantService(this._tokenStorageService, this._dioService);

  Future<List<ChatroomParticipantModel>> fetchAllByChatroom(
    int chatroomId,
  ) async {
    final token = await _tokenStorageService.readToken();

    final response = await _dioService.get(
      uri: '$_baseUrl/$chatroomId',
      headers: ApiInfo.getBasicHeaderWithToken(token),
    );

    return handleListResponse<ChatroomParticipantModel>(
      response: response,
      fromJson: (data) => ChatroomParticipantModel.fromJson(data),
      errorPrefix: '채팅방 참여자 목록 조회',
    );
  }

  Future<bool> addParticipant(
    ChatroomParticipantIdModel id,
  ) async {
    final token = await _tokenStorageService.readToken();

    final response = await _dioService.post(
      uri: '$_baseUrl/one',
      headers: ApiInfo.getBasicHeaderWithToken(token),
      body: id,
    );

    ChatroomParticipantModel? newParticipant =
        handleSingleResponse<ChatroomParticipantModel>(
      response: response,
      fromJson: (data) => ChatroomParticipantModel.fromJson(data),
      errorPrefix: '사용자 초대',
    );

    return newParticipant != null;
  }

  Future<List<ChatroomParticipantModel>> addParticipants(
    MultipleParticipantsRequestModel addRequest,
  ) async {
    final token = await _tokenStorageService.readToken();

    final response = await _dioService.post(
      uri: '$_baseUrl//add/${addRequest.chatroomId}',
      headers: ApiInfo.getBasicHeaderWithToken(token),
      body: addRequest,
    );

    return handleListResponse<ChatroomParticipantModel>(
      response: response,
      fromJson: (data) => ChatroomParticipantModel.fromJson(data),
      errorPrefix: '사용자 초대',
    );
  }

  Future<bool> leaveChatroom(ChatroomParticipantIdModel id) async {
    final token = await _tokenStorageService.readToken();

    final response = await _dioService.post(
      uri: '$_baseUrl/leave',
      headers: ApiInfo.getBasicHeaderWithToken(token),
      body: id,
    );

    return handleVoidResponse(
      response: response,
      errorPrefix: '채팅방 나가기',
    );
  }

  Future<bool> updateLastReadMessage(
    ChatroomParticipantModel participant,
  ) async {
    final token = await _tokenStorageService.readToken();

    final response = await _dioService.put(
      uri: '$_baseUrl/read',
      headers: ApiInfo.getBasicHeaderWithToken(token),
      body: participant,
    );

    return handleVoidResponse(
      response: response,
      errorPrefix: '메시지 읽음 처리',
    );
  }
}
