
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils.dart';
import '../../../models/user.dart';
import '../repository/auth_repository.dart';

final userProvider = StateProvider<UserModel?>((StateProviderRef ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (StateNotifierProviderRef ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authUserStateChangesProvider = StreamProvider(
  (StreamProviderRef ref) {
    final authController = ref.watch(authControllerProvider.notifier);
    return authController.authStateChanges;
  },
);

final getUserDataProvider = StreamProvider.family(
  (StreamProviderRef ref, String uid) {
    final authController = ref.watch(authControllerProvider.notifier);
    return authController.getUserData(uid);
  }
);

class AuthController extends StateNotifier<bool> {

  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({
    required AuthRepository authRepository, 
    required ref}) 
    : _authRepository = authRepository, 
    _ref = ref,
    super(false);

  Stream<User?> get authStateChanges => _authRepository.authUserStateChanges;

  void signInWithGoole(BuildContext context, bool isFromLogin) async {
    state = true;
    final user = await _authRepository.signInWithGoogle(isFromLogin);
    state = false;

    user.fold(
      (left) => showSnackBar(context, left.message),
      (right) => _ref.read(userProvider.notifier).update((state) => right),
    );
  }

  void signInAsGuest(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInAsGuest();
    state = false;

    user.fold(
      (left) => showSnackBar(context, left.message),
      (right) => _ref.read(userProvider.notifier).update((state) => right),
    );
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  Future<void> logOut() async {
    await _authRepository.logOut();
  }
}