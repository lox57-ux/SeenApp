import 'package:flutter/foundation.dart';

import '../../../shared/model/LocalDataSource.dart/LocalData.dart';
import '../../../Features/Sections/model/classes/SubSubjects.dart';

Future<SubSubject> insertSubsubject(SubSubject subSubject) async {
  final db = await SubjectLocalDataSource.instance.dbe;
  var i = await checkifsubEmpty(subSubject.id!);
  if (i == 1) {
  } else {
    // if (subSubject.id == 1350) {
    //   print('###################################');
    //   print(subSubject.toJson());
    //   print('###################################');
    // }
    await db!.insert(tableSubSubject, subSubject.toJson());
  }

  if (kDebugMode) {
    print('insert..............................................');
  }
  return subSubject;
}

Future<int?> checkifsubEmpty(int val) async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.rawQuery(
      "SELECT EXISTS (SELECT 1 FROM $tableSubSubject WHERE $subSubjectId =$val)");

  int? ex =
      res.first['EXISTS (SELECT 1 FROM subSubject WHERE id =$val)'] as int;

  // List<QuestionAnswerModel> ans = convertFunc2(list);

  return ex;
}

Future<List<SubSubject?>?> getSubSubjects() async {
  final db = await SubjectLocalDataSource.instance.dbe;
  final res = await db!.rawQuery("SELECT * FROM $tableSubSubject");

  List<SubSubject?> list = res.isNotEmpty
      ? res
          .map((c) => SubSubject.fromJson(
                c,
                false,
              ))
          .toList()
      : [];

  return list;
}

Future<List<SubSubject?>?> getSubSubjectsForFather(id) async {
  final db = await SubjectLocalDataSource.instance.dbe;
  final res =
      await db!.rawQuery("SELECT * FROM $tableSubSubject Where father_id=$id");

  List<SubSubject?> list = res.isNotEmpty
      ? res
          .map((c) => SubSubject.fromJson(
                c,
                false,
              ))
          .toList()
      : [];

  return list;
}

Future<List<SubSubject?>?> getSubSubjectsForSubject(int subId) async {
  final db = await SubjectLocalDataSource.instance.dbe;
  List<Map<String, dynamic>> maps = await db!.query(tableSubSubject,
      columns: [
        subSubjectId,
        subSubjectName,
        subSubjectNotes,
        subjectIdForSubSub,
        fatherId,
        isLatex,
        is_unlocked,
        openSubSubject,
        hasData
      ],
      where: '$subjectIdForSubSub = ?',
      whereArgs: [subId]);
  List<SubSubject?> list = maps.isNotEmpty
      ? maps.map((c) => SubSubject.fromJson(c, false)).toList()
      : [];

  return list;
}

Future<int?> getFatherIDSubSubjects(int subId) async {
  final db = await SubjectLocalDataSource.instance.dbe;
  List<Map<String, dynamic>> maps = await db!.query(tableSubSubject,
      columns: [fatherId], where: '$subSubjectId = ?', whereArgs: [subId]);
  print(maps);
  return maps.first['father_id'];
}

Future<List<int?>?> getSubSubjectsidForSubject(int subId) async {
  final db = await SubjectLocalDataSource.instance.dbe;
  List<Map<String, dynamic>> maps = await db!.query(tableSubSubject,
      columns: [subSubjectId],
      where: '$subjectIdForSubSub = ?',
      whereArgs: [subId]);

  List<int?> list =
      maps.isNotEmpty ? maps.map<int>((e) => e[subSubjectId]).toList() : [];

  return list;
}

Future<dynamic> updateSubSubjectIfcontainsData(int id, int value) async {
  final db = await SubjectLocalDataSource.instance.dbe;
  print("update");
  return await db!.rawQuery(
      'UPDATE $tableSubSubject Set $hasData =$value WHERE $subSubjectId=$id');
}

Future<dynamic> updateSubSubjectIfItsOpen(int id, int value) async {
  final db = await SubjectLocalDataSource.instance.dbe;
  print(id);
  if (id == 1728) {
    print('############# done #####################');
  }
  return await db!.rawQuery(
      'UPDATE $tableSubSubject Set $is_unlocked =$value ,$openSubSubject=$value WHERE $subSubjectId=$id');
}

Future<int> deleteSubSubjects(int subId) async {
  final db = await SubjectLocalDataSource.instance.dbe;
  return await db!
      .delete(tableSubSubject, where: '$subSubjectId = ?', whereArgs: [subId]);
}

Future deleteAllSubSubjects() async {
  final db = await SubjectLocalDataSource.instance.dbe;
  return await db!.rawDelete("DELETE FROM $tableSubSubject");
}
