import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/inbox/models/MessageModel.dart';
import 'package:tiktok_clone/features/inbox/repositories/message_repository.dart';
import 'package:tiktok_clone/utils/base_exception_handler.dart';

class MessageViewModel extends AsyncNotifier<void> {
  late final MessageRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(messageRepository);
  }

  Future<void> sendMessage(BuildContext context, String text) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = ref.read(authRepository).user;
      final message = MessageModel(
        text: text,
        userId: user!.uid,
      );
      _repository.sendMessage(message, '');

      if (state.hasError) {
        showFirebaseErrorSnack(context, state.error);
      }
    });
  }
}

final messageProvider = AsyncNotifierProvider<MessageViewModel, void>(
  () => MessageViewModel(),
);
