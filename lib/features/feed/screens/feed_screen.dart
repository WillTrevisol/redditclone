import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loading_widget.dart';
import '../../../core/common/post_card.dart';
import '../../community/controller/community_controller.dart';
import '../../posts/controller/post_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userCommunitiesProvider).when(
      data: (communities) => ref.watch(fetchUserPostsProvider(communities)).when(
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
}