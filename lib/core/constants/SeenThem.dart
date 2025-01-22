import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seen/core/constants/Colors.dart';

class SeenTheme {
  static lightTheme() => ThemeData(
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: SeenColors.lightBackground,
      ),
      scaffoldBackgroundColor: SeenColors.lightBackground,
      brightness: Brightness.light,
      primaryColor: SeenColors.mainColor,
      canvasColor: SeenColors.lightBackground,
      indicatorColor: SeenColors.iconColor,
      cardTheme: CardTheme(
          surfaceTintColor: Colors.transparent,
          elevation: 1,
          color: Colors.white,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r))),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: SeenColors.mainColor),
      cardColor: Colors.white);

  static darkTheme() => ThemeData(
      appBarTheme: const AppBarTheme(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: SeenColors.splashBackgroundDark,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: SeenColors.splashBackgroundDark,
      brightness: Brightness.dark,
      primaryColor: SeenColors.darkMainColor,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: SeenColors.darkMainColor),
      canvasColor: SeenColors.splashBackgroundDark,
      cardTheme: CardTheme(
          surfaceTintColor: Colors.transparent,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r))),
      indicatorColor: SeenColors.iconColor,
      cardColor: SeenColors.cardDark);
}
