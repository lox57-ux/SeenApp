import 'package:flutter/foundation.dart';

import '../../shared/model/LocalDataSource.dart/LocalData.dart';
import '../../shared/model/entites/Links.dart';

Future<Links> insertLink(Links links) async {
  final db = await SubjectLocalDataSource().dbe;

  await db!.insert(tableLinks, links.toJson());

  if (kDebugMode) {}

  return links;
}

clearLinksTable() async {
  final db = await SubjectLocalDataSource().dbe;

  return await db!.rawDelete("DELETE  FROM $tableLinks");
}

Future<Links?> getLink(String description) async {
  final db = await SubjectLocalDataSource.instance.dbe;
  final res = await db!.rawQuery(
      "SELECT * FROM $tableLinks WHERE $linkDescription='$description' ");

  List<Links?> list =
      res.isNotEmpty ? res.map((c) => Links.fromJson(c)).toList() : [];

  if (list.isNotEmpty) {
    return list.first;
  }
  return null;
}

Future<List<Links?>?>? getAllLinks() async {
  final db = await SubjectLocalDataSource.instance.dbe;
  final res = await db!.rawQuery("SELECT * FROM $tableLinks ");

  List<Links?>? list =
      res.isNotEmpty ? res.map((c) => Links.fromJson(c)).toList() : [];

  if (list.isNotEmpty) {
    return list;
  }
  return list;
}
