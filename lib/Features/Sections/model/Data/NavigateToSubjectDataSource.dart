import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/Services/Network.dart';
import '../../../../core/constants/url.dart';

import 'package:http/http.dart' as http;

import '../../../../shared/model/entites/CodeInfo.dart';

class NavigateToSubjectDataSource {
  static NavigateToSubjectDataSource instance = NavigateToSubjectDataSource();
  Future<List<Subject>?> getsubjectOfyear(int yearID) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var encodedBody = json.encode({
      "user_id": shared.getInt('u_id'),
      "year_id": yearID,
      "token": shared.getString('token')
    });

    if (await checkConnection()) {
      try {
        var response = await http.put(
            Uri.parse('${baseUrl}houdix/seen/app/subject/get-subjects-of-year'),
            headers: {'Content-Type': 'application/json'},
            body: encodedBody);
        var data = jsonDecode(response.body);

        List<Subject> subjects =
            data.map<Subject>((e) => Subject.fromJson(e)).toList();

        return subjects;
      } catch (e) {
        throw Exception(e);
      }
    } else {}
  }
}
