import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/chat/participant/models/chatroom_participant_id_model.dart';
import 'package:snapster_app/features/chat/participant/models/chatroom_participant_model.dart';
import 'package:snapster_app/features/chat/participant/models/multiple_participant_request_model.dart';
import 'package:snapster_app/features/chat/participant/repositories/chatroom_participant_repository.dart';
import 'package:snapster_app/features/chat/providers/chat_providers.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/utils/exception_handlers/base_exception_handler.dart';

class ChatroomParticipantViewModel
    extends FamilyAsyncNotifier<List<ChatroomParticipantModel>, int> {
  late final ChatroomParticipantRepository _participantRepository;
  late final int _chatroomId;

  @override
  FutureOr<List<ChatroomParticipantModel>> build(int arg) async {
    _participantRepository = ref.read(chatroomParticipantRepositoryProvider);
    _chatroomId = arg;
    final data = await getParticipants(_chatroomId);
    return data;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final newData = await getParticipants(_chatroomId);
      state = AsyncValue.data(newData);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<List<ChatroomParticipantModel>> getParticipants(int chatroomId) async {
    return await runFutureWithExceptionLogs<List<ChatroomParticipantModel>>(
      errorPrefix: '채팅방 참여자 목록 조회',
      requestFunction: () async =>
          _participantRepository.getAllByChatroom(chatroomId),
      fallback: [],
    );
  }

  Future<void> addParticipant({
    required BuildContext context,
    required AppUser target,
  }) async {
    if (state is AsyncData<List<ChatroomParticipantModel>>) {
      final userId = int.parse(target.userId);

      final currentList = _getCurrentParticipants();
      final exists =
          currentList.map((p) => p.id.userId).toSet().contains(userId);
      if (exists) return; // 이미 참여 중이면 return

      final targetId = ChatroomParticipantIdModel(
        chatroomId: _chatroomId,
        userId: userId,
      );

      final success = await runFutureWithExceptionHandler<bool>(
        context: context,
        errorPrefix: '사용자 초대',
        requestFunction: () async =>
            _participantRepository.addParticipant(targetId),
        fallback: false,
      );

      // 초대된 참여자 수동 추가
      if (success) {
        final newbie = ChatroomParticipantModel(id: targetId, user: target);
        state = AsyncValue.data([...currentList, newbie]);
      }
    }
  }

  Future<void> addParticipants({
    required BuildContext context,
    required List<int> userIds,
  }) async {
    final targets = MultipleParticipantsRequestModel(
      chatroomId: _chatroomId,
      userIds: userIds,
    );

    final newParticipants =
        await runFutureWithExceptionHandler<List<ChatroomParticipantModel>>(
      context: context,
      errorPrefix: '사용자 초대',
      requestFunction: () async =>
          _participantRepository.addParticipants(targets),
      fallback: [],
    );

    if (newParticipants.isNotEmpty &&
        state is AsyncData<List<ChatroomParticipantModel>>) {
      final currentList = _getCurrentParticipants();

      // 새 참여자 중 중복되지 않은 사용자만 필터링
      final filteredNewbies = _getFilteredNewbies(currentList, newParticipants);

      if (filteredNewbies.isNotEmpty) {
        final updatedList = [...currentList, ...filteredNewbies];
        state = AsyncValue.data(updatedList);
      }
    }
  }

  List<ChatroomParticipantModel> _getCurrentParticipants() {
    final currentList =
        (state as AsyncData<List<ChatroomParticipantModel>>).value;

    // 더 안전한 fallback 처리 로직
    // final currentList = switch (state) {
    //   AsyncData(:final value) => value,
    //   _ => [],
    // };
    return currentList;
  }

  List<ChatroomParticipantModel> _getFilteredNewbies(
    List<ChatroomParticipantModel> currentList,
    List<ChatroomParticipantModel> newParticipants,
  ) {
    // 기존 userId 목록
    final currentUserIds = currentList.map((p) => p.id.userId).toSet();
    // 기존 리스트에서 중복되지 않는 새 참여자들
    final filteredNewbies = newParticipants
        .where((participant) => !currentUserIds.contains(participant.id.userId))
        .toList();
    return filteredNewbies;
  }
}

final participantProvider = AsyncNotifierProvider.family<
    ChatroomParticipantViewModel, List<ChatroomParticipantModel>, int>(
  ChatroomParticipantViewModel.new,
);
