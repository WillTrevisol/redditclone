import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModeratorToolsScreen extends StatelessWidget {

  final String name;
  const ModeratorToolsScreen({super.key, required this.name});

  void navigateToEditCommunityScren(BuildContext context) {
    Routemaster.of(context).push('/edit-community/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moderator Tools'),
      ),
      body: Column(
        children: <Widget> [
          ListTile(
            leading: const Icon(Icons.add_moderator),
            title: const Text('Add Moderators'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Community'),
            onTap: () => navigateToEditCommunityScren(context),
          ),
        ],
      ),
    );
  }
}