import 'package:snapster_app/common/services/dio_service.dart';
import 'package:snapster_app/constants/api_info.dart';
import 'package:snapster_app/features/authentication/renewal/services/token_storage_service.dart';
import 'package:snapster_app/features/chat/chatroom/models/chatroom_model.dart';
import 'package:snapster_app/utils/api_safe_wrapper.dart';

class ChatroomService {
  static const _baseUrl = ApiInfo.chatroomBaseUrl;

  final TokenStorageService _tokenStorageService;
  final DioService _dioService;

  ChatroomService(this._tokenStorageService, this._dioService);

  Future<List<ChatroomModel>> fetchAllChatroomsByUser() async {
    final token = await _tokenStorageService.readToken();

    final response = await _dioService.get(
      uri: _baseUrl,
      headers: ApiInfo.getBasicHeaderWithToken(token),
    );

    return handleListResponse<ChatroomModel>(
      response: response,
      fromJson: (data) => ChatroomModel.fromJson(data),
      errorPrefix: '채팅방 목록 조회',
    );
  }

  Future<ChatroomModel> fetchOneChatroom(int chatroomId) async {
    final token = await _tokenStorageService.readToken();

    final response = await _dioService.get(
      uri: '$_baseUrl/one/$chatroomId',
      headers: ApiInfo.getBasicHeaderWithToken(token),
    );

    ChatroomModel? chatroom = handleSingleResponse<ChatroomModel>(
      response: response,
      fromJson: (data) => ChatroomModel.fromJson(data),
      errorPrefix: '채팅방 조회',
    );

    return chatroom ?? ChatroomModel.empty();
  }

  Future<ChatroomModel> fetchIfOneOnOneChatroomExists(int receiverId) async {
    final token = await _tokenStorageService.readToken();

    final response = await _dioService.get(
      uri: '$_baseUrl/check/$receiverId',
      headers: ApiInfo.getBasicHeaderWithToken(token),
    );

    ChatroomModel? chatroom = handleSingleResponse<ChatroomModel>(
      response: response,
      fromJson: (data) => ChatroomModel.fromJson(data),
      errorPrefix: '1:1 채팅방 조회',
    );

    return chatroom ?? ChatroomModel.empty();
  }

  Future<bool> leaveChatroom(int chatroomId) async {
    final token = await _tokenStorageService.readToken();

    final response = await _dioService.post(
      uri: '$_baseUrl/leave/chatroomId',
      headers: ApiInfo.getBasicHeaderWithToken(token),
    );

    return handleVoidResponse(
      response: response,
      errorPrefix: '채팅방 나가기',
    );
  }
}
