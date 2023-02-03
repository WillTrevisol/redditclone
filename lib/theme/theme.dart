import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class Pallete {
  // Colors
  static const blackColor = Color.fromRGBO(1, 1, 1, 1); 
  static const greyColor = Color.fromRGBO(26, 39, 45, 1);
  static const drawerColor = Color.fromRGBO(18, 18, 18, 1);
  static const whiteColor = Colors.white;
  static var redColor = Colors.red.shade500;
  static var blueColor = Colors.blue.shade300;

  // Themes
  static var darkModeAppTheme = ThemeData.dark().copyWith(
    useMaterial3: true,
    scaffoldBackgroundColor: blackColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: drawerColor,
      iconTheme: IconThemeData(
        color: whiteColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: drawerColor,
    ),
    primaryColor: redColor,
  );

  static var lightModeAppTheme = ThemeData.light().copyWith(
    useMaterial3: true,
    scaffoldBackgroundColor: whiteColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(
        color: blackColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: whiteColor,
    ),
    primaryColor: redColor,
  );
}

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier({ThemeMode themeMode = ThemeMode.dark}) 
    : _themeMode = themeMode,
    super(Pallete.darkModeAppTheme) {
      getTheme();
    }

  ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  void getTheme() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final theme = sharedPreferences.getString('theme');

    if (theme == 'light') {
      _themeMode = ThemeMode.light;
      state = Pallete.lightModeAppTheme;
    } else {
      _themeMode = ThemeMode.dark;
      state = Pallete.darkModeAppTheme;
    }

  }

  void toggleTheme() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
      state = Pallete.lightModeAppTheme;
      sharedPreferences.setString('theme', 'light');
    } else {
      _themeMode = ThemeMode.dark;
      state = Pallete.darkModeAppTheme;
      sharedPreferences.setString('theme', 'dark');
    }


  }
}