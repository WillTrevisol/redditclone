import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loading_widget.dart';
import '../../../core/common/post_card.dart';
import '../../auth/controller/auth_controller.dart';
import '../../community/controller/community_controller.dart';
import '../../posts/controller/post_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    if (isGuest) {
      return ref.watch(userCommunitiesProvider).when(
        data: (communities) => ref.watch(fetchRandomPostsProvider).when(
          data: (posts) {
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                return PostCard(post: post);
              },
            );
          },
          error: (error, stackTrace) => ErrorText(message: error.toString()),
          loading: () => const LoadingWidget(),
        ), 
        error: (error, stackTrace) => ErrorText(message: error.toString()), 
        loading: () => const LoadingWidget(),
      );
    }
    return ref.watch(userCommunitiesProvider).when(
      data: (communities) {
        if (communities.isEmpty) {
          return ref.watch(userCommunitiesProvider).when(
            data: (communities) => ref.watch(fetchRandomPostsProvider).when(
              data: (posts) {
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];

                    return PostCard(post: post);
                  },
                );
              },
              error: (error, stackTrace) => ErrorText(message: error.toString()),
              loading: () => const LoadingWidget(),
            ), 
            error: (error, stackTrace) => ErrorText(message: error.toString()), 
            loading: () => const LoadingWidget(),
          );
        } else {
          return ref.watch(fetchUserPostsProvider(communities)).when(
            data: (posts) {
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];

                  return PostCard(post: post);
                },
              );
            },
            error: (error, stackTrace) => ErrorText(message: error.toString()),
            loading: () => const LoadingWidget(),
          );
        }
      },
      error: (error, stackTrace) => ErrorText(message: error.toString()), 
      loading: () => const LoadingWidget(),
    );
  }
}