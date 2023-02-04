import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:redditclone/core/typedefs.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../models/community.dart';
import '../../../models/post.dart';

final communityRepositoryProvider = Provider(
  (ref) => CommunityRepository(
    firebaseFirestore: ref.watch(firestoreProvider),
  ),
);

class CommunityRepository {
  
  final FirebaseFirestore _firebaseFirestore;

  CommunityRepository({required FirebaseFirestore firebaseFirestore}) : _firebaseFirestore = firebaseFirestore;

  CollectionReference get _communitites => _firebaseFirestore.collection(FirebaseConstants.communitiesCollection);
  CollectionReference get _posts => _firebaseFirestore.collection(FirebaseConstants.communitiesCollection);


  FutureVoid createCommunity(Community community) async {
    try {
      final communityDoc = await _communitites.doc(community.name).get();

      if (communityDoc.exists) {
        throw 'Community with the same name already exists!';
      }

      return right(_communitites.doc(community.name).set(community.toMap()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid joinCommunity(String communityName, String userUid) async {
    try {
      return right (_communitites.doc(communityName)
        .update({
          'members': FieldValue.arrayUnion([userUid]),
        }),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid leaveCommunity(String communityName, String userUid) async {
    try {
      return right (_communitites.doc(communityName)
        .update({
          'members': FieldValue.arrayRemove([userUid]),
        }),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> getUserCommunities(String uid) {
    return _communitites.where('members', arrayContains: uid).snapshots().map(
      (event) {
        List<Community> communities = [];
        for (var element in event.docs) { 
          communities.add(Community.fromMap(element.data() as Map<String, dynamic>));
        }

        return communities;
      },
    );
  }

  Stream<Community> getCommunityByName(String name) =>
    _communitites.doc(name).snapshots().map((event) => Community.fromMap(event.data() as Map<String, dynamic>));

  FutureVoid editCommunity(Community community) async {
    try {
      return right(_communitites.doc(community.name).update(community.toMap()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid addModerators(String communtyName, List<String> moderatorsUids) async {
    try {
      return right(_communitites.doc(communtyName).update({
        'moderators': moderatorsUids,
      }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communitites
      .where(
      'name', 
      isGreaterThanOrEqualTo: query.isEmpty ? 0 : query, 
      isLessThan: query.isEmpty ? null : query.substring(0, query.length -1) + String.fromCharCode(query.codeUnitAt(query.length - 1)+1))
      .snapshots().map(
        (event) {
          List<Community> communities = [];
          for (var community in event.docs) {
            communities.add(Community.fromMap(community.data() as Map<String, dynamic>));
          }
          return communities;
        },
      );
  }

  Stream<List<Post>> getCommunityPosts(String communityName) {
    return _posts.where('communityName', isEqualTo: communityName)
      .orderBy('createdAt', descending: true).snapshots()
        .map((event) => event.docs.map((e) => Post.fromMap(e.data() as Map<String, dynamic>)).toList());
  }

  
}