import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import 'features/community/screens/add_moderator_screen.dart';
import 'features/community/screens/community_screen.dart';
import 'features/community/screens/create_community_screen.dart';
import 'features/community/screens/edit_community_screen.dart';
import 'features/community/screens/moderator_tools_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/auth/screens/login_screen.dart';

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
});