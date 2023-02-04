import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/enums/enums.dart';
import '../../../core/providers/storage_repository_provider.dart';
import '../../../core/utils.dart';
import '../../../models/post.dart';
import '../../../models/user.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/user_profile_repository.dart';

final userProfileControllerProvider = StateNotifierProvider<UserProfileController, bool>(
  (StateNotifierProviderRef ref) {
    final userProfileRepository = ref.watch(userProfileRepositoryProvider);
    final storageRepository = ref.watch(storageRepositoryProvider);
    return UserProfileController(
      userProfileRepository: userProfileRepository, 
      ref: ref, 
      storageRepository: storageRepository
    );
  }
);

final getUserPostsProvider = StreamProvider.family(
  (StreamProviderRef ref, String uid) {
    final userProfileController = ref.read(userProfileControllerProvider.notifier);
    return userProfileController.getUserPosts(uid);
});

class UserProfileController extends StateNotifier<bool> {

  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required Ref ref,
    required StorageRepository storageRepository})
    : _userProfileRepository = userProfileRepository,
    _ref = ref,
    _storageRepository = storageRepository,
    super(false);

  void editUserProfile({
    required BuildContext context, 
    required File? profilePicture, 
    required File? bannerFile,
    required String name}) async {
    state = true;

    UserModel user = _ref.read(userProvider)!;

    if (profilePicture != null) {
      final response = await _storageRepository.storeFile(
        path: 'communities/avatar', 
        id: user.uid, 
        file: profilePicture,
      );

      response.fold(
        (left) => showSnackBar(context, left.message), 
        (right) => user = user.copyWith(profilePicture: right),
      );
    }

    if (bannerFile != null) {
      final response = await _storageRepository.storeFile(
        path: 'communities/banner', 
        id: user.uid, 
        file: bannerFile,
      );

      response.fold(
        (left) => showSnackBar(context, left.message), 
        (right) => user = user.copyWith(banner: right),
      );
    }

    user = user.copyWith(name: name); 
    final response = await _userProfileRepository.editProfile(user);
    state = false;
    response.fold(
      (left) => showSnackBar(context, left.message), 
      (right) {
        _ref.read(userProvider.notifier).update((state) => user);
        Routemaster.of(context).pop();
      },
    );
  }

  Stream<List<Post>> getUserPosts(String uid) {
    return _userProfileRepository.getUserPosts(uid);
  }

  void updateUserKarma(UserKarma karma) async {
    UserModel user = _ref.read(userProvider)!;

    user = user.copyWith(karma: user.karma + karma.karma);

    final response = await _userProfileRepository.updateUserKarma(user);

    response.fold(
      (left) => null, 
      (right) => _ref.read(userProvider.notifier).update((state) => user),
    );
  }

}