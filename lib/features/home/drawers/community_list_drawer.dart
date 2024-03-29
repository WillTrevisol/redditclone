import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loading_widget.dart';
import '../../../core/common/sign_in_button.dart';
import '../../../models/community.dart';
import '../../auth/controller/auth_controller.dart';
import '../../community/controller/community_controller.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('create-community');
  }

  void navigateToCommunity(BuildContext context, String name) {
    Routemaster.of(context).push('r/$name');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget> [
            isGuest ? 
            const SignInButton(isFromLogin: false) :
            ListTile(
              title: const Text('Create a Community'),
              leading: const Icon(Icons.add),
              onTap: () => navigateToCreateCommunity(context),
            ),
            if(!isGuest)
              ref.watch(userCommunitiesProvider).when(
                data: (List<Community> communities) => Expanded(
                  child: ListView.builder(
                    itemCount: communities.length,
                    itemBuilder: (context, index) {
                      final community = communities[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            community.avatar,
                          ),
                        ),
                        title: Text('r/${community.name}'),
                        onTap: () => navigateToCommunity(context, community.name),
                      );
                    }
                  ),
                ), 
                error: (error, stackTrace) => ErrorText(message: error.toString()), 
                loading: () => const LoadingWidget(),
              ),
          ],
        ),
      ),
    );
  }
}