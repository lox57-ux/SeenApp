import 'package:flutter/foundation.dart';

import '../../shared/model/LocalDataSource.dart/LocalData.dart';
import '../../Features/questions/model/classes/ExamsLog.dart';

Future<ExamsLog> insertEX(ExamsLog examsLog) async {
  final db = await SubjectLocalDataSource().dbe;

  var i = await checkifExEmpty(examsLog.id!);
  if (i == 1) {
  } else {
    await db!.insert(tablePrevious, examsLog.toJson());
  }

  if (kDebugMode) {}

  return examsLog;
}

clearExamsTable() async {
  final db = await SubjectLocalDataSource().dbe;

  return await db!.rawDelete("DELETE  FROM $tablePrevious");
}

clearExamsForSubject(int id) async {
  final db = await SubjectLocalDataSource().dbe;

  return await db!
      .rawDelete("DELETE  FROM $tablePrevious WHERE subject_id=$id");
}

Future<int?> checkifExEmpty(int val) async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.rawQuery(
      "SELECT EXISTS (SELECT 1 FROM $tablePrevious WHERE $previousIdCol =$val)");

  int? ex =
      res.first['EXISTS (SELECT 1 FROM $tablePrevious WHERE id =$val)'] as int;

  // List<QuestionAnswerModel> ans = convertFunc2(list);

  return ex;
}

Future<List<ExamsLog?>?> getAllExamLogOfSubject(int subjectID) async {
  final db = await SubjectLocalDataSource.instance.dbe;
  final res = await db!.rawQuery(
      "SELECT * FROM $tablePrevious WHERE $previousSubjectId= $subjectID");

  List<ExamsLog?> list =
      res.isNotEmpty ? res.map((c) => ExamsLog.fromJson(c)).toList() : [];

  if (list.isNotEmpty) {
    list.sort(
      (a, b) => a!.sort == null || b!.sort == null
          ? b!.id!.compareTo(a!.id!)
          : b.sort!.compareTo(a!.sort!),
    );
    return list;
  }
  return null;
}

Future<List<ExamsLog?>?> getAllExamLog() async {
  final db = await SubjectLocalDataSource.instance.dbe;
  final res = await db!.rawQuery("SELECT * FROM $tablePrevious ");

  List<ExamsLog?> list =
      res.isNotEmpty ? res.map((c) => ExamsLog.fromJson(c)).toList() : [];

  if (list.isNotEmpty) {
    return list;
  }
  return null;
}

Future<String?> getExamLog(int id) async {
  final db = await SubjectLocalDataSource.instance.dbe;
  final res = await db!.rawQuery(
      "SELECT $previousName FROM $tablePrevious Where $previousIdCol=$id");

  List<String?> list = res.isNotEmpty
      ? res.map<String?>((c) => c[previousName] as String).toList()
      : [];

  if (list.isNotEmpty) {
    return list.first;
  }
  return null;
}

Future<int?> checkifExaisEmpty() async {
  final db = await SubjectLocalDataSource().dbe;
  final res =
      await db!.rawQuery("SELECT EXISTS (SELECT 1 FROM $tablePrevious)");

  int? ex = res.first['EXISTS (SELECT 1 FROM previous)'] as int;

  // List<QuestionAnswerModel> ans = convertFunc2(list);

  return ex;
}
