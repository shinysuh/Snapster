import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/user/models/user_profile_model.dart';

class UserRepository {
  static const String userCollection = 'users';
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  // create
  Future<void> createProfile(UserProfileModel profile) async {
    await _database
        .collection(userCollection)
        .doc(profile.uid)
        .set(profile.toJson());
  }

  // get
  Future<Map<String, dynamic>?> findProfile(String uid) async {
    final doc = await _database.collection(userCollection).doc(uid).get();
    return doc.data();
  }

// update avatar

// update bio

// update link

// delete
}

final userRepository = Provider(
  (ref) => UserRepository(),
);
