import 'package:flutter/foundation.dart';

import '../../../shared/model/LocalDataSource.dart/LocalData.dart';

Future<void> insertUserAnswer(int answerID, bool correctness) async {
  final db = await SubjectLocalDataSource().dbe;
  var userAns = await getUseranswer(answerID);

  if (userAns != null) {
    await db!.update(userAnswers,
        {userAnswersID: answerID, correctnessColumn: correctness ? 1 : 0},
        where: '$userAnswersID = ?', whereArgs: [answerID]);
  } else {
    await db!.insert(userAnswers,
        {userAnswersID: answerID, correctnessColumn: correctness ? 1 : 0});
  }

  if (kDebugMode) {
    print('insertion ======================================');
  }
}

Future<List?> getUseranswer(int ansID) async {
  final db = await SubjectLocalDataSource.instance.dbe;
  final res = await db!
      .rawQuery("SELECT * FROM $userAnswers WHERE $userAnswersID=$ansID ");

  List list = res.isNotEmpty ? res.map((c) => c).toList() : [];

  if (list.isNotEmpty) {
    return list;
  }
  return null;
}

Future deleteAllUserAnswer() async {
  final db = await SubjectLocalDataSource.instance.dbe;

  return await db!.rawDelete("DELETE FROM $userAnswers");
}

Future<List?> getAllUseranswer() async {
  final db = await SubjectLocalDataSource.instance.dbe;
  final res = await db!.rawQuery("SELECT * FROM $userAnswers ");

  List list = res.isNotEmpty
      ? res
          .map((c) => {
                "id": c[userAnswersID],
                "correctness": c[correctnessColumn] == 1 ? true : false
              })
          .toList()
      : [];

  if (list.isNotEmpty) {
    return list;
  }
  return null;
}
