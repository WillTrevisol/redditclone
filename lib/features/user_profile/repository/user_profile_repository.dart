import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/typedefs.dart';
import '../../../models/post.dart';
import '../../../models/user.dart';

final userProfileRepositoryProvider = Provider((ProviderRef ref) {
  return UserProfileRepository(firebaseFirestore: ref.read(firestoreProvider));
});

class UserProfileRepository {

  final FirebaseFirestore _firebaseFirestore;
  UserProfileRepository({required FirebaseFirestore firebaseFirestore}) : _firebaseFirestore = firebaseFirestore;

  CollectionReference get _users => _firebaseFirestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _posts => _firebaseFirestore.collection(FirebaseConstants.postsCollection);


  FutureVoid editProfile(UserModel user) async {
    try {
      return  right(await _users.doc(user.uid).update(user.toMap()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> getUserPosts(String uid) {
    return _posts.where('userUid', isEqualTo: uid)
      .orderBy('createdAt', descending: true).snapshots()
        .map((event) => event.docs.map((e) => Post.fromMap(e.data() as Map<String, dynamic>)).toList());
  }

}