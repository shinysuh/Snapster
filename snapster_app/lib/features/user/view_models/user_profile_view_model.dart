import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/authentication/providers/auth_provider.dart';
import 'package:snapster_app/features/authentication/services/i_auth_service.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/features/user/models/user_profile_model.dart';
import 'package:snapster_app/features/user/repository/user_repository.dart';
import 'package:snapster_app/features/video/models/thumbnail_link_model.dart';
import 'package:snapster_app/features/video/repositories/video_repository.dart';

class UserProfileViewModel extends FamilyAsyncNotifier<void, UserProfileModel> {
  late final IAuthService _authProvider;
  late final VideoRepository _videoRepository;

  late final UserProfileModel _profile;
  late final AppUser? _user;

  @override
  FutureOr<void> build(UserProfileModel arg) {
    _profile = arg;
    _videoRepository = ref.read(videoRepository);
    _authProvider = ref.read(firebaseAuthServiceProvider);
    _user = _authProvider.currentUser;
  }
}

final userProfileProvider =
    AsyncNotifierProvider.family<UserProfileViewModel, void, UserProfileModel>(
  () => UserProfileViewModel(),
);

final uploadedThumbnailListProvider = StreamProvider.autoDispose
    .family<List<ThumbnailLinkModel>, String>((ref, userId) {
  return FirebaseFirestore.instance
      .collection(UserRepository.userCollection)
      .doc(userId)
      .collection(VideoRepository.videoCollection)
      .orderBy('createdAt', descending: true)
      // .limit(10)   // paging 필요
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map(
            (doc) => ThumbnailLinkModel.fromJson(doc.data()),
          )
          .toList());
});

final likedThumbnailListProvider = StreamProvider.autoDispose
    .family<List<ThumbnailLinkModel>, String>((ref, userId) {
  return FirebaseFirestore.instance
      .collection(UserRepository.userCollection)
      .doc(userId)
      .collection(VideoRepository.likeCollection)
      .orderBy('createdAt', descending: true)
      // .limit(10)   // paging 필요
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map(
            (doc) => ThumbnailLinkModel.fromJson(doc.data()),
          )
          .toList());
});
