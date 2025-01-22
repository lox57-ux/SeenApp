import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:seen/Features/selectLevel/controller/select_level_controller.dart';
import 'package:seen/Features/introPages/model/classes/AuthResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/Auth/SignUpwithGoogle.dart';

import '../../../../core/constants/url.dart';
import 'package:http/http.dart' as http;

class UserDataSource {
  static UserDataSource instance = UserDataSource();
  GoogleSignUpController googleSignUpController = Get.find();
  SelectLevelController selectLevelController = Get.find();
  Future<AuthResponse?> sighnUp(Map<String, dynamic> credentials) async {
    var encodedBody = json.encode(credentials);

    try {
      var response = await http.post(
          Uri.parse('${baseUrl}houdix/seen/app/user/sign-up'),
          headers: {'Content-Type': 'application/json'},
          body: encodedBody);

      // var decodedResponse = jsonDecode(response.body);

      AuthResponse? auth;
      if (response.statusCode == 401) {
        Get.snackbar(' غير مصرح بالدخول ', ' عذراً..انتهت صلاحية الجلسة',
            colorText: Colors.white,
            backgroundColor: Colors.redAccent.shade200,
            duration: const Duration(milliseconds: 1500));
        auth = AuthResponse.fromJson(jsonDecode(response.body));
        googleSignUpController.isLoading.value = false;
      } else if (response.statusCode == 200) {
        auth = AuthResponse.fromJson(jsonDecode(response.body));
      }

      return auth;
    } catch (e) {
      googleSignUpController.isLoading.value = false;
      Get.snackbar('حاول مجدداً ', ' عذراً ..حدث خطأ ',
          colorText: Colors.white,
          backgroundColor: Colors.redAccent.shade200,
          duration: const Duration(milliseconds: 1500));
      throw Exception(e);
    }
  }

  Future<AuthResponse?> logIn(Map<String, dynamic> credentials) async {
    var encodedBody = json.encode(credentials);

    try {
      print(encodedBody);
      var response = await http.post(
          Uri.parse('${baseUrl}houdix/seen/app/user/sign-in'),
          headers: {'Content-Type': 'application/json'},
          body: encodedBody);

      // var decodedResponse = jsonDecode(response.body);
      print(response.body);
      AuthResponse? auth;
      if (response.statusCode == 401) {
        Get.snackbar(' غير مصرح بالدخول ', ' عذراً..انتهت صلاحية الجلسة',
            colorText: Colors.white,
            backgroundColor: Colors.redAccent.shade200,
            duration: const Duration(milliseconds: 1500));
        auth = AuthResponse.fromJson(jsonDecode(response.body));
        googleSignUpController.isLoading.value = false;
      } else if (response.statusCode == 200) {
        auth = AuthResponse.fromJson(jsonDecode(response.body));
      }

      return auth;
    } catch (e) {
      googleSignUpController.isLoading.value = false;
      Get.snackbar('حاول مجدداً ',
          'الرجاء التأكد من اتصالك بالانترنت والمحاولة مرة أخرى',
          colorText: Colors.white,
          backgroundColor: Colors.redAccent.shade200,
          duration: const Duration(milliseconds: 1500));
      throw Exception(e);
    }
  }

  Future<AuthResponse> addpersonalInfo(
      Map<String, dynamic> info, int id) async {
    var encodedBody = json.encode(info);
    selectLevelController.isloading.value = true;
    try {
      var response = await http.put(
          Uri.parse('${baseUrl}houdix/seen/app/user/create-account/$id'),
          headers: {'Content-Type': 'application/json'},
          body: encodedBody);
      selectLevelController.isloading.value = false;
      return AuthResponse();
    } catch (e) {
      selectLevelController.isloading.value = false;
      Get.snackbar('حاول مجدداً ', ' عذراً ..حدث خطأ ',
          colorText: Colors.white,
          backgroundColor: Colors.redAccent.shade200,
          duration: const Duration(milliseconds: 1500));
      throw Exception(e);
    }
  }

