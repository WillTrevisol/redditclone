import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:redditclone/models/community.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/constants/constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/storage_repository_provider.dart';
import '../../../core/utils.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/community_repository.dart';

final userCommunitiesProvider = StreamProvider(
  (StreamProviderRef ref) => ref.watch(communityControllerProvider.notifier).getUserCommunities());

final communityControllerProvider = StateNotifierProvider<CommunityController, bool>(
  (StateNotifierProviderRef ref) => CommunityController(
    communityRepository: ref.watch(communityRepositoryProvider), 
    ref: ref,
    storageRepository: ref.watch(storageRepositoryProvider),
  ),
);

final getCommunityByNameProvider = StreamProvider.family(
  (StreamProviderRef ref, String name) => ref.watch(communityControllerProvider.notifier).getCommunityByName(name),
);

final searchCommunityProvider = StreamProvider.family(
  (StreamProviderRef ref, String query) => ref.watch(communityControllerProvider.notifier).searchCommunity(query),
);

class CommunityController extends StateNotifier<bool> {

  final CommunityRepository _communityRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  CommunityController({
    required CommunityRepository communityRepository,
    required Ref ref,
    required StorageRepository storageRepository})
    : _communityRepository = communityRepository,
    _ref = ref,
    _storageRepository = storageRepository,
    super(false);

  void createCommunity(BuildContext context, String name) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';

    Community community = Community(
      id: name, 
      name: name, 
      banner: Constants.bannerDefault, 
      avatar: Constants.avatarDefault, 
      members: <String>[uid], 
      moderators: <String>[uid],
    );

    final response = await _communityRepository.createCommunity(community);

    state = false;

    response.fold(
      (left) => showSnackBar(context, left.message),
      (right) {
        showSnackBar(context, 'Community created!');
        Routemaster.of(context).pop();
      }
    );
  }

  Future<void> joinOrLeftCommunity(BuildContext context, Community community) async {
    final user = _ref.read(userProvider)!;
    Either<Failure, void> response;

    if (community.members.contains(user.uid)) {
      response = await _communityRepository.leaveCommunity(community.name, user.uid);
    } else {
      response = await _communityRepository.joinCommunity(community.name, user.uid);
    }

    response.fold(
      (left) => showSnackBar(context, left.message), 
      (right) {
        if (community.members.contains(user.uid)) {
          showSnackBar(context, 'Left the community!');
        } else {
          showSnackBar(context, 'Joined community!');
        }
      },
    );
  }

  Stream<List<Community>> getUserCommunities() {
    final userUid = _ref.read(userProvider)!.uid;

    return _communityRepository.getUserCommunities(userUid);
  }

  Stream<Community> getCommunityByName(String name) => _communityRepository.getCommunityByName(name);

  void editCommunity({
    required BuildContext context, 
    required File? avatarFile, 
    required File? bannerFile, 
    required Community community}) async {
    state = true;
    if (avatarFile != null) {
      final response = await _storageRepository.storeFile(
        path: 'communities/avatar', 
        id: community.name, 
        file: avatarFile,
      );

      response.fold(
        (left) => showSnackBar(context, left.message), 
        (right) => community = community.copyWith(avatar: right),
      );
    }

    if (bannerFile != null) {
      final response = await _storageRepository.storeFile(
        path: 'communities/banner', 
        id: community.name, 
        file: bannerFile,
      );

      response.fold(
        (left) => showSnackBar(context, left.message), 
        (right) => community = community.copyWith(banner: right),
      );
    }

    final response = await _communityRepository.editCommunity(community);
    state = false;
    response.fold(
      (left) => showSnackBar(context, left.message), 
      (right) => Routemaster.of(context).pop(),
    );
  }

  void addModerators(BuildContext context, String communityName, List<String> moderatorsUids) async {
    final response = await _communityRepository.addModerators(communityName, moderatorsUids);

    response.fold(
      (left) => showSnackBar(context, left.message), 
      (right) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }
}