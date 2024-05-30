import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/user/models/user_profile_model.dart';

class UserRepository {
  static const String userCollection = 'users';
  static const String avatarStoragePath = 'avatars';

  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

  // update profile
  Future<UserProfileModel> updateProfile(
      String uid, UserProfileModel profile) async {
    await _database
        .collection(userCollection)
        .doc(uid)
        .update(profile.toJson());
    return profile;
  }

  // update profile
  Future<void> patchProfile(String uid, Map<String, dynamic> newData) async {
    await _database.collection(userCollection).doc(uid).update(newData);
  }

  // delete
  Future<void> deleteProfile(UserProfileModel profile) async {
    await _database.collection(userCollection).doc(profile.uid).delete();
  }

  Future<void> uploadAvatar(File file, String fileName) async {
    final fileRef = _storage.ref().child('$avatarStoragePath/$fileName');
    await fileRef.putFile(file);
  }

  Future<void> deleteAvatar(String fileName) async {
    final fileRef = _storage.ref().child('$avatarStoragePath/$fileName');
    await fileRef.delete();
  }
}

final userRepository = Provider(
  (ref) => UserRepository(),
);
