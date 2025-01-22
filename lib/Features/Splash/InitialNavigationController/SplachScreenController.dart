import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:seen/Features/Sections/Screens/ChooseSubject.dart';
import 'package:seen/Features/introPages/Screens/IntroLanding.dart';
import 'package:seen/Features/selectLevel/Screens/select_level.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/Date/NotValidDate.dart';
import '../../update/UpdateScreen.dart';
import '../../selectLevel/controller/select_level_controller.dart';

class NavigationController extends GetxController {
  late Widget home;
  Future<Widget?> initialNavigate() async {
    final pref = await SharedPreferences.getInstance();

    if (pref.getBool('update') != null && pref.getBool('update')!) {
      home = const UpdateSceen();
    } else if ((pref.getString('Name') == null ||
            pref.getString('token') == null) ||
        (pref.getString('Name') == null && pref.getString('token') == null)) {
      Get.lazyPut(() => SelectLevelController());

      home = const IntroLanding();
    } else if (pref.getString('section') == null) {
      Get.lazyPut(() => SelectLevelController());

      home = SelectLevel();
    } else {
      home = ChooseSubject();
    }
    return null;
  }

  @override
  void onInit() async {
    initialNavigate();
    super.onInit();
  }
}
