import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import 'features/community/screens/add_moderator_screen.dart';
import 'features/community/screens/community_screen.dart';
import 'features/community/screens/create_community_screen.dart';
import 'features/community/screens/edit_community_screen.dart';
import 'features/community/screens/moderator_tools_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/posts/screens/add_post_type_screen.dart';
import 'features/posts/screens/comment_screen.dart';
import 'features/user_profile/screens/edit_profile_screen.dart';
import 'features/user_profile/screens/user_profile_screen.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (RouteData route) => const MaterialPage(child: LoginScreen())
});

final loggedInRoute = RouteMap(routes: {
  '/': (RouteData route) => const MaterialPage(child: HomeScreen()),
  '/create-community': (RouteData route) => const MaterialPage(child: CreateCommunityScreen()),
  '/r/:name': (RouteData route) => MaterialPage(child: CommunityScreen(name: route.pathParameters['name']!)),
  '/moderator-tools/:name': (RouteData route) => MaterialPage(child: ModeratorToolsScreen(name: route.pathParameters['name']!)),
  '/edit-community/:name': (RouteData route) => MaterialPage(child: EditCommunityScreen(name: route.pathParameters['name']!)),
  '/add-moderators/:name': (RouteData route) => MaterialPage(child: AddModeratorScreen(communityName: route.pathParameters['name']!)),
  '/u/:uid': (RouteData route) => MaterialPage(child: UserProfileScreen(uid: route.pathParameters['uid']!)),
  '/edit-profile/:uid': (RouteData route) => MaterialPage(child: EditProfileScreen(uid: route.pathParameters['uid']!)),
  '/add-post/:type': (RouteData route) => MaterialPage(child: AddPostTypeScreen(type: route.pathParameters['type']!)),
  '/post/:postId/comments': (RouteData route) => MaterialPage(child: CommentScreen(postId: route.pathParameters['postId']!)), 
});