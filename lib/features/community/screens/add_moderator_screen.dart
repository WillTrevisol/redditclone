import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loading_widget.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/community_controller.dart';

class AddModeratorScreen extends ConsumerStatefulWidget {
  const AddModeratorScreen({super.key, required this.communityName});

  final String communityName;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModeratorScreenState();
}

class _AddModeratorScreenState extends ConsumerState<AddModeratorScreen> {

  Set<String> uids = {};
  int counter = 0;

  void addUid(String uid) {
    setState(() => uids.add(uid));
  }

  void removeUid(String uid) {
    setState(() => uids.remove(uid));
  }

  void saveModerators() {
    ref.read(communityControllerProvider.notifier)
      .addModerators(context, widget.communityName, uids.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget> [
          IconButton(
            onPressed: () => saveModerators(), 
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.communityName)).when(
        data: (data) => ListView.builder(
          itemCount: data.members.length,
          itemBuilder: (context, index) {
            final user = data.members[index];

            return ref.watch(getUserDataProvider(user)).when(
              data: (userData) {
                if (counter == 0) {
                  uids.addAll(data.moderators);
                }
                counter++;
                return CheckboxListTile(
                  value: uids.contains(user), 
                  onChanged: (value) => value! ? uids.add(user) : uids.remove(user),
                  title: Text('u/${userData.name}'),
                );
              },
              error: (error, stackTrace) => ErrorText(message: error.toString()), 
              loading: () => const LoadingWidget(),
            );
          },
        ), 
        error: (error, stackTrace) => ErrorText(message: error.toString()), 
        loading: () => const LoadingWidget(),
      ),
    );
  }
}