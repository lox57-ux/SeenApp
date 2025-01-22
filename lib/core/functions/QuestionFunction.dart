import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:seen/core/functions/concatingAnswerWithQuestion.dart';
import 'package:seen/Features/questions/model/classes/QuestionAnswerModel.dart';
import 'package:sqflite/sqflite.dart';

import '../../shared/model/LocalDataSource.dart/LocalData.dart';
import '../../Features/questions/Controller/LessonController.dart';
import '../../Features/questions/model/classes/QuestionModel.dart';
import '../../Features/questions/model/classes/QuestionWithAnswer.dart';
import 'ExamsLogFunction.dart';

LessonController _lessonController = Get.find();
Future<List<QuestionAnswerModel?>?> getQuestionWithAnswers(int id) async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.rawQuery(
      "SELECT * FROM $tableQuestion JOIN ANSWER ON question. id = answer.question_id where sub_subject_id  LIKE '%-${id.toString()}-%'");

  List<QuestionWithAnswer?> list = res.isNotEmpty
      ? res.map((c) {
          print(c['subject_id']);
          return QuestionWithAnswer.fromJson(c, subid: id);
        }).toList()
      : [];

  if (list.isNotEmpty) {
    List<QuestionAnswerModel> ans = await convertFunc2(list);

    return ans;
  }
  return null;
}

Future<List<QuestionAnswerModel?>?> getQuestion(int id) async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!
      .rawQuery("SELECT * FROM $tableQuestion  where $questionId = $id ");
  print(res);
  List<QuestionWithAnswer?> list = res.isNotEmpty
      ? res.map((c) => QuestionWithAnswer.fromJson(c, subid: id)).toList()
      : [];

  if (list.isNotEmpty) {
    List<QuestionAnswerModel> ans = await convertFunc2(list);

    return ans;
  }
  return null;
}

Future<List<QuestionAnswerModel?>?> getQuestionWithAnswersForSubject(
    int id) async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.rawQuery(
      "SELECT * FROM $tableQuestion JOIN ANSWER ON question. id = answer.question_id where $questionSubjectID = $id");
  List<QuestionWithAnswer?> list = res.isNotEmpty
      ? res.map((c) => QuestionWithAnswer.fromJson(c, subid: id)).toList()
      : [];

  if (list.isNotEmpty) {
    List<QuestionAnswerModel> ans = await convertFunc2(list);

    return ans;
  }
  return null;
}

Future<int> checkQuestionWithAnswersForSubject(int id) async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.rawQuery(
      "SELECT EXISTS (SELECT 1 FROM $tableQuestion where $questionSubjectID = $id) ");

  return res.first['EXISTS (SELECT 1 FROM question where subject_id = $id)']
      as int;
}

Future<int> checkQuestionWithAnswersForSubSubject(int id) async {
  final db = await SubjectLocalDataSource().dbe;

  final res = await db!.rawQuery(
      "SELECT EXISTS (SELECT 1 FROM $tableQuestion where sub_subject_id = $id) ");

  return res.first['EXISTS (SELECT 1 FROM question where sub_subject_id = $id)']
      as int;
}

Future<List<Map<String, dynamic>>?> getUserNote() async {
  final db = await SubjectLocalDataSource.instance.dbe;
  List<Map<String, dynamic>> maps = await db!.rawQuery(
      "SELECT $questionId, $note FROM $tableQuestion WHERE $note IS NOT NULL");

  if (maps.isNotEmpty) {
    var list = maps.map<Map<String, dynamic>>((e) {
      return {
        'question_id': e[questionId],
        'note': e[note],
      };
    }).toList();

    return list;
  }
  return null;
}

Future<List<QuestionAnswerModel?>?> getAllQuestionWithAnswers() async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.rawQuery(
      "SELECT * FROM $tableQuestion JOIN ANSWER ON question. id = answer.question_id");
  List<QuestionWithAnswer?> list = res.isNotEmpty
      ? res.map((c) => QuestionWithAnswer.fromJson(c)).toList()
      : [];

  if (list.isNotEmpty) {
    List<QuestionAnswerModel> ans = await convertFunc2(list);

    return ans;
  }
  return null;
}

Future<List<QuestionAnswerModel?>?> getRandomQ(List ids) async {
  final db = await SubjectLocalDataSource().dbe;

  final res = await db!.rawQuery(
      "SELECT * FROM $tableQuestion JOIN ANSWER ON question. id = answer.question_id WHERE answer.question_id IN (${ids.join(', ')})");

  List<QuestionWithAnswer?> list = [];
  res.isNotEmpty
      ? await Future.forEach(res, (c) {
          list.add(QuestionWithAnswer.fromJson(c));
        })
      : {};

  if (list.isNotEmpty) {
    List<QuestionAnswerModel> ans = await convertFunc2(list);

    return ans;
  }
  return null;
}

