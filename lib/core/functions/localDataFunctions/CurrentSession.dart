import 'package:flutter/foundation.dart';

import '../../../shared/model/LocalDataSource.dart/LocalData.dart';

///insert codes into table
Future<Map<String, dynamic>> insertCurrentSession(
  Map<String, dynamic> session,
) async {
  final db = await SubjectLocalDataSource().dbe;
  List<Map<String, dynamic>?>? sessions =
      await getSession(session[question_id]);
  List<Map<String, dynamic>> tepQ = [];

  if (sessions != null && sessions!.isNotEmpty) {
    //here will be wrong
    for (var i in sessions) {
      if ((i![isRandomize] == session[isRandomize]) &&
          session[isRandomize] == 1) {
        await db!.rawQuery(
            "UPDATE  $tableCurrentSession set $choice=${session[choice]} , $correctnessColumn=${session[correctnessColumn]} , $answer_index=${session[answer_index]} , $answerContent= '${session[answerContent]}' , $alreadyChecked=${session[alreadyChecked]} WHERE $question_id= ${session['q_id']} And $isRandomize = 1");

        return session;
      } else if ((i![isfav] == session[isfav]) && session[isfav] == 1) {
        await db!.rawQuery(
            "UPDATE  $tableCurrentSession set $choice=${session[choice]} , $correctnessColumn=${session[correctnessColumn]} , $answer_index=${session[answer_index]},$answerContent='${session[answerContent]}',$alreadyChecked=${session[alreadyChecked]} WHERE $question_id= ${session['q_id']} And $isfav = 1");

        return session;
      } else if ((i![isAllfav] == session[isAllfav]) &&
          session[isAllfav] == 1) {
        await db!.rawQuery(
            "UPDATE  $tableCurrentSession set $choice=${session[choice]} , $correctnessColumn=${session[correctnessColumn]} , $answer_index=${session[answer_index]},$answerContent='${session[answerContent]}',$alreadyChecked=${session[alreadyChecked]} WHERE $question_id= ${session['q_id']} And $isAllfav = 1");
        return session;
      } else if ((i![isAllWrongness] == session[isAllWrongness]) &&
          session[isAllWrongness] == 1) {
        await db!.rawQuery(
            "UPDATE  $tableCurrentSession set $choice=${session[choice]} , $correctnessColumn=${session[correctnessColumn]} , $answer_index=${session[answer_index]},$answerContent='${session[answerContent]}',$alreadyChecked=${session[alreadyChecked]} WHERE $question_id= ${session['q_id']} And $isAllWrongness = 1");
        return session;
      } else if ((i![isWrongness] == session[isWrongness]) &&
          session[isWrongness] == 1) {
        await db!.rawQuery(
            "UPDATE  $tableCurrentSession set $choice=${session[choice]} , $correctnessColumn=${session[correctnessColumn]} , $answer_index=${session[answer_index]},$answerContent='${session[answerContent]}',$alreadyChecked=${session[alreadyChecked]} WHERE $question_id= ${session['q_id']} And $isWrongness = 1");
        return session;
      } else if ((i![isPrevious] == session[isPrevious]) &&
          session[isPrevious] == 1) {
        await db!.rawQuery(
            "UPDATE  $tableCurrentSession set $choice=${session[choice]} , $correctnessColumn=${session[correctnessColumn]} , $answer_index=${session[answer_index]},$answerContent='${session[answerContent]}',$alreadyChecked=${session[alreadyChecked]} WHERE $question_id= ${session['q_id']} And $isPrevious = 1");
        return session;
      } else if (((i![isPrevious] == session[isPrevious]) &&
              (i![isfav] == session[isfav]) &&
              (i![isWrongness] == session[isWrongness]) &&
              (i![isRandomize] == session[isRandomize])) &&
          (i![isAllWrongness] == session[isAllWrongness]) &&
          (i![isAllfav] == session[isAllfav]) &&
          session[isRandomize] == 0) {
        await db!.rawQuery(
            "UPDATE  $tableCurrentSession set $choice=${session[choice]} , $correctnessColumn=${session[correctnessColumn]} , $answer_index=${session[answer_index]},$answerContent='${session[answerContent]}',$alreadyChecked=${session[alreadyChecked]} WHERE $question_id= ${session['q_id']} And $isfav = 0 And $isPrevious = 0 And $isWrongness = 0 And $isRandomize = 0 And $isAllfav = 0 And $isAllWrongness = 0  ");
        return session;
      } else {
        tepQ.add(session);
      }
    }
    if (tepQ.isNotEmpty) {
      await db!.insert(tableCurrentSession, tepQ.first);
    }
    // await db!.rawQuery(
    //     "UPDATE $tableCurrentSession SET $choice = ${session['choice']} AND $answerContent = ${session[answerContent]} AND $correctnessColumn = ${session[correctnessColumn]} AND $answer_index = ${session[answer_index]} WHERE $question_id=${session[question_id]};");
  } else {
    await db!.insert(tableCurrentSession, session);
  }

  if (kDebugMode) {}

  return session;
}

Future<List<Map<String, dynamic>?>?> getSessions(int? subId) async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.rawQuery(
      "SELECT * FROM $tableCurrentSession WHERE $csSubId=$subId AND $isRandomize = 0  AND $isfav = 0 AND $isPrevious = 0 AND $isWrongness = 0 AND $isAllWrongness = 0 AND $isAllfav = 0");

  List<Map<String, dynamic>> list =
      res.isNotEmpty ? res.map((Map<String, dynamic> e) => e).toList() : [];

  if (list.isNotEmpty) {
    return list;
  }
  return [];
}

