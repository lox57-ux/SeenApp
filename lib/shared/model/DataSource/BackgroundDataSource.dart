import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:seen/core/functions/ActiveCodeFunction.dart';
import 'package:seen/core/functions/localDataFunctions/ActiveCoupon.dart';
import 'package:seen/core/functions/localDataFunctions/CurrentSession.dart';
import 'package:seen/core/functions/localDataFunctions/SubjectFunctions.dart';
import 'package:seen/core/functions/localDataFunctions/SubsubjectsFunction.dart';
import 'package:seen/core/functions/localDataFunctions/indexedSubjectsFunction.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/Services/Network.dart';
import '../../../core/constants/url.dart';
import '../../../core/functions/QuestionFunction.dart';
import '../../../core/functions/localDataFunctions/userAnswerFunction.dart';

class BackgroundDataSource {
  static BackgroundDataSource instance = BackgroundDataSource();
  Future<void> submitAnswers(List answer) async {
    var pref = await SharedPreferences.getInstance();
    int uId = pref.getInt('u_id')!;
    String token = pref.getString('token')!;
    var encodedBody =
        jsonEncode({"user_id": uId!, "token": token, "answers": answer});
    try {
      var response = await http.post(
          Uri.parse(
              '${baseUrl}houdix/seen/app/user-answer/submit-answers/$uId'),
          headers: {'Content-Type': 'application/json'},
          body: encodedBody);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        deleteAllUserAnswer();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> submitFavorites(List fav) async {
    var pref = await SharedPreferences.getInstance();
    int uId = pref.getInt('u_id')!;
    String token = pref.getString('token')!;
    //"user_id": uId!, "token": token,
    var encodedBody = jsonEncode({"ids": fav, "token": token});
    try {
      var response = await http.post(
          Uri.parse('${baseUrl}houdix/seen/app/favorite/sync-favorites/$uId'),
          headers: {'Content-Type': 'application/json'},
          body: encodedBody);
      var data = jsonDecode(response.body);
      print("########################");
      print(data);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List?> submitNotesFavorites(List? fav, List? notes) async {
    var pref = await SharedPreferences.getInstance();
    int uId = pref.getInt('u_id')!;
    String token = pref.getString('token')!;
    //"user_id": uId!, "token": token,
    var encodedBody = jsonEncode({"ids": fav, "notes": notes, "token": token});
    try {
      print(encodedBody);
      var response = await http.put(
          Uri.parse(
              '${baseUrl}houdix/seen/app/user/fused-sync-notes-favorites/$uId'),
          headers: {'Content-Type': 'application/json'},
          body: encodedBody);
      print(response.body);
      var data = jsonDecode(response.body).map((e) {
        return e['question_id'];
      }).toList();

      print(data);
      return data;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<dynamic>?> getFavorites() async {
    var pref = await SharedPreferences.getInstance();
    int uId = pref.getInt('u_id')!;
    String token = pref.getString('token')!;
    //"user_id": uId!, "token": token,
    var encodedBody = jsonEncode({"token": token});
    try {
      var response = await http.put(
          Uri.parse(
              '${baseUrl}houdix/seen/app/favorite/get-favorites-of-user/$uId'),
          headers: {'Content-Type': 'application/json'},
          body: encodedBody);
      List? data = jsonDecode(response.body);
      if (data != null && data.isNotEmpty) {
        data.forEach((element) async {
          await addRemoveFavorites(element['question_id'], 1);
        });
      }

      return data ?? [];
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<dynamic>?> getSubjectFavorites(int? id) async {
    var pref = await SharedPreferences.getInstance();
    int uId = pref.getInt('u_id')!;
    String token = pref.getString('token')!;
    //"user_id": uId!, "token": token,
    var encodedBody = jsonEncode({"token": token, 'subject_id': id});
    try {
      var response = await http.put(
          Uri.parse(
              '${baseUrl}houdix/seen/app/user/get-user-one-subject-favorites/$uId'),
          headers: {'Content-Type': 'application/json'},
          body: encodedBody);
      List? data = jsonDecode(response.body);
      if (data != null && data.isNotEmpty) {
        data.forEach((element) async {
          await addRemoveFavorites(element['question_id'], 1);
        });
      }

      return data ?? [];
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String?> submitNote(List note) async {
    var pref = await SharedPreferences.getInstance();
    int uId = pref.getInt('u_id')!;
    String token = pref.getString('token')!;

    var encodedBody =
        json.encode({"user_id": uId!, "token": token, "notes": note});

    if (note.isNotEmpty) {
      try {
        var response = await http.post(
            Uri.parse('${baseUrl}houdix/seen/app/note/sync-notes/$uId'),
            headers: {'Content-Type': 'application/json'},
            body: encodedBody);
        var data = jsonDecode(response.body);

        if (response.statusCode == 200) {
          return data['message'];
        }
      } catch (e) {
        throw Exception(e);
      }
    }
  }

  Future<int?> getChapter() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    int uId = sharedPreferences.getInt('u_id')!;
    print(uId);
    String token = sharedPreferences.getString('token') ?? '';
    print(token);
    var encodedBody =
        jsonEncode({"user_id": uId!, "version": "1.0.0", "token": token});

    if (await checkConnection()) {
      try {
        var response = await http.put(
            Uri.parse('${baseUrl}houdix/seen/app/user/chapter/$uId'),
            headers: {'Content-Type': 'application/json'},
            body: encodedBody);
        print(response.body);
        print('4898889');
        await sharedPreferences.setBool('update', false);
        sharedPreferences.setString(
            'chapter', (json.decode(response.body))['chapter'] ?? '');
        sharedPreferences.setString(
            'time', (json.decode(response.body))['date_time'] ?? '');

        if ((json.decode(response.body))['message'] != null &&
            (json.decode(response.body))['message'] ==
                "this is not the latest version") {
          await sharedPreferences.setBool('update', true);
        }
        if ((json.decode(response.body))['message'] != null &&
            (json.decode(response.body))['message'] == "Not Authorized!") {
          List? answer = await getAllUseranswer();
          if (answer != null && answer.isNotEmpty) {
            await BackgroundDataSource.instance
                .submitAnswers(answer!)
                .then((value) {});
          } else {
            await sharedPreferences.remove('token');
            await sharedPreferences.remove('isFirstTime');
            await deleteAllActiveCodes();
            await deleteAllActiveCoupon();
            await deleteAllSession();
            await deleteAllIndexedSubjects();
            await deleteAllSubjects();
            await deleteAllSubSubjects();
            await clearQuestionTable();
            return 401;
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {}
  }
}
