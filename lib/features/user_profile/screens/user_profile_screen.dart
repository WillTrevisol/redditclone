import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loading_widget.dart';
import '../../../core/common/post_card.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/user_profile_controller.dart';

class UserProfileScreen extends ConsumerWidget {

  final String uid;
  const UserProfileScreen({super.key, required this.uid});

  void navigateToEditProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/edit-profile/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

  final user = ref.watch(userProvider)!;

    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
        data: (data) => NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                snap: true,
                expandedHeight: MediaQuery.of(context).size.height * 0.35,
                flexibleSpace: Stack(
                  children: <Widget> [
                    Positioned.fill(
                      child: Image.network(
                        data.banner, 
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(20).copyWith(bottom: 70),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(data.profilePicture),
                        radius: 45,
                      ),
                    ),
                    if (uid == user.uid)
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.all(20),
                        child: OutlinedButton(
                          onPressed: () => navigateToEditProfile(context, uid),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            side: BorderSide(
                              color: Colors.grey.shade700
                            )
                          ),
                          child: const Text('Edit profile'),
                        ),
                      ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget> [
                          Text(
                            'u/${data.name}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text('${data.karma} karma'),
                      ),
                      const SizedBox(height: 10),
                      const Divider(thickness: 2),
                    ], 
                  ),
                ),
              ),
            ];
          }, 
          body: ref.watch(getUserPostsProvider(uid)).when(
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
        ), 
        error: (error, stackTrace) => ErrorText(message: error.toString()), 
        loading: () => const LoadingWidget(),
      ),
    );
  }
}