Future<int?> checkifTableisEmpty() async {
  final db = await SubjectLocalDataSource().dbe;
  final res =
      await db!.rawQuery("SELECT EXISTS (SELECT 1 FROM $tableQuestion)");

  int? ex = res.first['EXISTS (SELECT 1 FROM question)'] as int;

  // List<QuestionAnswerModel> ans = await convertFunc2(list);

  return ex;
}

Future<List<QuestionAnswerModel?>?> getPreviosWithAnswers(int prev_id) async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.rawQuery(
      "SELECT * FROM $tableQuestion JOIN ANSWER ON question.id = answer.question_id where  question.previous_id LIKE '%-${prev_id.toString()}-%'");
  List<QuestionWithAnswer?> list = res.isNotEmpty
      ? res.map((c) => QuestionWithAnswer.fromJson(c)).toList()
      : [];

  if (list.isNotEmpty) {
    List<QuestionAnswerModel> ans = await convertFunc2(list);

    return ans;
  }
  return null;
}

Future<List<QuestionAnswerModel?>?> getWrongQuestionWithAnswers(int id) async {
  final db = await SubjectLocalDataSource().dbe;
  var date = DateTime.now().toUtc();
  final res = await db!.rawQuery(
      "SELECT * FROM $tableQuestion JOIN ANSWER ON question. id = answer.question_id where sub_subject_id LIKE '%-${id.toString()}-%' AND is_wrong = 1 AND $nextShowDate <= '$date'");
  print(res);

  List<QuestionWithAnswer?> list = res.isNotEmpty
      ? res.map((c) => QuestionWithAnswer.fromJson(c, subid: id)).toList()
      : [];
  print(res);

  if (list.isNotEmpty) {
    List<QuestionAnswerModel> ans = await convertFunc2(list);

    return ans;
  }
  return null;
}

Future<List<QuestionAnswerModel?>?> getWrongQuestionWithAnswersForSubject(
    int id) async {
  final db = await SubjectLocalDataSource().dbe;

  final res = await db!.rawQuery(
      "SELECT * FROM $tableQuestion JOIN ANSWER ON question. id = answer.question_id Where is_wrong = 1");
  List<QuestionWithAnswer?> list = res.isNotEmpty
      ? res.map((c) {
          if (c['is_mcq'] == 0) {
            print('###################################');
            print(c);
          }
          return QuestionWithAnswer.fromJson(c, subid: id);
        }).toList()
      : [];

  if (list.isNotEmpty) {
    List<QuestionAnswerModel> ans = await convertFunc2(list);

    return ans;
  }
  return null;
}

Future<List<QuestionAnswerModel?>?> getAllWrongQuestionWithAnswers() async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.rawQuery(
      "SELECT * FROM $tableQuestion JOIN ANSWER ON question. id = answer.question_id where is_wrong = 1");
  List<QuestionWithAnswer?> list = res.isNotEmpty
      ? res.map((c) => QuestionWithAnswer.fromJson(c)).toList()
      : [];

  if (list.isNotEmpty) {
    List<QuestionAnswerModel> ans = await convertFunc2(list);

    return ans;
  }
  return null;
}

Future<List<QuestionAnswerModel?>?> getFavoritesQuestionWithAnswers(
    int id) async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.rawQuery(
      "SELECT * FROM $tableQuestion JOIN ANSWER ON question.id = answer.question_id where sub_subject_id LIKE '%-${id.toString()}-%' AND is_favorite = 1");
  List<QuestionWithAnswer?> list = res.isNotEmpty
      ? res.map((c) => QuestionWithAnswer.fromJson(c, subid: id)).toList()
      : [];

  if (list.isNotEmpty) {
    List<QuestionAnswerModel> ans = await convertFunc2(list);

    return ans;
  }
  return null;
}

Future<List<QuestionAnswerModel?>?> getAllFavoritesQuestionWithAnswers() async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.rawQuery(
      "SELECT * FROM $tableQuestion JOIN ANSWER ON question.id = answer.question_id where is_favorite = 1");
  List<QuestionWithAnswer?> list = res.isNotEmpty
      ? res.map((c) => QuestionWithAnswer.fromJson(c)).toList()
      : [];

  if (list.isNotEmpty) {
    List<QuestionAnswerModel> ans = await convertFunc2(list);

    return ans;
  }
  return null;
}

Future<List<QuestionModel?>?> getAllQuestion() async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.rawQuery("SELECT * FROM $tableQuestion");
  List<QuestionModel?> list = res.isNotEmpty
      ? res.map<QuestionModel>((c) => QuestionModel.fromJson(c)).toList()
      : [];

  if (list.isNotEmpty) {
    return list;
  }
  return null;
}

