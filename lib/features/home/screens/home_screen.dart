import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/controller/auth_controller.dart';
import '../delegate/search_community_delegate.dart';
import '../drawers/community_list_drawer.dart';
import '../drawers/profile_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final user = ref.watch(userProvider)!;

    void showSearcher() {
      showSearch(
        context: context, 
        delegate: SearchCommunityDelegate(ref: ref),
      );
    }

    void openDrawer(BuildContext context) {
      Scaffold.of(context).openDrawer();
    }

    void openEndDrawer(BuildContext context) {
      Scaffold.of(context).openEndDrawer();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => openDrawer(context),
            icon: const Icon(Icons.menu),
          ),
        ),
        actions: <Widget> [
          IconButton(
            onPressed: () => showSearcher(),
            icon: const Icon(Icons.search)
          ),
          Builder(
            builder: (context) => IconButton(
              onPressed: () => openEndDrawer(context),
              icon: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(user.profilePicture),
              ),
            ),
          )
        ],
      ),
      drawer: const CommunityListDrawer(),
      endDrawer: const ProfileDrawer(),
      body: Center(
        child: Text(user.name),
      ),
    );
  }
}