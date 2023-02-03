import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/storage_repository_provider.dart';
import '../../../core/utils.dart';
import '../../../models/community.dart';
import '../../../models/post.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/post_repository.dart';

final postControllerProvider = StateNotifierProvider<PostController, bool>(
  (StateNotifierProviderRef ref) {
    final postRepository = ref.watch(postRepositoryProvider);
    final storageRepository = ref.watch(storageRepositoryProvider);
    return PostController(
      postRepository: postRepository, 
      ref: ref, 
      storageRepository: storageRepository
    );
  }
);

class PostController extends StateNotifier<bool>{
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  PostController({
    required PostRepository postRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  }) : _postRepository = postRepository,
  _ref = ref,
  _storageRepository = storageRepository,
  super(false);

  void shareTextPost({
    required BuildContext context,
    required String title,
    required Community community,
    required String description,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postId, 
      title: title, 
      communityName: community.name, 
      communityAvatar: community.avatar, 
      userName: user.name, 
      userUid: user.uid, 
      type: 'text', 
      commentCount: 0, 
      createdAt: DateTime.now(), 
      upVotes: [], 
      downVotes: [], 
      awards: [],
      description: description,
    );

    final response = await _postRepository.addPost(post);
    state = false;

    response.fold(
      (left) => showSnackBar(context, left.message), 
      (right) {
        showSnackBar(context, 'Post created!');
        Routemaster.of(context).pop();
      },
    );
  }

  void shareLinkPost({
    required BuildContext context,
    required String title,
    required Community community,
    required String link,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postId, 
      title: title, 
      communityName: community.name, 
      communityAvatar: community.avatar, 
      userName: user.name, 
      userUid: user.uid, 
      type: 'link', 
      commentCount: 0, 
      createdAt: DateTime.now(), 
      upVotes: [], 
      downVotes: [], 
      awards: [],
      link: link,
    );

    final response = await _postRepository.addPost(post);
    state = false;

    response.fold(
      (left) => showSnackBar(context, left.message), 
      (right) {
        showSnackBar(context, 'Post created!');
        Routemaster.of(context).pop();
      },
    );
  }

  void shareImagePost({
    required BuildContext context,
    required String title,
    required Community community,
    required File? image,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final imageResult = await _storageRepository.storeFile(
      path: 'posts/${community.name}', 
      id: postId, 
      file: image
    );

    imageResult.fold(
      (left) => showSnackBar(context, left.message), 
      (right) async {

      final Post post = Post(
        id: postId, 
        title: title, 
        communityName: community.name, 
        communityAvatar: community.avatar, 
        userName: user.name, 
        userUid: user.uid, 
        type: 'image', 
        commentCount: 0, 
        createdAt: DateTime.now(), 
        upVotes: [], 
        downVotes: [], 
        awards: [],
        link: right,
      );

      final response = await _postRepository.addPost(post);
      state = false;

      response.fold(
        (left) => showSnackBar(context, left.message), 
        (right) {
          showSnackBar(context, 'Post created!');
          Routemaster.of(context).pop();
        },
      );

      },
    );
  }
}