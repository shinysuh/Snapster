import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/user/repository/user_repository.dart';
import 'package:tiktok_clone/features/video/models/video_model.dart';

class VideoRepository {
  static const String videoCollection = 'videos';

  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // upload a video file
  UploadTask uploadVideoFile(File video, String uid, String createdAt) {
    final fileRef = _storage.ref().child('$videoCollection/$uid/$createdAt');
    return fileRef.putFile(video);
  }

  // create a video document
  Future<DocumentReference<Map<String, dynamic>>> saveVideo(
      VideoModel data) async {
    return await _database.collection(videoCollection).add(data.toJson());
  }

  // get a video
  Future<Map<String, dynamic>?> findVideo(String videoId) async {
    final doc = await _database.collection(videoCollection).doc(videoId).get();
    return doc.data();
  }

  // get a thumbnailURL
  Future<String> findThumbnailURL(String videoId) async {
    var video = await findVideo(videoId);
    return video?['thumbnailURL'] ?? '';
  }

  // save video & thumbnail info to user collection
  Future<void> saveVideoAndThumbnail(
      Map<String, dynamic> video, String videoId, String thumbnailURL) async {
    String uploaderUid = video['uploaderUid'] ?? '';
    if (uploaderUid.isEmpty) return;

    await _database
        .collection(UserRepository.userCollection)
        .doc(uploaderUid)
        .collection(videoCollection)
        .doc(videoId)
        .set({
      'thumbnailURL': thumbnailURL,
      'videoId': videoId,
    });
  }

// get a thumbnail

// delete a video
}

final videoRepository = Provider((ref) => VideoRepository());
