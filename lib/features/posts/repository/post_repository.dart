import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/typedefs.dart';
import '../../../models/post.dart';

final postRepositoryProvider = Provider((ProviderRef ref) {
  return PostRepository(firebaseFirestore: ref.watch(firestoreProvider)); 
});

class PostRepository {

  final FirebaseFirestore _firebaseFirestore;
  PostRepository({
    required FirebaseFirestore firebaseFirestore
  }) : _firebaseFirestore = firebaseFirestore;

  CollectionReference get _posts => _firebaseFirestore.collection(FirebaseConstants.postsCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }


}