  Future<AuthResponse> addbachelore(Map<String, dynamic> info, var id) async {
    var encodedBody = jsonEncode(info);
    try {
      print(info);
      var response = await http.post(
          Uri.parse(
              '${baseUrl}houdix/seen/app/bachelorean/add-bachelorean/$id'),
          headers: {'Content-Type': 'application/json'},
          body: encodedBody);
      print('sacccccccccccccccccccccccccccc');
      print(response.body);
      print('sacccccccccccccccccccccccccccc');
      AuthResponse auth = AuthResponse.fromJson(jsonDecode(response.body));
      return auth;
    } catch (e) {
      selectLevelController.isloading.value = false;
      Get.snackbar('حاول مجدداً ', ' عذراً ..حدث خطأ ',
          colorText: Colors.white,
          backgroundColor: Colors.redAccent.shade200,
          duration: const Duration(milliseconds: 1500));
      throw Exception(e);
    }
  }

  Future<AuthResponse> addStudent(Map<String, dynamic> info, var id) async {
    var encodedBody = jsonEncode(info);
    try {
      var response = await http.post(
          Uri.parse('${baseUrl}houdix/seen/app/student/add-student/$id'),
          headers: {'Content-Type': 'application/json'},
          body: encodedBody);
      var data = jsonDecode(response.body);
      AuthResponse auth;
      if (data['message'] == null) {
        auth = AuthResponse.fromJson(data);
      } else {
        auth = AuthResponse.fromJson(data);
      }

      return auth;
    } catch (e) {
      selectLevelController.isloading.value = false;
      Get.snackbar('حاول مجدداً ', ' عذراً ..حدث خطأ ',
          colorText: Colors.white,
          backgroundColor: Colors.redAccent.shade200,
          duration: const Duration(milliseconds: 1500));
      throw Exception(e);
    }
  }

  Future<String?> updateUser(Map<String, dynamic> info, int id) async {
    var encodedBody = json.encode(info);
    selectLevelController.isloading.value = true;
    try {
      var response = await http.put(
          Uri.parse('${baseUrl}houdix/seen/app/user/update-user/$id'),
          headers: {'Content-Type': 'application/json'},
          body: encodedBody);
      selectLevelController.isloading.value = false;

      return json.decode(response.body)['message'];
    } catch (e) {
      selectLevelController.isloading.value = false;
      Get.snackbar('حاول مجدداً ',
          'الرجاء التأكد من اتصالك بالانترنت والمحاولة مرة أخرى',
          colorText: Colors.white,
          backgroundColor: Colors.redAccent.shade200,
          duration: const Duration(milliseconds: 1500));
      throw Exception(e);
    }
  }

  Future<String?> updateUserType(Map<String, dynamic> info, int id) async {
    var encodedBody = json.encode(info);
    selectLevelController.isloading.value = true;
    try {
      var response = await http.put(
          Uri.parse('${baseUrl}houdix/seen/app/user/update-user/$id'),
          headers: {'Content-Type': 'application/json'},
          body: encodedBody);
      selectLevelController.isloading.value = false;

      return json.decode(response.body)['message'];
    } catch (e) {
      Get.snackbar('حاول مجدداً ', ' عذراً ..حدث خطأ ',
          colorText: Colors.white,
          backgroundColor: Colors.redAccent.shade200,
          duration: const Duration(milliseconds: 1500));
      throw Exception(e);
    }
  }

  Future<String?>? onUploadImage(File selectedImage) async {
    var pref = await SharedPreferences.getInstance();
    int uId = pref.getInt('u_id')!;
    String token = pref.getString('token')!;
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${baseUrl}houdix/seen/app/user/add-image/$uId'),
    );
    request.fields['token'] = token;
    Map<String, String> headers = {"Content-type": "multipart/form-data"};

    request.files.add(
      http.MultipartFile(
        'image',
        selectedImage.readAsBytes().asStream(),
        selectedImage.lengthSync(),
        filename: selectedImage.path.split('/').last,
      ),
    );
    request.headers.addAll(headers);

    var res = await request.send();

    http.Response response = await http.Response.fromStream(res);

    return jsonDecode(response.body)['user_image'];
  }
}
