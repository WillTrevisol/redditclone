import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import 'features/community/screens/create_community_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/auth/screens/login_screen.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (RouteData route) => const MaterialPage(child: LoginScreen())
});

final loggedInRoute = RouteMap(routes: {
  '/': (RouteData route) => const MaterialPage(child: HomeScreen()),
  '/create-community': (RouteData route) => const MaterialPage(child: CreateCommunityScreen()),
});