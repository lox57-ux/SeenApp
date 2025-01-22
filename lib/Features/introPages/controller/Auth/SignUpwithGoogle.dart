import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:seen/Features/introPages/model/classes/AuthResponse.dart';

import 'package:seen/Features/Sections/Screens/ChooseSubject.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../model/data/UsersDataSource.dart';
import '../../../../core/controller/text_controller.dart';

class GoogleSignUpController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isGoogleSign = true.obs;
  RxBool isopeningSign = true.obs;
  RxBool isObsecur = true.obs;
  RxBool phoneAndpassAdded = false.obs;

  AuthResponse? authResponse;
  Future sighnUp(
      String? name, String phone, String? sex, String? passWord) async {
    final storage = await SharedPreferences.getInstance();

    authResponse = await UserDataSource.instance.sighnUp({
      "user_fullname": name,
      "user_phonenumber": phone,
      "user_password": passWord,
      "user_username": name,
      "sex": sex
    }).then((value) async {
      // await storage.setInt('u_id', 1);
      // await storage.setString('imageUrl', value.userImage ?? '');
      // await storage.setString(
      //     'Name', value.userFullname ?? googleUser.displayName!);
      if (value != null && value.messege == null) {
        authResponse = value;
        //
        await storage.setString('token', value.userToken!);
        await storage.setInt('u_id', value.id!);
        await storage.setString('imageUrl', value.userImage ?? '');
        await storage.setString('Name', name!);
        await storage.setString('fullName', value.userFullname ?? name);
        TextController textController = Get.find();
        textController.username.text = name;
        if (value.userType == 'none') {
          await storage.setString('imageUrl', value.userImage ?? '');
          await storage.setString('Name', value.userFullname ?? '');
          phoneAndpassAdded.value = true;

          isLoading.value = false;
        } else {
          await storage.setString('imageUrl', value.userImage ?? '');
          await storage.setString('Name', value.userFullname ?? '');
          storage.setString('gender', value.sex == 'male' ? 'ذكر' : "أنثى");
          storage.setString('phoneNumber', value.userPhonenumber ?? '');
          if (value.userType == 'bachelorean') {
            await storage.setString('section', "بكالوريا");
            await storage.setInt('bSection', value.bachelorean!.bachelorId!);
          } else {
            await storage.setString(
                'section',
                value.student!.year!.yearName == 'تحضيرية'
                    ? "السنة التحضيرية"
                    : value.student!.year!.yearName == 'سادسة'
                        ? 'السنة السادسة'
                        : 'السنوات الانتقالية');
            await storage.setInt(
                'university', value.student!.year!.collage!.universityId!);
            await storage.setInt(
                'collageId', value.student!.year!.collage!.id!);
            await storage.setInt('yearID', value.student!.year!.id!);
            await storage.setInt('subjectYearID', value.subjectYear!);
          }
          //  Get.offAndToNamed(SelectLevel.routeName);
          Get.offAndToNamed(ChooseSubject.routeName);
        }
      } else if (value == null) {
        isLoading.value = false;
        Get.snackbar('حاول مجدداً ', ' عذراً ..حدث خطأ ',
            colorText: Colors.white,
            backgroundColor: Colors.redAccent.shade200,
            duration: const Duration(milliseconds: 1500));
      } else {
        isLoading.value = false;
        if (value.messege == 'Not Authorized!') {
        } else if (value.messege == 'this username is not available') {
          Get.snackbar(' اسم المستخدم موجود مسبقاً ',
              ' الرجاء ..تسجيل الدخول أو استخدام اسم آخر ',
              colorText: Colors.white,
              backgroundColor: Colors.redAccent.shade200,
              duration: const Duration(milliseconds: 1500));
        } else {
          Get.snackbar('حاول مجدداً ', ' عذراً ..حدث خطأ ',
              colorText: Colors.white,
              backgroundColor: Colors.redAccent.shade200,
              duration: const Duration(milliseconds: 1500));
        }
      }
      return null;
    });

    update();
  }

  Future sighnIn(String name, String? passWord) async {
    final storage = await SharedPreferences.getInstance();
    UserDataSource.instance.logIn(
        {"user_username": name, "user_password": passWord}).then((value) async {
      if (value != null && value.messege == null) {
        authResponse = value;
        //
        await storage.setString('token', value.userToken!);
        await storage.setInt('u_id', value.id!);
        await storage.setString('imageUrl', value.userImage ?? '');
        await storage.setString('fullName', value.userFullname ?? name);

        storage.setString('gender', value.sex == 'male' ? 'ذكر' : "أنثى");
        storage.setString('phoneNumber', value.userPhonenumber ?? '');
        if (value.userType == 'bachelorean') {
          await storage.setString('section', "بكالوريا");
          await storage.setInt('bSection', value.bachelorean!.bachelorId!);
        } else {
          await storage.setString(
              'section',
              value.student!.year!.yearName == 'تحضيرية'
                  ? "السنة التحضيرية"
                  : value.student!.year!.yearName == 'السادسة'
                      ? 'السنة السادسة'
                      : 'السنوات الانتقالية');
          await storage.setInt(
              'university', value.student!.year!.collage!.universityId!);
          await storage.setInt('collageId', value.student!.year!.collage!.id!);
          await storage.setInt('yearID', value.student!.year!.id!);
          await storage.setInt('subjectYearID', value.subjectYear!);
        }
        //  Get.offAndToNamed(SelectLevel.routeName);
        Get.offAndToNamed(ChooseSubject.routeName);
      } else if (value == null) {
        isLoading.value = false;
        Get.snackbar(
            'حاول مجدداً ', ' عذراً ..كلمة السر واسم المستخدم غير متطابقين  ',
            colorText: Colors.white,
            backgroundColor: Colors.redAccent.shade200,
            duration: const Duration(milliseconds: 1500));
      } else {
        isLoading.value = false;
        if (value.messege == 'wrong password') {
          Get.snackbar('   كلمة المرور خاطئة    ', 'عذراً.. حاول مجدداً ',
              colorText: Colors.white,
              backgroundColor: Colors.redAccent.shade200,
              duration: const Duration(milliseconds: 1500));
        } else {
          Get.snackbar('  تأكد من اسم المستخدم  ', 'عذراً.. حاول مجدداً ',
              colorText: Colors.white,
              backgroundColor: Colors.redAccent.shade200,
              duration: const Duration(milliseconds: 1500));
        }
      }
    });
  }
}
