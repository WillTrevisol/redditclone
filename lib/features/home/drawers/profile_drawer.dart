import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../theme/theme.dart';
import '../../auth/controller/auth_controller.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final user = ref.watch(userProvider)!;

    Future<void> logOut(WidgetRef ref) async {
      await ref.read(authControllerProvider.notifier).logOut();
    }

    void navigateToUserProfile(BuildContext context, String uid) {
      Routemaster.of(context).push('u/$uid');
    }

    void toggleTheme(WidgetRef ref) {
      ref.read(themeNotifierProvider.notifier).toggleTheme();
    }

    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget> [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.32,
              child: DrawerHeader(
                child: Column(
                  children: <Widget> [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePicture),
                      radius: 70,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'u/${user.name}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person) ,
              title: const  Text('My Profile'),
              onTap: () => navigateToUserProfile(context, user.uid),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Pallete.redColor,
              ) ,
              title: const  Text('Logout'),
              onTap: () => logOut(ref),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                AnimatedToggleSwitch.dual(
                  current: ref.watch(themeNotifierProvider.notifier).themeMode == ThemeMode.dark, 
                  first: false, 
                  second: true,
                  dif: 25,
                  height: 50,
                  borderColor: Colors.transparent,
                  onChanged: (bool value) => toggleTheme(ref),
                  iconBuilder: (bool value) => value 
                  ? const Icon(
                    Icons.dark_mode_rounded,
                    color: Pallete.blackColor,
                  ) 
                  : const Icon(
                    Icons.light_mode_rounded,
                    color: Pallete.whiteColor,
                  ),
                  colorBuilder: (bool value) => value ? Pallete.whiteColor.withAlpha(200) : Pallete.greyColor.withAlpha(200),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}