import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/constants.dart';
import '../../../theme/theme.dart';
import '../../auth/controller/auth_controller.dart';
import '../delegate/search_community_delegate.dart';
import '../drawers/community_list_drawer.dart';
import '../drawers/profile_drawer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  int _page = 0;

  @override
  Widget build(BuildContext context) {

    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);

    void showSearcher() {
      showSearch(
        context: context, 
        delegate: SearchCommunityDelegate(ref: ref),
      );
    }

    void openDrawer(BuildContext context) {
      Scaffold.of(context).openDrawer();
    }

    void openEndDrawer(BuildContext context) {
      Scaffold.of(context).openEndDrawer();
    }

    void onPageChange(int page) {
      setState(() => _page = page);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => openDrawer(context),
            icon: const Icon(Icons.menu),
          ),
        ),
        actions: <Widget> [
          IconButton(
            onPressed: () => showSearcher(),
            icon: const Icon(Icons.search)
          ),
          Builder(
            builder: (context) => IconButton(
              onPressed: () => openEndDrawer(context),
              icon: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(user.profilePicture),
              ),
            ),
          )
        ],
      ),
      drawer: const CommunityListDrawer(),
      endDrawer: const ProfileDrawer(),
      body: Constants.listWidgets[_page],
      bottomNavigationBar: CupertinoTabBar(
        activeColor: currentTheme.iconTheme.color,
        backgroundColor: currentTheme.appBarTheme.backgroundColor,
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '',
          ),
        ],
        currentIndex: _page,
        onTap: onPageChange,
      )
    );
  }
}