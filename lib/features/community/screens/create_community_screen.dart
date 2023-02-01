import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/loading_widget.dart';
import '../controller/community_controller.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {

  final TextEditingController communityTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    communityTextController.dispose();
  }

  void createCommunity() {
    ref.read(communityControllerProvider.notifier).createCommunity(
      context, 
      communityTextController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    final isLoading = ref.watch(communityControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Community'),
        centerTitle: true,
      ),
      body: isLoading ? const LoadingWidget() : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
        child: Column(
          children: <Widget> [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Community name'),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: communityTextController,
              decoration: InputDecoration(
                hintText: 'r/Community',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none
                  )
                ),
                contentPadding: const EdgeInsets.all(16)
              ),
              maxLength: 21,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => createCommunity(),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ), 
              child: const Text(
                'Create Community',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}