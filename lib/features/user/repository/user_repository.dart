import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/user/models/user_profile_model.dart';

class UserRepository {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  // create
  Future<void> createProfile(UserProfileModel profile) async {
    await _database.collection('users').doc(profile.uid).set(profile.toJson());
  }

// get

// update avatar

// update bio

// update link

// delete
}

final userRepository = Provider(
  (ref) => UserRepository(),
);
