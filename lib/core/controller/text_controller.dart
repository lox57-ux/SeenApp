import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextController extends GetxController {
  TextEditingController username = TextEditingController();
  TextEditingController bachelorSection = TextEditingController();
  TextEditingController preparatotyYearUniversity = TextEditingController();
  TextEditingController county = TextEditingController();
  TextEditingController transitionYearsUniversity = TextEditingController();
  TextEditingController transitionYearsCollage = TextEditingController();
  TextEditingController transitionYearsYear = TextEditingController();
  TextEditingController profileName = TextEditingController();
  TextEditingController profileLevel = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController couponController = TextEditingController();
  TextEditingController phonController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  SharedPreferences? pref;
  PackageInfo? packageInfo;
  @override
  void onInit() async {
    pref = await SharedPreferences.getInstance();

    username.text = pref!.getString('Name') ?? '';
    packageInfo = await PackageInfo.fromPlatform();
    super.onInit();
  }

  @override
  void onClose() {
    username.dispose();
    phonController.dispose();
    bachelorSection.dispose();
    preparatotyYearUniversity.dispose();
    county.dispose();
    transitionYearsUniversity.dispose();
    transitionYearsCollage.dispose();
    transitionYearsYear.dispose();
    profileName.dispose();
    profileLevel.dispose();
    codeController.dispose();
    couponController.dispose();
    noteController.dispose();
    passWordController.dispose();
  }
}
