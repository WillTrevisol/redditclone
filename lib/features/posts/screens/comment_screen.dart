import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loading_widget.dart';
import '../../../core/common/post_card.dart';
import '../controller/post_controller.dart';
import '../widgets/comment_card.dart';

class CommentScreen extends ConsumerStatefulWidget {
  const CommentScreen({super.key, required this.postId});

  final String postId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {

  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment() {
    ref.read(postControllerProvider.notifier).addComment(
      context: context, 
      text: commentController.text.trim(), 
      postId: widget.postId,
    );

    setState(() => commentController.text = '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
        data: (data) {
          return Column(
            children: <Widget> [
              PostCard(post: data),
              TextField(
                onSubmitted: (value) => addComment(),
                controller: commentController,
                decoration: InputDecoration(
                  hintText: 'Put your comments here :)',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none
                    )
                  ),
                  contentPadding: const EdgeInsets.all(18)
                ),
              ),
              ref.watch(getPostCommentsProvider(widget.postId)).when(
                data: (data) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return CommentCard(comment: data[index]);
                      },
                    ),
                  );
                }, 
                error: (error, stackTrace) => ErrorText(message: error.toString()),
                loading: () => const LoadingWidget(),
              ),
            ],
          );
        }, 
        error: (error, stackTrace) => ErrorText(message: error.toString()), 
        loading: () => const LoadingWidget(),
      ),
    );
  }
}