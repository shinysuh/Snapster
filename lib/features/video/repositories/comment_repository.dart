import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/video/models/comment_model.dart';
import 'package:tiktok_clone/features/video/repositories/video_repository.dart';

class CommentRepository {
  static const String commentCollection = 'comments';

  final FirebaseFirestore _database = FirebaseFirestore.instance;

  // save a comment
  Future<void> saveComment(CommentModel comment) async {
    await _database
        .collection(VideoRepository.videoCollection)
        .doc(comment.videoId)
        .collection(commentCollection)
        .add(comment.toJson());
  }

  // update a comment
  Future<void> updateComment(CommentModel comment) async {
    await _database
        .collection(VideoRepository.videoCollection)
        .doc(comment.videoId)
        .collection(commentCollection)
        .doc(comment.commentId)
        .update(comment.toJson());
  }

  // delete a comment
  Future<void> deleteComment(CommentModel comment) async {
    await _database
        .collection(VideoRepository.videoCollection)
        .doc(comment.videoId)
        .collection(commentCollection)
        .doc(comment.commentId)
        .delete();
  }
}

final commentRepository = Provider((ref) => CommentRepository());
