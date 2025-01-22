import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seen/core/functions/QuestionFunction.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/url.dart';

import '../classes/WrongAnswer.dart';

class WrongAnswerDataSource {
  // WrongAnswersCotroller wrongAnswersCotroller = Get.find();
  // TextController textController = Get.find();
  static WrongAnswerDataSource instace = WrongAnswerDataSource();
  Future<List<WrongAnswer>?> getAllWrongAnswers() async {
    var pref = await SharedPreferences.getInstance();
    int uId = pref.getInt('u_id')!;
    String token = pref.getString('token')!;

    var encodedBody = json.encode({"user_id": uId!, "token": token});
    try {
      List<int> qId = [];
      var response = await http.put(
          Uri.parse(
              '${baseUrl}houdix/seen/app/user-answer/get-wrong-answers/$uId'),
          headers: {'Content-Type': 'application/json'},
          body: encodedBody);

      List<WrongAnswer> wronAnswers =
          jsonDecode(response.body).map<WrongAnswer>((ele) {
        qId.add(ele['answer']['question_id']);
        return WrongAnswer.fromJson(ele);
      }).toList();

      qId.forEach((element) async {
        updateBackGroundWrongness(element);
      });
      return wronAnswers;
    } catch (e) {
      return <WrongAnswer>[];
    }
  }

  Future<List<WrongAnswer>> getWrongAnswersForSubSubject(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int uId = sharedPreferences!.getInt('u_id')!;
    String token = sharedPreferences!.getString('token')!;
    var encodedBody = json.encode({"user_id": uId!, "token": token});
    try {
      var response = await http.put(
          Uri.parse(
              '${baseUrl}houdix/seen/app/user-answer/get-wrong-answers-of-sub-subject/$uId'),
          headers: {'Content-Type': 'application/json'},
          body: encodedBody);
      List<WrongAnswer> wronAnswers = jsonDecode(response.body)
          .map<WrongAnswer>((ele) => WrongAnswer.fromJson(ele))
          .toList();

      return wronAnswers;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<WrongAnswer>> getWrongAnswersForSubject(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int uId = sharedPreferences!.getInt('u_id')!;
    String token = sharedPreferences!.getString('token')!;
    var encodedBody = json.encode({"subject_id": id!, "token": token});
    try {
      var response = await http.put(
          Uri.parse(
              '${baseUrl}houdix/seen/app/user-answer/get-wrong-answers-of-subject/$uId'),
          headers: {'Content-Type': 'application/json'},
          body: encodedBody);
      print(response.body);
      List<int> qId = [];
      List<WrongAnswer> wronAnswers =
          jsonDecode(response.body).map<WrongAnswer>((ele) {
        qId.add(ele['answer']['question_id']);
        return WrongAnswer();
      }).toList();

      qId.forEach((element) async {
        updateBackGroundWrongness(element);
      });
      return wronAnswers;
    } catch (e) {
      throw Exception(e);
    }
  }
}
