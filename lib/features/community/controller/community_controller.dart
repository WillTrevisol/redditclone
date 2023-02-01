import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redditclone/models/community.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/community_repository.dart';

final userCommunitiesProvider = StreamProvider(
  (StreamProviderRef ref) => ref.watch(communityControllerProvider.notifier).getUserCommunities());

final communityControllerProvider = StateNotifierProvider<CommunityController, bool>(
  (ref) => CommunityController(
    communityRepository: ref.watch(communityRepositoryProvider), 
    ref: ref,
  ),
);

class CommunityController extends StateNotifier<bool> {

  final CommunityRepository _communityRepository;
  final Ref _ref;

  CommunityController({
    required CommunityRepository communityRepository,
    required Ref ref})
    : _communityRepository = communityRepository,
    _ref = ref,
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

  Stream<List<Community>> getUserCommunities() {
    final userUid = _ref.read(userProvider)!.uid;

    return _communityRepository.getUserCommunities(userUid);
  }
}