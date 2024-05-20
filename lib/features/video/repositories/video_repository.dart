import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  Future<void> saveVideo(VideoModel data) async {
    await _database.collection(videoCollection).add(data.toJson());
  }

// get a thumbnail

// delete a video
}

final videoRepository = Provider((ref) => VideoRepository());
