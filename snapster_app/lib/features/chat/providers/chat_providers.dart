import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/common/providers/dio_provider.dart';
import 'package:snapster_app/features/authentication/providers/token_storage_provider.dart';
import 'package:snapster_app/features/chat/chatroom/repositories/chatroom_repository.dart';
import 'package:snapster_app/features/chat/chatroom/services/chatroom_service.dart';
import 'package:snapster_app/features/chat/message/services/chat_service.dart';
import 'package:snapster_app/features/chat/participant/repositories/chatroom_participant_repository.dart';
import 'package:snapster_app/features/chat/participant/services/chatroom_participant_service.dart';

/* chatroom */
final chatroomServiceProvider = Provider<ChatroomService>(
  (ref) => ChatroomService(
    ref.read(tokenStorageServiceProvider),
    ref.read(dioServiceProvider),
  ),
);

final chatroomRepositoryProvider = Provider<ChatroomRepository>(
  (ref) => ChatroomRepository(ref.read(chatroomServiceProvider)),
);

/* participant */
final chatroomParticipantServiceProvider = Provider<ChatroomParticipantService>(
  (ref) => ChatroomParticipantService(
    ref.read(tokenStorageServiceProvider),
    ref.read(dioServiceProvider),
  ),
);

final chatroomParticipantRepositoryProvider =
    Provider<ChatroomParticipantRepository>(
  (ref) => ChatroomParticipantRepository(
      ref.read(chatroomParticipantServiceProvider)),
);

/* message */
final chatMessageServiceProvider = Provider<ChatService>(
  (ref) => ChatService(),
);