Future<List<int?>?> getAllQuestionID() async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.rawQuery("SELECT $questionId FROM $tableQuestion");

  List<int?> list = res.isNotEmpty
      ? res.map<int>((Map<String, dynamic> c) => c['id']).toList()
      : [];

  if (list.isNotEmpty) {
    return list;
  }
  return null;
}

Future<List<int?>?> getAllQuestionIDForSubject(int id) async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!
      .rawQuery("SELECT $questionId FROM $tableQuestion WHERE subject_id=$id");

  List<int?> list = res.isNotEmpty
      ? res.map<int>((Map<String, dynamic> c) => c['id']).toList()
      : [];

  if (list.isNotEmpty) {
    return list;
  }
  return null;
}

Future<List<int?>?> getAllQuestionIDForSubSubject(int id) async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.rawQuery(
      "SELECT $questionId FROM $tableQuestion WHERE sub_subject_id  LIKE '%-${id.toString()}-%'");

  List<int?> list = res.isNotEmpty
      ? res.map<int>((Map<String, dynamic> c) => c['id']).toList()
      : [];

  if (list.isNotEmpty) {
    return list;
  }
  return null;
}

Future<List<int?>?> getAllFavoritesQuestionID() async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!
      .rawQuery("SELECT $questionId FROM $tableQuestion where $isFavorite=1 ");

  List<int?> list = res.isNotEmpty
      ? res.map<int>((Map<String, dynamic> c) => c['id']).toList()
      : [];

  if (list.isNotEmpty) {
    return list;
  }
  return null;
}

Future<List<String?>?> getAllexamsForQuestion(int id) async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.rawQuery(
      "SELECT $previousId FROM $tableQuestion where $questionId=$id ");

  List<String> prev = [];
  List<int?> list = [];
  res.isNotEmpty
      ? await Future.forEach(
          res,
          (e) {
            // print(e['previous_id'].toString().split('-'));
            // print(id);

            for (int i = 1;
                i <= e['previous_id'].toString().split('-').length - 1;
                i++) {
              if (e['previous_id'].toString().split('-')[i] != '') {
                list.add(int.parse(e['previous_id'].toString().split('-')[i]));
              }
            }
          },
        )
      : [];

  await Future.forEach(list, (element) async {
    String? pre = await getExamLog(element!);
    if (pre != null) {
      if (prev.contains(pre)) {
      } else {
        prev.add(pre);
      }
    } else {}
  });

  if (prev.isNotEmpty) {
    return prev;
  }
  return null;
}

Future<int> getQuestionWrongSolvedTimes(int id) async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.rawQuery(
      "SELECT $wrongTimes FROM $tableQuestion  where $questionId = $id ");
  print(res);
  int? numberOfWrongTime =
      res.isNotEmpty ? res.first['wrong_times'] as int? : 0;

  return numberOfWrongTime ?? 0;
}

Future<int> getQuestionRightSolvedTimes(int id) async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.rawQuery(
      "SELECT $rightTimes FROM $tableQuestion  where $questionId = $id ");
  print(res);
  int? numberOfRightTime =
      res.isNotEmpty ? res.first['right_times'] as int? : 0;

  return numberOfRightTime ?? 0;
}

Future<Map<String, dynamic>?> getQuestionRightSolvedTimesAndNextTimes(
    int id) async {
  final db = await SubjectLocalDataSource().dbe;
  final res = await db!.rawQuery(
      "SELECT $rightTimes ,$nextShowDate FROM $tableQuestion  where $questionId = $id ");
  print(res);
  Map<String, dynamic>? numberOfRightTime = res.isNotEmpty ? res.first : null;

  return numberOfRightTime;
}

