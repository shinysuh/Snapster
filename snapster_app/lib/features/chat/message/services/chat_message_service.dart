import 'package:snapster_app/common/services/dio_service.dart';
import 'package:snapster_app/constants/api_info.dart';
import 'package:snapster_app/features/authentication/renewal/services/token_storage_service.dart';
import 'package:snapster_app/features/chat/chatroom/models/chatroom_model.dart';
import 'package:snapster_app/features/chat/message/models/chat_message_model.dart';
import 'package:snapster_app/utils/api_safe_wrapper.dart';

class ChatMessageService {
  static const _baseUrl = ApiInfo.chatMessageBaseUrl;

  final TokenStorageService _tokenStorageService;
  final DioService _dioService;

  ChatMessageService(this._tokenStorageService, this._dioService);

  Future<List<ChatMessageModel>> fetchAllMessagesByChatroom(
    int chatroomId,
  ) async {
    final token = await _tokenStorageService.readToken();

    final response = await _dioService.get(
      uri: '$_baseUrl/$chatroomId',
      headers: ApiInfo.getBasicHeaderWithToken(token),
    );

    return handleListResponse<ChatMessageModel>(
      response: response,
      fromJson: (data) => ChatMessageModel.fromJson(data),
      errorPrefix: '채팅방 메시지 전체 조회',
    );
  }

  Future<ChatMessageModel> fetchRecentMessageByChatroom(
    ChatroomModel chatroom,
  ) async {
    final token = await _tokenStorageService.readToken();

    final response = await _dioService.post(
      uri: '$_baseUrl/recent/${chatroom.id}',
      headers: ApiInfo.getBasicHeaderWithToken(token),
      body: chatroom,
    );

    ChatMessageModel? recentMessage = handleSingleResponse<ChatMessageModel>(
      response: response,
      fromJson: (data) => ChatMessageModel.fromJson(data),
      errorPrefix: '채팅방 최근 메시지 조회',
    );

    return recentMessage ?? ChatMessageModel.empty();
  }

  Future<ChatMessageModel> updateMessageToDeleted(
    ChatMessageModel message,
  ) async {
    final token = await _tokenStorageService.readToken();

    final response = await _dioService.put(
      uri: '$_baseUrl/delete',
      headers: ApiInfo.getBasicHeaderWithToken(token),
      body: message,
    );

    ChatMessageModel? deletedMessage = handleSingleResponse<ChatMessageModel>(
      response: response,
      fromJson: (data) => ChatMessageModel.fromJson(data),
      errorPrefix: '메시지 삭제 처리',
    );

    return deletedMessage ?? ChatMessageModel.empty();
  }
}
