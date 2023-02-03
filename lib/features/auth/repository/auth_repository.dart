import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/constants/constants.dart';
import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/typedefs.dart';
import '../../../models/user.dart';

final authRepositoryProvider = Provider(
  (ProviderRef ref) => AuthRepository(
    firestore: ref.read(firestoreProvider), 
    auth: ref.read(firebaseAuthProvider), 
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  }) : 
    _auth = auth, 
    _firestore = firestore, 
    _googleSignIn = googleSignIn;


  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authUserStateChanges => _auth.authStateChanges();

  FutureEither<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      UserModel? user;

      if (userCredential.additionalUserInfo != null && userCredential.additionalUserInfo!.isNewUser) {
        user = UserModel(
          name: userCredential.user?.displayName ?? '', 
          email: userCredential.user?.email ?? '', 
          profilePicture: userCredential.user?.photoURL ?? Constants.avatarDefault, 
          banner: Constants.bannerDefault, 
          uid: userCredential.user!.uid, 
          isAuthenticated: true, 
          karma: 0, 
          awards: [],
        );

        await _users.doc(user.uid).set(
          user.toMap()
        );
      } else {
        user = await getUserData(userCredential.user!.uid).first;
      }

      return right(user);

    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid)
    => _users.doc(uid).snapshots().map((event) => UserModel.fromMap(event.data() as Map<String, dynamic>));

  Future<void> logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

}