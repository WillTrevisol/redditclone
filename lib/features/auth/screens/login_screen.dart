import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/auth_controller.dart';
import '../../../core/common/loading_widget.dart';
import '../../../core/common/sign_in_button.dart';
import '../../../core/constants/constants.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});


  void signInAsGuest(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInAsGuest(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          Constants.logoPath,
          height: 40,
        ),
        // actions: <Widget> [
        //   TextButton(
        //     onPressed: () => signInAsGuest(context, ref),
        //     child: const Text(
        //       'Skip',
        //       style: TextStyle(
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   )
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget> [
            const SizedBox(height: 30),
            const Text(
              'Dive into anything',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 30),
            isLoading 
              ? const SizedBox(
                  height: 400,
                  child: LoadingWidget(),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    Constants.loginEmotePath, 
                    height: 400,
                ),
              ),
            const SizedBox(height: 20),
            const SignInButton(),
          ],
        ),
      ),
    );
  }
}