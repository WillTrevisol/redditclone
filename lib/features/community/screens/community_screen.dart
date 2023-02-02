import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loading_widget.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/community_controller.dart';

class CommunityScreen extends ConsumerWidget {

  final String name;

  const CommunityScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final user = ref.watch(userProvider)!;

    void navigateToModeratorTools() {
      Routemaster.of(context).push('/moderator-tools/$name');
    }

    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
        data: (data) => NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                snap: true,
                expandedHeight: MediaQuery.of(context).size.height * 0.25,
                flexibleSpace: Stack(
                  children: <Widget> [
                    Positioned.fill(
                      child: Image.network(
                        data.banner, 
                        fit: BoxFit.cover,
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
                      Align(
                        alignment: Alignment.topLeft,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(data.avatar),
                          radius: 35,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget> [
                          Text(
                            'r/${data.name}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          data.moderators.contains(user.uid) 
                          ? OutlinedButton(
                              onPressed: () => navigateToModeratorTools(),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 25),
                                side: BorderSide(
                                  color: Colors.grey.shade700
                                )
                              ),
                              child: const Text('Moderator Tools'),
                            )
                          : OutlinedButton(
                              onPressed: (){},
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 25),
                                side: BorderSide(
                                  color: Colors.grey.shade700
                                )
                              ),
                              child: Text(data.members.contains(user.uid) ? 'Joined' : 'Join'),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text('${data.members.length} members'),
                      ),
                    ], 
                  ),
                ),
              ),
            ];
          }, 
          body: const Text('Displaying posts.'),
        ), 
        error: (error, stackTrace) => ErrorText(message: error.toString()), 
        loading: () => const LoadingWidget(),
      ),
    );
  }
}