import 'package:flutter/foundation.dart';

import '../../../shared/model/LocalDataSource.dart/LocalData.dart';

Future<Map<String, dynamic>> insertRandomQuestionInfo(
    Map<String, dynamic> info) async {
  final db = await SubjectLocalDataSource.instance.dbe;
  await db!.insert(tableRandomIdSession, info);
  if (kDebugMode) {
    //  debugPrint(" insert =====================================");
  }
  return info;
}

clearRandomizeTable() async {
  final db = await SubjectLocalDataSource().dbe;

  return await db!.rawDelete("DELETE  FROM $tableRandomIdSession");
}

Future<List<Map<String, dynamic>?>?> getAllRandomizeInfo() async {
  final db = await SubjectLocalDataSource().dbe;
  final res =
      await db!.query(tableRandomIdSession, orderBy: randomQuestionIndex);

  List<Map<String, dynamic>> list =
      res.isNotEmpty ? res.map((Map<String, dynamic> e) => e).toList() : [];

  if (list.isNotEmpty) {
    return list;
  }
  return [];
}

Future<List?> getAllRandomizeID() async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.query(tableRandomIdSession,
      columns: ['random_qid'], orderBy: randomQuestionIndex);

  List list = res.isNotEmpty
      ? res.map((Map<String, dynamic> e) => e['random_qid']).toList()
      : [];

  if (list.isNotEmpty) {
    return list;
  }
  return [];
}
