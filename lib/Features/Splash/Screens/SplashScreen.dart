import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:seen/Features/Splash/InitialNavigationController/SplachScreenController.dart';
import 'package:seen/core/constants/Colors.dart';

import '../../../core/controller/theme_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  ThemeController themeController = Get.find();
  NavigationController navigationController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: AnimatedSplashScreen(
        splashIconSize: 140.w,
        splash: themeController.isDarkMode.value
            ? 'assets/Splash&intro/Group (1).png'
            : 'assets/Splash&intro/SplashLight.png',
        duration: 2500,
        backgroundColor: themeController.isDarkMode.value
            ? SeenColors.splashBackgroundDark
            : SeenColors.splashBackgroundLight,
        nextScreen: navigationController.home!,
        splashTransition: SplashTransition.slideTransition,
      )),
    );
  }
}
