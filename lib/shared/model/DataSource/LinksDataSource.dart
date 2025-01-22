import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seen/shared/model/entites/Links.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/url.dart';
import '../../../core/functions/LinksFunction.dart';

import 'package:http/http.dart' as http;

class LinksDataSource {
  static LinksDataSource instance = LinksDataSource();
  Future<List<Links>?> getAllLinks() async {
    SharedPreferences? prefrences = await SharedPreferences.getInstance();
    int uId = prefrences!.getInt('u_id')!;
    String token = prefrences!.getString('token')!;
    var encodedBody = json.encode({"token": token});
    try {
      var response = await http.put(
          Uri.parse('${baseUrl}houdix/seen/app/links/$uId'),
          headers: {'Content-Type': 'application/json'},
          body: encodedBody);
      var data = jsonDecode(response.body);

      List<Links> links = data.map<Links>((e) => Links.fromJson(e)).toList();
      await clearLinksTable();
      for (var e in links) {
        insertLink(e);
      }

      return links;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
