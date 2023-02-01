
import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String message;
  const ErrorText({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
      ),
    );
  }
}