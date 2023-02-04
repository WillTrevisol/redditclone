import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/comment.dart';

class CommentCard extends ConsumerWidget {
  const CommentCard({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Column(
        children: <Widget> [
          Row(
            children: <Widget> [
              CircleAvatar(
                backgroundImage: NetworkImage(comment.userProfilePicture),
                radius: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    Text(
                      'u/${comment.userName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      comment.text,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: <Widget> [
              IconButton(
                onPressed: () {}, 
                icon: const Icon(Icons.reply),
              ),
              const Text('Reply'),
            ],
          ),
        ],
      ),
    );
  }
}