import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/common/providers/dio_provider.dart';
import 'package:snapster_app/features/authentication/renewal/providers/token_storage_provider.dart';
import 'package:snapster_app/features/chat/chatroom/repositories/chatroom_repository.dart';
import 'package:snapster_app/features/chat/chatroom/services/chatroom_service.dart';
import 'package:snapster_app/features/chat/message/models/chat_message_model.dart';
import 'package:snapster_app/features/chat/message/repositories/chat_message_repository.dart';
import 'package:snapster_app/features/chat/message/services/chat_message_service.dart';
import 'package:snapster_app/features/chat/participant/repositories/chatroom_participant_repository.dart';
import 'package:snapster_app/features/chat/participant/services/chatroom_participant_service.dart';
import 'package:snapster_app/features/chat/stomp/repositories/stomp_repository.dart';
import 'package:snapster_app/features/chat/stomp/services/stomp_service.dart';

/* stomp */
final stompServiceProvider = Provider<StompService>(
  (ref) => StompService(),
);

final stompRepositoryProvider = Provider<StompRepository>(
  (ref) {
    final repository = StompRepository(ref.read(stompServiceProvider));

    ref.onDispose(() {
      repository.disconnect();
    });

    return repository;
  },
);

// 모든 채팅방 브로드캐스트 감지용 provider
final stompMessageStreamProvider = StreamProvider<ChatMessageModel>((ref) {
  return ref.watch(stompRepositoryProvider).messageStream;
});

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
final chatMessageServiceProvider = Provider<ChatMessageService>(
  (ref) => ChatMessageService(
    ref.read(tokenStorageServiceProvider),
    ref.read(dioServiceProvider),
  ),
);

final chatMessageRepositoryProvider = Provider<ChatMessageRepository>(
  (ref) => ChatMessageRepository(ref.read(chatMessageServiceProvider)),
);
