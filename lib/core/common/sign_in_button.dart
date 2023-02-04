import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/controller/auth_controller.dart';
import '../../theme/theme.dart';
import '../constants/constants.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton({super.key, this.isFromLogin = true});

  final bool isFromLogin;

  void signInWithGoogle(BuildContext context, WidgetRef widgetRef) {
    widgetRef.read(authControllerProvider.notifier).signInWithGoole(context, isFromLogin);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isLoading = ref.watch(authControllerProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ElevatedButton.icon(
        onPressed: !isLoading ? () => signInWithGoogle(context, ref) : null, 
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          )
        ),
        icon: Image.asset(
          Constants.googleLogoPath,
          width: 35,
        ), 
        label: const Text(
          'Continue with Google',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}