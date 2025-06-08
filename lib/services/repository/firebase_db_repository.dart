import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_platter/services/models/user_profile_model.dart';

class FirebaseDBRepositoryImpl implements FirebaseDBRepository {
  FirebaseDBRepositoryImpl(this.firestoreDB, this.firebaseAuth);
  final FirebaseFirestore firestoreDB;
  final FirebaseAuth firebaseAuth;

  @override
  Future<void> addUserProfile(Map<String, dynamic> userDetails) async {
    final userId = firebaseAuth.currentUser!.uid;
    final Map<String, String?> map = {
      'phone': firebaseAuth.currentUser!.phoneNumber,
      'email': firebaseAuth.currentUser!.email,
    };
    userDetails.addAll(map);
    await firestoreDB.collection('user_profiles').doc(userId).set(userDetails);
  }

  @override
  Future<UserProfile> getUserProfile() async {
    final userId = firebaseAuth.currentUser!.uid;
    final data =
        await firestoreDB.collection('user_profiles').doc(userId).get();
    final userData = UserProfile.fromJson(data.data()!);
    return userData;
  }
}

abstract class FirebaseDBRepository {
  Future<void> addUserProfile(Map<String, dynamic> userDetails);
  Future<UserProfile> getUserProfile();
}