Future<List<Map<String, dynamic>?>?> getPreviousSessions(int previd) async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.rawQuery(
      "SELECT * FROM $tableCurrentSession WHERE $cspreviousIdCol =$previd AND $isPrevious = 1 ");

  List<Map<String, dynamic>> list =
      res.isNotEmpty ? res.map((Map<String, dynamic> e) => e).toList() : [];

  if (list.isNotEmpty) {
    return list;
  }
  return [];
}

Future<List<Map<String, dynamic>?>?> getRandomizeSessions() async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!
      .rawQuery("SELECT * FROM $tableCurrentSession WHERE $isRandomize = 1");

  List<Map<String, dynamic>> list =
      res.isNotEmpty ? res.map((Map<String, dynamic> e) => e).toList() : [];

  if (list.isNotEmpty) {
    return list;
  }
  return [];
}

Future<int?> checkRandomizeSessionsIfEmpty() async {
  final db = await SubjectLocalDataSource().dbe;
//   final res = await db!
//       .rawQuery("SELECT * FROM $tableCurrentSession WHERE $isRandomize = 1");

  final res = await db!.rawQuery(
      "SELECT EXISTS (SELECT 1 FROM $tableCurrentSession WHERE $isRandomize = 1)");

  int? ex =
      res.first['EXISTS (SELECT 1 FROM CurrentSession WHERE is_randomize = 1)']
          as int;

  return ex;
}

Future<List<Map<String, dynamic>?>?> getRandomizeSessionsID() async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!
      .rawQuery("SELECT * FROM $tableCurrentSession WHERE $isRandomize = 1");

  List<Map<String, dynamic>> list =
      res.isNotEmpty ? res.map((Map<String, dynamic> e) => e).toList() : [];

  if (list.isNotEmpty) {
    return list;
  }
  return [];
}

Future<List<Map<String, dynamic>?>?> getWrongnessSessions(int subId) async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.rawQuery(
      "SELECT * FROM $tableCurrentSession WHERE  $csSubId=$subId AND  $isWrongness = 1");

  List<Map<String, dynamic>> list =
      res.isNotEmpty ? res.map((Map<String, dynamic> e) => e).toList() : [];

  if (list.isNotEmpty) {
    return list;
  }
  return [];
}

Future<List<Map<String, dynamic>?>?> getAllWrongnessSessions(
    int subjectId) async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.rawQuery(
      "SELECT * FROM $tableCurrentSession WHERE  $csSubjectID = $subjectId AND  $isAllWrongness = 1");

  List<Map<String, dynamic>> list =
      res.isNotEmpty ? res.map((Map<String, dynamic> e) => e).toList() : [];

  if (list.isNotEmpty) {
    return list;
  }
  return [];
}

Future<List<Map<String, dynamic>?>?> getFavoritesSessions(int subId) async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.rawQuery(
      "SELECT * FROM $tableCurrentSession WHERE $csSubId = $subId AND $isfav = 1");

  List<Map<String, dynamic>> list =
      res.isNotEmpty ? res.map((Map<String, dynamic> e) => e).toList() : [];

  if (list.isNotEmpty) {
    return list;
  }
  return [];
}

Future<List<Map<String, dynamic>?>?> getAllFavoritesSessions(
    int subjectId) async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.rawQuery(
      "SELECT * FROM $tableCurrentSession  WHERE $csSubjectID=$subjectId AND $isAllfav = 1");

  List<Map<String, dynamic>> list =
      res.isNotEmpty ? res.map((Map<String, dynamic> e) => e).toList() : [];

  if (list.isNotEmpty) {
    return list;
  }
  return [];
}

Future<List<Map<String, dynamic>?>?> getSession(int? qId) async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!
      .rawQuery("SELECT * FROM $tableCurrentSession WHERE $question_id=$qId");

  List<Map<String, dynamic>> list =
      res.isNotEmpty ? res.map((Map<String, dynamic> e) => e).toList() : [];

  if (list.isNotEmpty) {
    return list;
  }
  return [];
}

///delete all row from code table
///
Future deleteAllSession() async {
  final db = await SubjectLocalDataSource().dbe;

  await db!.rawQuery("Delete FROM $tableCurrentSession ");

  return 0;
}

Future deleteSession() async {
  final db = await SubjectLocalDataSource().dbe;

  await db!.rawQuery("Delete FROM $tableCurrentSession WHERE $isRandomize=0");

  return 0;
}

Future deleteSubSession(int subID) async {
  final db = await SubjectLocalDataSource().dbe;

  await db!.rawQuery(
      "Delete FROM $tableCurrentSession WHERE $csSubId=$subID AND $isRandomize=0");

  return 0;
}

Future deleteRandomSession() async {
  final db = await SubjectLocalDataSource().dbe;

  await db!.rawQuery("Delete FROM $tableCurrentSession WHERE $isRandomize=1");

  return 0;
}

Future deleteFavSession() async {
  final db = await SubjectLocalDataSource().dbe;

  await db!.rawQuery("Delete FROM $tableCurrentSession WHERE $isfav=1");

  return 0;
}

Future deleteprevSession() async {
  final db = await SubjectLocalDataSource().dbe;

  await db!.rawQuery("Delete FROM $tableCurrentSession WHERE $isPrevious=1");

  return 0;
}

Future deleteAllFavSession() async {
  final db = await SubjectLocalDataSource().dbe;

  await db!.rawQuery("Delete FROM $tableCurrentSession WHERE $isAllfav = 1");

  return 0;
}

Future deleteAllWrongness() async {
  final db = await SubjectLocalDataSource().dbe;

  await db!
      .rawQuery("Delete FROM $tableCurrentSession WHERE $isAllWrongness=1");

  return 0;
}

Future deleteWrongness() async {
  final db = await SubjectLocalDataSource().dbe;

  await db!.rawQuery("Delete FROM $tableCurrentSession WHERE $isWrongness=1");

  return 0;
}
