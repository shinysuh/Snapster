import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/video/models/video_model.dart';

class VideoRepository {
  static const String videoCollection = 'videos';
  static const String likeCollection = 'likes';

  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // upload a video file
  UploadTask uploadVideoFile(File video, String uid, String createdAt) {
    final fileRef = _storage.ref().child('$videoCollection/$uid/$createdAt');
    return fileRef.putFile(video);
  }

  // create a video document
  Future<void> saveVideo(VideoModel data) async {
    await _database.collection(videoCollection).add(data.toJson());
  }

  // get videos by 최신순
  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos({
    int? lastItemCreatedAt,
  }) async {
    final query = _database
        .collection(videoCollection)
        .orderBy("createdAt", descending: true)
        .limit(2);

    return lastItemCreatedAt == null
        ? await query.get()
        : await query.startAfter([lastItemCreatedAt]).get();
  }

  // // get a video by videoId
  // Future<Map<String, dynamic>?> findVideo(String videoId) async {
  //   final doc = await _database.collection(videoCollection).doc(videoId).get();
  //   return doc.data();
  // }

  // like toggle
  Future<void> toggleLikeVideo({
    required String videoId,
    required String userId,
  }) async {
    final query = await _fetchLike(videoId: videoId, userId: userId);
    final like = await query.get();

    if (!like.exists) {
      await query.set({
        "createdAt": DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      await query.delete();
    }
  }

  // get like
  Future<bool> isLiked({
    required String videoId,
    required String userId,
  }) async {
    final doc = await _fetchLike(videoId: videoId, userId: userId);
    return doc.get().then((value) => value.exists);
  }

  Future<DocumentReference> _fetchLike({
    required String videoId,
    required String userId,
  }) async {
    final key = '${videoId}000000$userId';
    return _database.collection(likeCollection).doc(key);
  }

// // get a thumbnailURL
// Future<String> findThumbnailURL(String videoId) async {
//   var video = await findVideo(videoId);
//   return video?['thumbnailURL'] ?? '';
// }

// delete a video
}

final videoRepository = Provider((ref) => VideoRepository());
