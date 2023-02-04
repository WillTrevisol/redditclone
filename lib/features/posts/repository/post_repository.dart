import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/typedefs.dart';
import '../../../models/comment.dart';
import '../../../models/community.dart';
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
  CollectionReference get _comments => _firebaseFirestore.collection(FirebaseConstants.commentsCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    return _posts.where('communityName', whereIn: communities.map(
      (community) => community.name).toList())
      .orderBy('createdAt', descending: true).snapshots().map(
        (event) => event.docs.map(
          (e) => Post.fromMap(e.data() as Map<String, dynamic>)).toList());
  }

  FutureVoid deletePost(Post post) async {
    try {
      return right(_posts.doc(post.id).delete());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void upvote(Post post, String userUid) async {
    if (post.downVotes.contains(userUid)) {
      _posts.doc(post.id).update({
        'downVotes': FieldValue.arrayRemove([userUid]),
      });
    }

    if (post.upVotes.contains(userUid)) {
      _posts.doc(post.id).update({
        'upVotes': FieldValue.arrayRemove([userUid]),
      });
    } else {
      _posts.doc(post.id).update({
        'upVotes': FieldValue.arrayUnion([userUid]),
      });
    }
  }

  void downvote(Post post, String userUid) async {
    if (post.upVotes.contains(userUid)) {
      _posts.doc(post.id).update({
        'upVotes': FieldValue.arrayRemove([userUid]),
      });
    }

    if (post.downVotes.contains(userUid)) {
      _posts.doc(post.id).update({
        'downVotes': FieldValue.arrayRemove([userUid]),
      });
    } else {
      _posts.doc(post.id).update({
        'downVotes': FieldValue.arrayUnion([userUid]),
      });
    }
  }

  Stream<Post> getPostById(String postId) {
    return _posts.doc(postId).snapshots().map((event) => Post.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid addComment(Comment comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());
      return right(_posts.doc(comment.postId).set({
        'commentCount': FieldValue.increment(1),
      }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Comment>> getCommentsOfPost(String postId) {
    return _comments.where('postId', isEqualTo: postId)
      .orderBy('createdAt', descending: true).snapshots()
        .map((event) => event.docs.map((e) => Comment.fromMap(e.data() as Map<String, dynamic>)).toList());
  }

}