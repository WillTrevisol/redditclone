import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/controller/auth_controller.dart';
import '../drawers/community_list_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final user = ref.watch(userProvider)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu),
            );
          }
        ),
        actions: <Widget> [
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.search)
          ),
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(user.profilePicture),
            ),
          )
        ],
      ),
      drawer: const CommunityListDrawer(),
      body: Center(
        child: Text(user.name),
      ),
    );
  }
}