import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:seen/Features/selectLevel/controller/select_level_controller.dart';

import 'package:seen/core/constants/TextStyles.dart';
import 'package:seen/core/functions/localDataFunctions/ActiveCoupon.dart';
import 'package:seen/main.dart';

import 'package:seen/Features/introPages/Screens/IntroLanding.dart';

import 'package:http/http.dart' as http;

import '../../../../core/Services/Network.dart';
import '../../../../core/constants/url.dart';
import '../../../../core/controller/text_controller.dart';
import '../../../../core/functions/ActiveCodeFunction.dart';
import '../../../../core/functions/QuestionFunction.dart';
import '../../../../core/functions/localDataFunctions/CurrentSession.dart';
import '../../../../core/functions/localDataFunctions/SubjectFunctions.dart';
import '../../../../core/functions/localDataFunctions/SubsubjectsFunction.dart';
import '../../../../core/functions/localDataFunctions/UserCodefunction.dart';
import '../../../../core/functions/localDataFunctions/indexedSubjectsFunction.dart';
import '../../../../core/functions/localDataFunctions/userAnswerFunction.dart';

import '../../../../shared/model/DataSource/BackgroundDataSource.dart';
import '../../../../shared/model/entites/CodeInfo.dart';
import '../../controller/CodeManagingController.dart';
import '../classes/ActiveCoupons.dart';
import '../classes/ActiveCouponsLocal.dart';
import '../classes/UserCodes.dart';
import '../classes/couponInfo.dart';

class CodeManagingDataSource {
  TextController textController = Get.find();
  static CodeManagingDataSource instance = CodeManagingDataSource();
  CodeManagingController codeManagingController = Get.find();

