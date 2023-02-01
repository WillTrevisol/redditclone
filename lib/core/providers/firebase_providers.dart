import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final firestoreProvider = Provider((ProviderRef ref) => FirebaseFirestore.instance);
final firebaseAuthProvider = Provider((ProviderRef ref) => FirebaseAuth.instance);
final firebaseStorageProvider = Provider((ProviderRef ref) => FirebaseStorage.instance);
final googleSignInProvider = Provider((ProviderRef ref) => GoogleSignIn());