Future<dynamic> updateWrongness(int id, int val) async {
  int cia = 0;
  int cca = 0;
  print("object");

  final db = await SubjectLocalDataSource.instance.dbe;
  if (val == 0) {
    var iswrong = await db!.rawQuery(
      'SELECT $isWrong from $tableQuestion WHERE $questionId=$id',
    );
    if (iswrong.first[isWrong] != null && iswrong.first[isWrong] == 0) {
    } else {
      int? rt = (await getQuestionRightSolvedTimes(id));

      rt++;
      cia = 0;
      cca = rt;
      print(cca);
      print(cia);

      int interval = (int.parse(pow(2, cca).toString()) - cia) + 3;
      print(interval);
      if (interval < 1) {
        interval = 1;
      }
      print(interval);

      var date = DateTime.now();
      DateTime dateAtMidnight =
          DateTime(date.year, date.month, date.day, 0, 0, 0)
              .add(Duration(days: interval));

      if (rt == 5) {
        await db!.rawQuery(
          'UPDATE $tableQuestion Set $isWrong =$val , $rightTimes =0,$wrongTimes =0 WHERE $questionId=$id',
        );
      } else {
        await db!.rawQuery(
          'UPDATE $tableQuestion Set $rightTimes = $rt,$wrongTimes =0 ,$nextShowDate ="$dateAtMidnight"  WHERE $questionId=$id',
        );
      }
    }
  }
  if (val == 1) {
    int? wt = (await getQuestionWrongSolvedTimes(id));

    wt++;
    cia = wt;
    cca = 0;
    print(cca);
    print(cia);

    int interval = (int.parse(pow(2, cca).toString()) - cia) + 3;
    print(interval);
    if (interval < 1) {
      interval = 1;
    }
    print(interval);
    // String formattedDateTime = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(now.toUtc());

    var date = DateTime.now();
    var dateAtMidnight = DateTime(date.year, date.month, date.day, 00, 0, 0)
        .add(Duration(days: interval));
    print(dateAtMidnight);
    if (wt - 1 == 0) {
      await db!.rawQuery(
        'UPDATE $tableQuestion Set $isWrong =$val , $rightTimes =0,$wrongTimes =$wt , $nextShowDate ="$dateAtMidnight" WHERE $questionId=$id',
      );
    } else {
      print(id);
      await db!.rawQuery(
        'UPDATE $tableQuestion Set $rightTimes = 0,$wrongTimes =$wt ,$nextShowDate ="$dateAtMidnight" WHERE $questionId=$id',
      );
    }
  }
}

Future<dynamic> updateBackGroundWrongness(int id) async {
  final db = await SubjectLocalDataSource.instance.dbe;

  return await db!.rawQuery(
    'UPDATE $tableQuestion Set $isWrong =1 WHERE $questionId=$id AND $isWrong= 0',
  );
}

Future<dynamic> updateNote(int id, String? val) async {
  final db = await SubjectLocalDataSource.instance.dbe;

  if (val == null || val == '') {
    return await db!.rawQuery(
      'UPDATE $tableQuestion Set "$note"=null WHERE $questionId=$id',
    );
  } else {
    return await db!.rawQuery(
      'UPDATE $tableQuestion Set "$note"="$val" WHERE $questionId=$id',
    );
  }
}

Future<dynamic> addRemoveFavorites(int id, int val) async {
  final db = await SubjectLocalDataSource().dbe;
  await db!.rawQuery(
    'UPDATE $tableQuestion Set $isFavorite = $val WHERE $questionId = $id',
  );

  return 0;
}

Future<dynamic> addAllFavorites(List ids) async {
  final db = await SubjectLocalDataSource().dbe;
  await db!.rawQuery(
    'UPDATE $tableQuestion Set $isFavorite = 1 WHERE $questionId IN (${ids.join(', ')})',
  );

  return 0;
}

Future<dynamic> updateQ(String content, int id, QuestionAnswerModel a) async {
  final db = await SubjectLocalDataSource().dbe;
  a.questionContent = content;
  // var res = await db!.rawQuery(
  //   'SELECT * FROM $tableQuestion WHERE $questionId = $id ',
  // );
  // print(res);
  await db!.rawUpdate('''
    UPDATE $tableQuestion  SET $questionContent = ?
    WHERE $questionId = ?
  ''', [content, id]);
  // await db!.update('', a.toJson(),
  //     where: " $questionId = ?",
  //     whereArgs: [id],
  //     conflictAlgorithm: ConflictAlgorithm.ignore);

  return 0;
}

clearQuestionTable() async {
  final db = await SubjectLocalDataSource().dbe;

  return await db!.rawDelete("DELETE  FROM $tableQuestion");
}

clearQuestionsForSubject(int id) async {
  final db = await SubjectLocalDataSource().dbe;

  return await db!
      .rawDelete("DELETE  FROM $tableQuestion WHERE subject_id =$id");
}

clearQuestionsForSubSubject(int id) async {
  final db = await SubjectLocalDataSource().dbe;

  return await db!.rawDelete(
      "DELETE  FROM $tableQuestion WHERE sub_subject_id  LIKE '%-${id.toString()}-%'");
}

Future<QuestionModel> insertQ(
  QuestionModel question,
) async {
  final db = await SubjectLocalDataSource().dbe;

  try {
    await db!.insert(tableQuestion, question.toJson());
  } catch (e) {
    throw Exception(e);
  }

  if (kDebugMode) {
    print(" insert question=====================================");
  }

  return question;
}

Future<dynamic> updatePrevQ(int id, int val) async {
  final db = await SubjectLocalDataSource.instance.dbe;

  return await db!.rawQuery(
    'UPDATE $tableQuestion Set $previousId =$val WHERE $questionId=$id',
  );
}
