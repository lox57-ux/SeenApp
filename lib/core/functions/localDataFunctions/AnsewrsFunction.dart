import 'package:flutter/foundation.dart';

import 'package:sqflite/sqflite.dart';

import '../../../shared/model/LocalDataSource.dart/LocalData.dart';
import '../../../Features/questions/model/classes/AnswerModel.dart';

Future<AnswerModel> insertAnswer(
  AnswerModel answer,
) async {
  final db = await SubjectLocalDataSource().dbe;
  var i = await checkifvalueEmpty(answer.ansId!);
  if (i == 1) {
  } else {
    db!.insert(tableAnswer, answer.toJson());
  }

  if (kDebugMode) {}
  return answer;
}

Future<int?> checkifvalueEmpty(int val) async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.rawQuery(
      "SELECT EXISTS (SELECT 1 FROM $tableAnswer WHERE $answerId =$val)");

  int? ex = res.first['EXISTS (SELECT 1 FROM answer WHERE id =$val)'] as int;

  // List<QuestionAnswerModel> ans = convertFunc2(list);

  return ex;
}

clearAnswerTable() async {
  final db = await SubjectLocalDataSource().dbe;

  return await db!.rawDelete("DELETE  FROM $tableAnswer");
}

clearAnswerForSubject(List? ids) async {
  final db = await SubjectLocalDataSource().dbe;

  return await db!.rawDelete(
      "DELETE  FROM $tableAnswer WHERE question_id IN (${ids!.join(', ')}) ");
}

Future<List<AnswerModel?>?> getAllAnswer() async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.rawQuery("SELECT * FROM $tableAnswer");

  List<AnswerModel?> list =
      res.isNotEmpty ? res.map((c) => AnswerModel.fromJson(c)).toList() : [];

  if (list.isNotEmpty) {
    return list;
  }
  return null;
}
