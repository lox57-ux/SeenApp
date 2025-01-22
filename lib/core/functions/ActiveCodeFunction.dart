import 'package:flutter/foundation.dart';

import '../../shared/model/LocalDataSource.dart/LocalData.dart';
import '../../Features/CodeManaging/model/classes/ActiveCodesLocal.dart';

Future<ActiveCodesLocal> insertActiveCode(ActiveCodesLocal activeCode) async {
  final db = await SubjectLocalDataSource().dbe;

  await db!.insert(tableActiveCodes, activeCode.toJson());

  if (kDebugMode) {}

  return activeCode;
}

Future<List<ActiveCodesLocal>?> getActiveCodeForSubject(int subId) async {
  final db = await SubjectLocalDataSource.instance.dbe;
  final res = await db!.rawQuery(
      "SELECT * FROM $tableActiveCodes  WHERE $subjectIdForCode=$subId");

  if (res.isNotEmpty) {
    return res
        .map<ActiveCodesLocal>((e) => ActiveCodesLocal.fromJson(e))
        .toList();
  }
  return null;
}

Future<List<ActiveCodesLocal>?> isValidCode(int codeID) async {
  final db = await SubjectLocalDataSource.instance.dbe;
  var nowDate = DateTime.now().toLocal().toString();

  final res = await db!.rawQuery(
      "SELECT * FROM $tableActiveCodes  WHERE $activeCodeId=$codeID AND '${nowDate}' < $endDate");
  if (res.isNotEmpty) {
    return res
        .map<ActiveCodesLocal>((e) => ActiveCodesLocal.fromJson(e))
        .toList();
  }
  return null;
}

Future<List<ActiveCodesLocal?>?> getAllActiveCode() async {
  final db = await SubjectLocalDataSource.instance.dbe;
  final res = await db!.rawQuery("SELECT * FROM $tableActiveCodes");

  if (res.isNotEmpty) {
    return res
        .map<ActiveCodesLocal>((e) => ActiveCodesLocal.fromJson(e))
        .toList();
  }
  return null;
}
// Future<int> deleteSubjects(int subId) async {
//   final db = await SubjectLocalDataSource.instance.dbe;
//   return await db!
//       .delete(tableSubject, where: '$subjectId = ?', whereArgs: [subId]);
// }

Future deleteAllActiveCodes() async {
  final db = await SubjectLocalDataSource.instance.dbe;
  return await db!.rawDelete("DELETE FROM $tableActiveCodes");
}
