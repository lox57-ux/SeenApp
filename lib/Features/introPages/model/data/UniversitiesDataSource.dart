import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/Services/Network.dart';
import '../../../../core/constants/TextStyles.dart';
import '../../../../core/constants/url.dart';
import '../classes/AuthResponse.dart';
import '../classes/Years.dart';
import '../classes/bachelorTypes.dart';

class UniversitiesDataSource {
  static UniversitiesDataSource instace = UniversitiesDataSource();
  Future<List<University>> getAllUniversities() async {
    SharedPreferences? prefrences = await SharedPreferences.getInstance();
    int uId = prefrences!.getInt('u_id')!;
    String token = prefrences!.getString('token')!;
    var encodedBody = json.encode({"token": token});
    if (await checkConnection()) {
      try {
        var response = await http.put(
          Uri.parse(
              '${baseUrl}houdix/seen/app/university/get-universities/$uId'),
          body: encodedBody,
          headers: {'Content-Type': 'application/json'},
        );

        List<University> subSubjects = (json.decode(response.body))
            .map<University>((ele) => University.fromJson(ele))
            .toList();

        return subSubjects;
      } catch (e) {
        throw Exception(e);
      }
    } else {
      // Get.defaultDialog(
      //   contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
      //   title: 'لا يوجد اتصال',
      //   titleStyle: ownStyle(Colors.red, 16.5),
      //   content: Text(
      //     'الرجاء التاكد من اتصالك والمحاولة مرة اخرى',
      //     textAlign: TextAlign.center,
      //     style: ownStyle(Get.theme.primaryColor, 14.5),
      //   ),
      // );
      return [];
    }
  }

  Future<List<Collage>> getCollageOfUniversity(int uniID) async {
    if (await checkConnection()) {
      try {
        var response = await http.get(Uri.parse(
            '${baseUrl}houdix/seen/app/collage/get-collages-of-university/$uniID'));

        List<Collage> collages = (json.decode(response.body))
            .map<Collage>((ele) => Collage.fromJson(ele))
            .toList();

        return collages;
      } catch (e) {
        throw Exception(e);
      }
    } else {
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
      return [];
    }
  }

  Future<List<Years>> getYearsOfCollage(int collageID) async {
    if (await checkConnection()) {
      try {
        var response = await http.get(Uri.parse(
            '${baseUrl}houdix/seen/app/year/get-years-of-collage/$collageID'));

        List<Years> years = (json.decode(response.body))
            .map<Years>((ele) => Years.fromJson(ele))
            .toList();

        return years;
      } catch (e) {
        throw Exception(e);
      }
    } else {
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
      return [];
    }
  }

  Future<List<BachelorType>> getbachelorsTypes() async {
    SharedPreferences? prefrences = await SharedPreferences.getInstance();
    int uId = prefrences!.getInt('u_id')!;
    String token = prefrences!.getString('token')!;
    var encodedBody = json.encode({"token": token});
    if (await checkConnection()) {
      try {
        var response = await http.put(
          Uri.parse('${baseUrl}houdix/seen/app/bachelors/$uId'),
          body: encodedBody,
          headers: {'Content-Type': 'application/json'},
        );

        List<BachelorType> bachelorTypes = (json.decode(response.body))
            .map<BachelorType>((ele) => BachelorType.fromJson(ele))
            .toList();

        return bachelorTypes;
      } catch (e) {
        throw Exception(e);
      }
    } else {
      // Get.defaultDialog(
      //   contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
      //   title: 'لا يوجد اتصال',
      //   titleStyle: ownStyle(Colors.red, 16.5),
      //   content: Text(
      //     'الرجاء التاكد من اتصالك والمحاولة مرة اخرى',
      //     textAlign: TextAlign.center,
      //     style: ownStyle(Get.theme.primaryColor, 14.5),
      //   ),
      // );
      return [];
    }
  }
}
