import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/storage_repository_provider.dart';
import '../../../core/utils.dart';
import '../../../models/comment.dart';
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

final fetchUserPostsProvider = StreamProvider.family(
  (StreamProviderRef ref, List<Community> communities) {
    final postController = ref.watch(postControllerProvider.notifier);
    return postController.fetchUserPosts(communities);
  }
);

final getPostByIdProvider = StreamProvider.family(
  (StreamProviderRef ref, String postId) {
    final postController = ref.watch(postControllerProvider.notifier);
    return postController.getPostById(postId);
});

final getPostCommentsProvider = StreamProvider.family(
  (StreamProviderRef ref, String postId) {
    final postController = ref.watch(postControllerProvider.notifier);
    return postController.fetchPostComments(postId);
});

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

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPosts(communities);
    }

    return Stream.value([]);
  }

  void deletePost(BuildContext context, Post post) async {
    final response = await _postRepository.deletePost(post);

    response.fold(
      (left) => showSnackBar(context, left.toString()),
      (right) => showSnackBar(context, 'Deleted post!'),
    );
  }

  void upVote(Post post) async {
    final userUid = _ref.read(userProvider)!.uid;
    _postRepository.upvote(post, userUid);
  }

  void downVote(Post post) async {
    final userUid = _ref.read(userProvider)!.uid;
    _postRepository.downvote(post, userUid);
  }

  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  void addComment({
    required BuildContext context, 
    required String text,
    required String postId
  }) async {

    final user = _ref.read(userProvider)!;
    final uid = const Uuid().v1();

    final Comment comment = Comment(
      id: uid, 
      text: text, 
      createdAt: DateTime.now(), 
      postId: postId, 
      userName: user.name, 
      userProfilePicture: user.profilePicture,
    );

    final response = await _postRepository.addComment(comment);

    response.fold(
      (left) => showSnackBar(context, left.message), 
      (right) => null,
    );
  }

   Stream<List<Comment>> fetchPostComments(String postId) {
    return _postRepository.getCommentsOfPost(postId);
  }
}