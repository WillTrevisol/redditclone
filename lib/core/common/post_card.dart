import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../features/auth/controller/auth_controller.dart';
import '../../features/community/controller/community_controller.dart';
import '../../features/posts/controller/post_controller.dart';
import '../../models/post.dart';
import '../../theme/theme.dart';
import '../constants/constants.dart';
import 'error_text.dart';
import 'loading_widget.dart';

class PostCard extends ConsumerWidget {
  const PostCard({super.key, required this.post});

  final Post post;

  void deletePost(BuildContext context, WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).deletePost(context, post);
  }

  void upVotePost(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).upVote(post);
  }

  void downVotePost(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).downVote(post);
  }

  void awardPost(BuildContext context, WidgetRef ref, Post post, String award) {
    ref.read(postControllerProvider.notifier).awardPost(award: award, context: context, post: post);
  }

  void navigateToUserProfile(BuildContext context) {
    Routemaster.of(context).push('/u/${post.userUid}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/r/${post.communityName}');
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/post/${post.id}/comments');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final bool isTypeImage = post.type == 'image';
    final bool isTypeLink = post.type == 'link';
    final bool isTypeText = post.type == 'text';

    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    final currentTheme = ref.watch(themeNotifierProvider);

    return Column(
      children: <Widget> [
        Container(
          decoration: BoxDecoration(
            color: currentTheme.drawerTheme.backgroundColor,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: <Widget> [
              Expanded(
                child: Column(
                  children: <Widget> [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16).copyWith(right: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget> [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,                            
                            children: <Widget> [
                              Row(
                                children: <Widget> [
                                  GestureDetector(
                                    onTap: () => navigateToCommunity(context),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(post.communityAvatar),
                                      radius: 16,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget> [
                                        Text(
                                          'r/${post.communityName}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => navigateToUserProfile(context),
                                          child: Text(
                                            'u/${post.userName}',
                                            style: const TextStyle(
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),                                    
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (post.userUid == user.uid)
                                IconButton(
                                  onPressed: () => deletePost(context, ref),
                                  icon: Icon(
                                    Icons.delete,
                                    color: Pallete.redColor,
                                  ),
                                ),
                            ],
                          ),
                          if (post.awards.isNotEmpty) ...[
                            const SizedBox(height: 5),
                            SizedBox(
                              height: 20,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: post.awards.length,
                                itemBuilder: (context, index) => Image.asset(
                                  Constants.awards[post.awards[index]]!,
                                  height: 20,
                                ),
                              ),
                            ),
                          ],
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              post.title,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isTypeImage)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: double.maxFinite,
                              child: Image.network(
                                post.link ?? '',
                                fit: BoxFit.fill,
                              ),
                            ),

                          if (isTypeLink)
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: AnyLinkPreview(
                                errorWidget: const Center(child: Text('Something gone wrong with the link :(')),
                                displayDirection: UIDirection.uiDirectionHorizontal,
                                link: post.link ?? '',
                              ),
                            ),

                          if (isTypeText)
                            Container(
                              alignment: Alignment.bottomLeft ,
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                post.description ?? '',
                                style: TextStyle(
                                  color: currentTheme.iconTheme.color,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget> [
                                Row(
                                  children: <Widget> [
                                    IconButton(
                                      onPressed: () => isGuest ? null : upVotePost(ref), 
                                      icon: Icon(
                                        Constants.up,
                                        size: 30,
                                        color: post.upVotes.contains(user.uid) ? Pallete.redColor : null,
                                      ),
                                    ),
                                    Text(
                                      '${post.upVotes.length - post.downVotes.length == 0 ? 'Vote' : post.upVotes.length - post.downVotes.length}',
                                      style: const TextStyle(fontSize: 17)
                                    ),
                                    IconButton(
                                      onPressed: () => isGuest ? null : downVotePost(ref), 
                                      icon: Icon(
                                        Constants.down,
                                        size: 30,
                                        color: post.downVotes.contains(user.uid) ? Pallete.blueColor : null,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget> [
                                    IconButton(
                                      onPressed: () => navigateToComments(context), 
                                      icon: const Icon(Icons.comment),
                                    ),
                                    Text(
                                      '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                                      style: const TextStyle(fontSize: 17)
                                    ),
                                    
                                  ],
                                ),
                                ref.watch(getCommunityByNameProvider(post.communityName)).when(
                                  data: (data) {
                                    if (data.moderators.contains(post.userUid)) {
                                      return IconButton(
                                        onPressed: () => deletePost(context, ref), 
                                        icon: const Icon(Icons.remove_moderator),
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                  error: (error, stackTrace) => ErrorText(message: error.toString()),
                                  loading: () => const LoadingWidget(),
                                ),
                                IconButton(
                                  onPressed: isGuest ? null : () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: GridView.builder(
                                            shrinkWrap: true,
                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4,
                                            ),
                                            itemCount: user.awards.length,
                                            itemBuilder: (context, index) {
                                              final award = user.awards[index];

                                              return Builder(
                                                builder: (context) {
                                                  return GestureDetector(
                                                    onTap: () => awardPost(context, ref, post, award),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Image.asset(Constants.awards[award]!),
                                                    ),
                                                  );
                                                }
                                              );
                                            }
                                          ),
                                        ),
                                      ),
                                    );
                                  }, 
                                  icon: const Icon(Icons.card_giftcard_rounded),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}