  Future<String?> addCoupon(int cid) async {
    int uId = textController.pref!.getInt('u_id')!;
    String token = textController.pref!.getString('token')!;
    var encodedBody =
        json.encode({"user_id": uId!, "token": token, "coupon_id": cid});

    if (await checkConnection()) {
      codeManagingController.messege.value = '';

      try {
        var response = await http.put(
            Uri.parse('${baseUrl}houdix/seen/app/coupon/apply-coupon/$uId'),
            headers: {'Content-Type': 'application/json'},
            body: encodedBody);

        String messege = jsonDecode(response.body)['message'];

        if (messege != null) {
          if (messege == 'Done!') {
            codeManagingController.icon = Icons.done;
          } else {
            codeManagingController.updateLoadingState();
            codeManagingController.icon = Icons.error_outline;
            messege == "You already have this coupon applied!"
                ? codeManagingController.messege.value =
                    "عذراً..لقد قمت بتحميله  مسبقاً"
                : codeManagingController.messege.value =
                    "عذراً..الكوبون غير موجود";
          }
          return messege;
        }
      } catch (e) {
        codeManagingController.updateLoadingState();
        Get.snackbar('حاول مجدداً',
            'الرجاء التأكد من اتصالك بالانترنت والمحاولة مرة أخرى ',
            colorText: Colors.white,
            backgroundColor: Colors.redAccent.shade200,
            duration: const Duration(milliseconds: 1500));
        throw Exception(e);
      }
    } else {
      Get.back();
      Get.defaultDialog(
        title: 'لا يوجد اتصال',
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
        titleStyle: ownStyle(Colors.red, 16.5),
        content: Text(
          'الرجاء التأكد من اتصالك بالانترنت والمحاولة مرة أخرى',
          style: ownStyle(Get.theme.primaryColor, 14.5),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Future<CouponInfo?> getCouponInfo(String content) async {
    int uId = textController.pref!.getInt('u_id')!;
    String token = textController.pref!.getString('token')!;
    var encodedBody = json.encode({
      "user_id": uId!,
      "token": token,
      "coupon_content": content.toString()
    });

    codeManagingController.updateLoadingState();
    if (await checkConnection()) {
      try {
        var response = await http.put(
            Uri.parse('${baseUrl}houdix/seen/app/coupon/get-coupon'),
            body: encodedBody,
            headers: {'Content-Type': 'application/json'});

        var data = jsonDecode(response.body);
        // codeManagingController.updateLoadingState();

        if (response.statusCode == 401) {
          List? answer = await getAllUseranswer();
          if (answer != null && answer.isNotEmpty) {
            await BackgroundDataSource.instance
                .submitAnswers(answer!)
                .then((value) {});
          } else {
            await textController.pref!.remove('token');
            await deleteAllActiveCodes();
            await deleteAllActiveCoupon();
            await deleteAllSession();
            await deleteAllIndexedSubjects();
            await deleteAllSubjects();
            await deleteAllSubSubjects();
            await clearQuestionTable();
          }
          Get.snackbar(' غير مصرح بالدخول ', ' عذراً..انتهت صلاحية الجلسة',
              colorText: Colors.white,
              backgroundColor: Colors.redAccent.shade200,
              duration: const Duration(milliseconds: 1500));
          await Future.delayed(const Duration(milliseconds: 2400));
          Get.put(SelectLevelController());
          Get.offAll(() => IntroLanding());
          return null;
        }
        if (data == {}) {
          return null;
        } else {
          if (data['message'] != null) {
            return null;
          } else {
            CouponInfo couponInfo = CouponInfo.fromJson(data);
            return couponInfo;
          }
        }
      } catch (e) {
        throw Exception(e);
      }
    } else {
      Get.back();
      Get.defaultDialog(
        barrierDismissible: true,
        onWillPop: () async {
          Get.back();
          return true;
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
        title: 'لا يوجد اتصال',
        titleStyle: ownStyle(Colors.red, 16.5),
        content: Text(
          'الرجاء التأكد من اتصالك بالانترنت والمحاولة مرة أخرى',
          textAlign: TextAlign.center,
          style: ownStyle(Get.theme.primaryColor, 14.5),
        ),
      );
      return null;
    }
  }

  Future<CodeInfo?> getCodeInfo(String content) async {
    int uId = textController.pref!.getInt('u_id')!;
    String token = textController.pref!.getString('token')!;
    var encodedBody = json.encode(
        {"user_id": uId!, "token": token, "code_content": content.toString()});

    codeManagingController.updateLoadingState();

    if (await checkConnection()) {
      try {
        var response = await http.put(
            Uri.parse('${baseUrl}houdix/seen/app/code/get-code'),
            body: encodedBody,
            headers: {'Content-Type': 'application/json'});

        if (response.statusCode == 401) {
          List? answer = await getAllUseranswer();
          if (answer != null && answer.isNotEmpty) {
            await BackgroundDataSource.instance
                .submitAnswers(answer!)
                .then((value) {});
          } else {
            await textController.pref!.remove('token');
            await deleteAllActiveCodes();
            await deleteAllActiveCoupon();
            await deleteAllSession();
            await deleteAllIndexedSubjects();
            await deleteAllSubjects();
            await deleteAllSubSubjects();
            await clearQuestionTable();
          }
          Get.snackbar(' غير مصرح بالدخول ', ' عذراً..انتهت صلاحية الجلسة',
              colorText: Colors.white,
              backgroundColor: Colors.redAccent.shade200,
              duration: const Duration(milliseconds: 1500));
          await Future.delayed(const Duration(milliseconds: 2400));
          Get.put(SelectLevelController());
          Get.offAll(() => IntroLanding());
          return null;
        }
        var data = jsonDecode(response.body);
        if (data == null) {
          return null;
        } else {
          if (data['message'] != null) {
            return null;
          } else {
            CodeInfo codeInfo = CodeInfo.fromJson(data);
            return codeInfo;
          }
        }
      } catch (e) {
        throw Exception(e);
      }
    } else {
      Get.back(closeOverlays: true);
      Get.defaultDialog(
        barrierDismissible: true,
        onWillPop: () async {
          Get.back();
          return true;
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
        title: 'لا يوجد اتصال',
        titleStyle: ownStyle(Colors.red, 16.5),
        content: Text(
          'الرجاء التأكد من اتصالك بالانترنت والمحاولة مرة أخرى',
          textAlign: TextAlign.center,
          style: ownStyle(Get.theme.primaryColor, 14.5),
        ),
      );
      return CodeInfo(id: 000);
    }
  }

  Future<String?> scanCode(String content) async {
    int uId = textController.pref!.getInt('u_id')!;
    String token = textController.pref!.getString('token')!;
    var encodedBody = json.encode(
        {"user_id": uId!, "token": token, "code_content": content.toString()});

    if (await checkConnection()) {
      try {
        codeManagingController.messege.value = '';
        var response = await http.put(
            Uri.parse('${baseUrl}houdix/seen/app/code/scan/$uId'),
            body: encodedBody,
            headers: {'Content-Type': 'application/json'});

        Map<String, dynamic>? messege = jsonDecode(response.body);

        if (messege != null) {
          if (messege['message'] == 'done') {
            codeManagingController.icon = Icons.done;
          } else {
            codeManagingController.updateLoadingState();
            codeManagingController.icon = Icons.error_outline;
            messege['message'] == "this code is not available"
                ? codeManagingController.messege.value = "عذراً..الكود غير متاح"
                : codeManagingController.messege.value =
                    "عذراً..الكود غير موجود";
          }
          return messege['message'];
        }
      } catch (e) {
        codeManagingController.updateLoadingState();
        Get.snackbar('حاول مجدداً',
            'الرجاء التأكد من اتصالك بالانترنت والمحاولة مرة أخرى',
            colorText: Colors.white,
            backgroundColor: Colors.redAccent.shade200,
            duration: const Duration(milliseconds: 1500));
        throw Exception(e);
      }
    } else {
      Get.back();
      Get.defaultDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
        title: 'لا يوجد اتصال',
        titleStyle: ownStyle(Colors.red, 16.5),
        content: Text(
          'الرجاء التأكد من اتصالك بالانترنت والمحاولة مرة أخرى',
          textAlign: TextAlign.center,
          style: ownStyle(Get.theme.primaryColor, 14.5),
        ),
      );
    }
  }

  Future<List<UserCodes>?> getUserCode() async {
    int uId = textController.pref!.getInt('u_id')!;
    String token = textController.pref!.getString('token')!;
    var encodedBody = json.encode({"user_id": uId!, "token": token});

    if (await checkConnection()) {
      try {
        var response = await http.put(
            Uri.parse('${baseUrl}houdix/seen/app/user/get-my-codes/$uId'),
            headers: {'Content-Type': 'application/json'},
            body: encodedBody);

        List<UserCodes> userCodes = (json.decode(response.body))
            .map<UserCodes>((ele) => UserCodes.fromJson(ele, false))
            .toList();
        // deleteCodes();
        List<UserCodes?>? localCodes = await getAllCodes();

        if (eq(userCodes, localCodes)) {
        } else {
          deleteCodes();
          for (UserCodes i in userCodes) {
            insertCodes(i);
          }
        }
        return userCodes;
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {}
  }

  Future<List<ActiveCoupons>?> getActiveUserCoupon() async {
    int uId = textController.pref!.getInt('u_id')!;
    String token = textController.pref!.getString('token')!;
    var encodedBody = json.encode({"user_id": uId!, "token": token});

    if (await checkConnection()) {
      try {
        var response = await http.put(
            Uri.parse('${baseUrl}houdix/seen/app/coupon/my-coupon'),
            headers: {'Content-Type': 'application/json'},
            body: encodedBody);
        print('active' + response.body);
        List<ActiveCoupons> userCoupons = (json.decode(response.body))
            .map<ActiveCoupons>((ele) => ActiveCoupons.fromJson(ele))
            .toList();
        deleteAllActiveCoupon();

        userCoupons.forEach((element) {
          element.subjects!.forEach((e) async {
            await insertActiveCoupon(ActiveCouponsLocal(
              activationDate: element.activationDate,
              expiryTime: element.expiryTime,
              name: element.name,
              subjectID: e.id,
              endDate: element.endDate,
              id: element.id,
              isActive: element.isActive,
            ));
          });
        });
        return userCoupons;
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {}
  }

  // Future<List<ActiveCodes>?> getActiveUserCode() async {
  //   int uId = textController.pref!.getInt('u_id')!;
  //   String token = textController.pref!.getString('token')!;
  //   var encodedBody = json.encode({"user_id": uId!, "token": token});

  //   if (await checkConnection()) {
  //     try {
  //       var response = await http.put(
  //           Uri.parse('${baseUrl}houdix/seen/app/code/my-code'),
  //           headers: {'Content-Type': 'application/json'},
  //           body: encodedBody);

  //       List<ActiveCodes> userCodes = (json.decode(response.body))
  //           .map<ActiveCodes>((ele) => ActiveCodes.fromJson(ele))
  //           .toList();

  //       return userCodes;
  //     } catch (e) {
  //       debugPrint(e.toString());
  //     }
  //   } else {}
  // }
}
