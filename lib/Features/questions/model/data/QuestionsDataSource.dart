import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:seen/core/Services/Network.dart';
import 'package:seen/core/constants/url.dart';
import 'package:seen/core/functions/ExamsLogFunction.dart';
import 'package:seen/core/functions/localDataFunctions/SubjectFunctions.dart';
import 'package:seen/core/functions/localDataFunctions/SubsubjectsFunction.dart';
import 'package:seen/Features/questions/model/data/WrongAnswerDataSource.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/constants/TextStyles.dart';
import '../../../../core/controller/text_controller.dart';
import '../../../../core/functions/QuestionFunction.dart';
import '../../../../core/functions/localDataFunctions/AnsewrsFunction.dart';
import '../../../../shared/model/LocalDataSource.dart/LocalData.dart';
import '../../../Sections/model/classes/SubSubjects.dart';
import '../classes/AnswerModel.dart';
import '../classes/ExamsLog.dart';
import '../classes/QuestionModel.dart';
import '../classes/QuestionWithAnswer.dart';

useIsolatesForSub(List<dynamic> args) async {
  final SendPort sendPort = args[0];
  List<ExamsLog> examsLog = [];
  for (int i = 0; i < (args[1].length / 3).floor(); i++) {
    List answer = [];

    if (args[1][i]['question']['is_mcq']) {
      if (args[3].contains(QuestionModel(
          hurl: args[1][i]['h_url'],
          subjectID: args[4],
          note: (args[1][i]['question']['notes'] == null)
              ? null
              : (args[1][i]['question']['notes'] as List).isEmpty
                  ? null
                  : (args[1][i]['question']['notes'] as List).first['note'],
          quesId: args[1][i]['question']['id'],
          isMcq: 1,
          prevId: null,
          url: args[1][i]['question']['url'],
          quesContent: args[1][i]['question']['question_content'],
          quesNotes: args[1][i]['question']['question_notes'],
          subSubId: "-${args[5]}-",
          iswrong: 0,
          isfavorite: 0))) {
        // if (ae['id'] == args[1][i]['question_id']) {
        //   print(args[1][i]['question']['question_content']);
        //   ae['subIds'] = ae['subIds'] + "${args[1][i]['sub_subject_id']}-";
        // } else {
        //   for (var element in args[3]) {
        //     if (element.quesId == args[1][i]['question_id']) {
        //       element.subSubId = ae['subIds'];
        //     } else {
        //       break;
        //     }
        //   }

        //   ae = {
        //     'id': args[1][i]['question_id'],
        //     'subIds': "-${args[1][i]['sub_subject_id']}-"
        //   };
        // }
      } else {
        String? exIDS = '-';
        if ((args[1][i]['question']["previous_questions"] != null &&
            (args[1][i]['question']["previous_questions"] as List)
                .isNotEmpty)) {
          for (var ex
              in (args[1][i]['question']["previous_questions"] as List)) {
            if (examsLog.contains(ExamsLog.fromJson(ex["previous"]))) {
            } else {
              examsLog.add(ExamsLog.fromJson(ex["previous"]));
            }

            exIDS = '$exIDS${ex["previous"]["id"]}-';
          }
        }
        args[3].add(QuestionModel(
            hurl: args[1][i]['h_url'],
            subjectID: args[4],
            note: (args[1][i]['question']['notes'] == null)
                ? null
                : (args[1][i]['question']['notes'] as List).isEmpty
                    ? null
                    : (args[1][i]['question']['notes'] as List).first['note'],
            quesId: args[1][i]['question']['id'],
            isMcq: 1,
            prevId: exIDS,
            url: args[1][i]['question']['url'],
            quesContent: args[1][i]['question']['question_content'],
            quesNotes: args[1][i]['question']['question_notes'],
            subSubId: "-${args[5]}-",
            iswrong: 0,
            isfavorite: 0));
      }
    } else {
      if (args[3].contains(QuestionModel(
          hurl: args[1][i]['h_url'],
          subjectID: args[4],
          note: (args[1][i]['question']['notes'] == null)
              ? null
              : (args[1][i]['question']['notes'] as List).isEmpty
                  ? null
                  : (args[1][i]['question']['notes'] as List).first['note'],
          quesId: args[1][i]['question']['id'],
          isMcq: 0,
          prevId: null,
          quesContent: args[1][i]['question']['question_content'],
          quesNotes: args[1][i]['question']['question_notes'],
          subSubId: "-${args[5]}-",
          iswrong: 0,
          url: args[1][i]['question']['url'],
          isfavorite: 0))) {
      } else {
        String? exIDS = '-';
        if ((args[1][i]['question']["previous_questions"] != null &&
            (args[1][i]['question']["previous_questions"] as List)
                .isNotEmpty)) {
          for (var ex
              in (args[1][i]['question']["previous_questions"] as List)) {
            if (examsLog.contains(ExamsLog.fromJson(ex["previous"]))) {
            } else {
              examsLog.add(ExamsLog.fromJson(ex["previous"]));
            }

            exIDS = '$exIDS${ex["previous"]["id"]}-';
          }
        }
        args[3].add(QuestionModel(
            hurl: args[1][i]['h_url'],
            subjectID: args[4],
            note: (args[1][i]['question']['notes'] == null)
                ? null
                : (args[1][i]['question']['notes'] as List).isEmpty
                    ? null
                    : (args[1][i]['question']['notes'] as List).first['note'],
            quesId: args[1][i]['question']['id'],
            isMcq: 0,
            prevId: exIDS,
            quesContent: args[1][i]['question']['question_content'],
            quesNotes: args[1][i]['question']['question_notes'],
            subSubId: "-${args[5]}-",
            iswrong: 0,
            url: args[1][i]['url'],
            isfavorite: 0));
      }
    }

    answer = args[1][i]['question']['answer'];

    if (args[1][i]['question']['is_mcq']) {
      await Future.forEach(answer, (element) async {
        AnswerModel answerObj = AnswerModel();
        element['correctness']
            ? answerObj = AnswerModel(
                correctness: 1,
                ansContent: element['answer_content'],
                ansId: element['id'],
                url: element['url'],
                ansNotes: element['answer_notes'],
                quesId: args[1][i]['question']['id'])
            : answerObj = AnswerModel(
                correctness: 0,
                url: element['url'],
                ansContent: element['answer_content'],
                ansId: element['id'],
                ansNotes: element['answer_notes'],
                quesId: args[1][i]['question']['id']);

        if (args[2].contains(answerObj)) {
        } else {
          args[2].add(answerObj);
          // batch.insert(tableAnswer, answerObj.toJson());
        }
      });
    } else {
      await Future.forEach(answer, (element) async {
        AnswerModel answerObj = AnswerModel();
        element['correctness'] ?? true
            ? answerObj = AnswerModel(
                correctness: 1,
                url: element['url'],
                ansContent: element['answer_content'],
                ansId: element['id'],
                ansNotes: element['answer_notes'],
                quesId: args[1][i]['question']['id'])
            : answerObj = AnswerModel(
                correctness: 0,
                url: element['url'],
                ansContent: element['answer_content'],
                ansId: element['id'],
                ansNotes: element['answer_notes'],
                quesId: args[1][i]['question']['id']);
        if (args[2].contains(answerObj)) {
        } else {
          args[2].add(answerObj);
        }
      });
    }
  }
  sendPort.send([args[2], args[3], examsLog]);
  // Isolate.exit(sendPort, [args[2], args[3]]);
}

useIsolatesForSub2(List<dynamic> args) async {
  var ae = {};
  List<ExamsLog> examsLog = [];
  final SendPort sendPort = args[0];
  for (int i = (args[1].length / 3).floor();
      i < (args[1].length / 3).floor() * 2;
      i++) {
    List answer = [];

    if (args[1][i]['question']['is_mcq']) {
      if (args[3].contains(QuestionModel(
          hurl: args[1][i]['h_url'],
          subjectID: args[4],
          note: (args[1][i]['question']['notes'] == null)
              ? null
              : (args[1][i]['question']['notes'] as List).isEmpty
                  ? null
                  : (args[1][i]['question']['notes'] as List).first['note'],
          quesId: args[1][i]['question']['id'],
          isMcq: 1,
          prevId: null,
          url: args[1][i]['url'],
          quesContent: args[1][i]['question']['question_content'],
          quesNotes: args[1][i]['question']['question_notes'],
          subSubId: "-${args[5]}-",
          iswrong: 0,
          isfavorite: 0))) {
        // if (ae['id'] == args[1][i]['question_id']) {
        //   print(args[1][i]['question']['question_content']);
        //   ae['subIds'] = ae['subIds'] + "${args[1][i]['sub_subject_id']}-";
        // } else {
        //   for (var element in args[3]) {
        //     if (element.quesId == args[1][i]['question_id']) {
        //       element.subSubId = ae['subIds'];
        //     } else {
        //       break;
        //     }
        //   }

        //   ae = {
        //     'id': args[1][i]['question_id'],
        //     'subIds': "-${args[1][i]['sub_subject_id']}-"
        //   };
        // }
      } else {
        String? exIDS = '-';
        if ((args[1][i]['question']["previous_questions"] != null &&
            (args[1][i]['question']["previous_questions"] as List)
                .isNotEmpty)) {
          for (var ex
              in (args[1][i]['question']["previous_questions"] as List)) {
            if (examsLog.contains(ExamsLog.fromJson(ex["previous"]))) {
            } else {
              examsLog.add(ExamsLog.fromJson(ex["previous"]));
            }

            exIDS = '$exIDS${ex["previous"]["id"]}-';
          }
        }
        args[3].add(QuestionModel(
            hurl: args[1][i]['h_url'],
            subjectID: args[4],
            note: (args[1][i]['question']['notes'] == null)
                ? null
                : (args[1][i]['question']['notes'] as List).isEmpty
                    ? null
                    : (args[1][i]['question']['notes'] as List).first['note'],
            quesId: args[1][i]['question']['id'],
            isMcq: 1,
            prevId: exIDS,
            quesContent: args[1][i]['question']['question_content'],
            quesNotes: args[1][i]['question']['question_notes'],
            subSubId: "-${args[5]}-",
            iswrong: 0,
            url: args[1][i]['question']['url'],
            isfavorite: 0));
      }
    } else {
      if (args[3].contains(QuestionModel(
          hurl: args[1][i]['h_url'],
          subjectID: args[4],
          note: (args[1][i]['question']['notes'] == null)
              ? null
              : (args[1][i]['question']['notes'] as List).isEmpty
                  ? null
                  : (args[1][i]['question']['notes'] as List).first['note'],
          quesId: args[1][i]['question']['id'],
          isMcq: 0,
          prevId: null,
          quesContent: args[1][i]['question']['question_content'],
          quesNotes: args[1][i]['question']['question_notes'],
          subSubId: "-${args[5]}-",
          iswrong: 0,
          url: args[1][i]['question']['url'],
          isfavorite: 0))) {
      } else {
        String? exIDS = '-';
        if ((args[1][i]['question']["previous_questions"] != null &&
            (args[1][i]['question']["previous_questions"] as List)
                .isNotEmpty)) {
          for (var ex
              in (args[1][i]['question']["previous_questions"] as List)) {
            if (examsLog.contains(ExamsLog.fromJson(ex["previous"]))) {
            } else {
              examsLog.add(ExamsLog.fromJson(ex["previous"]));
            }

            exIDS = '$exIDS${ex["previous"]["id"]}-';
          }
        }
        args[3].add(QuestionModel(
            hurl: args[1][i]['h_url'],
            subjectID: args[4],
            note: (args[1][i]['question']['notes'] == null)
                ? null
                : (args[1][i]['question']['notes'] as List).isEmpty
                    ? null
                    : (args[1][i]['question']['notes'] as List).first['note'],
            quesId: args[1][i]['question']['id'],
            isMcq: 0,
            prevId: exIDS,
            quesContent: args[1][i]['question']['question_content'],
            quesNotes: args[1][i]['question']['question_notes'],
            subSubId: "-${args[5]}-",
            iswrong: 0,
            url: args[1][i]['question']['url'],
            isfavorite: 0));
      }
    }

    answer = args[1][i]['question']['answer'];

    if (args[1][i]['question']['is_mcq']) {
      await Future.forEach(answer, (element) async {
        AnswerModel answerObj = AnswerModel();
        element['correctness']
            ? answerObj = AnswerModel(
                correctness: 1,
                ansContent: element['answer_content'],
                ansId: element['id'],
                url: element['url'],
                ansNotes: element['answer_notes'],
                quesId: args[1][i]['question']['id'])
            : answerObj = AnswerModel(
                correctness: 0,
                url: element['url'],
                ansContent: element['answer_content'],
                ansId: element['id'],
                ansNotes: element['answer_notes'],
                quesId: args[1][i]['question']['id']);

        if (args[2].contains(answerObj)) {
        } else {
          args[2].add(answerObj);
          // batch.insert(tableAnswer, answerObj.toJson());
        }
      });
    } else {
      await Future.forEach(answer, (element) async {
        AnswerModel answerObj = AnswerModel();
        element['correctness'] ?? true
            ? answerObj = AnswerModel(
                correctness: 1,
                url: element['url'],
                ansContent: element['answer_content'],
                ansId: element['id'],
                ansNotes: element['answer_notes'],
                quesId: args[1][i]['question']['id'])
            : answerObj = AnswerModel(
                correctness: 0,
                url: element['url'],
                ansContent: element['answer_content'],
                ansId: element['id'],
                ansNotes: element['answer_notes'],
                quesId: args[1]['question'][i]['id']);
        if (args[2].contains(answerObj)) {
        } else {
          args[2].add(answerObj);
        }
      });
    }
  }
  sendPort.send([args[2], args[3], examsLog]);
  // Isolate.exit(sendPort, [args[2], args[3]]);
}

useIsolatesForSub3(List<dynamic> args) async {
  var ae = {};
  List<ExamsLog> examsLog = [];

  final SendPort sendPort = args[0];
  for (int i = (args[1].length / 3).floor() * 2; i < args[1].length; i++) {
    List answer = [];

    if (args[1][i]['question']['is_mcq']) {
      if (args[3].contains(QuestionModel(
          hurl: args[1][i]['h_url'],
          subjectID: args[4],
          note: (args[1][i]['question']['notes'] == null)
              ? null
              : (args[1][i]['question']['notes'] as List).isEmpty
                  ? null
                  : (args[1][i]['question']['notes'] as List).first['note'],
          quesId: args[1][i]['question']['id'],
          isMcq: 1,
          prevId: null,
          url: args[1][i]['question']['url'],
          quesContent: args[1][i]['question']['question_content'],
          quesNotes: args[1][i]['question']['question_notes'],
          subSubId: "-${args[5]}-",
          iswrong: 0,
          isfavorite: 0))) {
        // if (ae['id'] == args[1][i]['question_id']) {
        //   print(args[1][i]['question']['question_content']);
        //   ae['subIds'] = ae['subIds'] + "${args[1][i]['sub_subject_id']}-";
        // } else {
        //   for (var element in args[3]) {
        //     if (element.quesId == args[1][i]['question_id']) {
        //       element.subSubId = ae['subIds'];
        //     } else {
        //       break;
        //     }
        //   }

        //   ae = {
        //     'id': args[1][i]['question_id'],
        //     'subIds': "-${args[1][i]['sub_subject_id']}-"
        //   };
        // }
      } else {
        String? exIDS = '-';
        if ((args[1][i]['question']["previous_questions"] != null &&
            (args[1][i]['question']["previous_questions"] as List)
                .isNotEmpty)) {
          for (var ex
              in (args[1][i]['question']["previous_questions"] as List)) {
            if (examsLog.contains(ExamsLog.fromJson(ex["previous"]))) {
            } else {
              examsLog.add(ExamsLog.fromJson(ex["previous"]));
            }

            exIDS = '$exIDS${ex["previous"]["id"]}-';
          }
        }
        args[3].add(QuestionModel(
            hurl: args[1][i]['h_url'],
            subjectID: args[4],
            note: (args[1][i]['question']['notes'] == null)
                ? null
                : (args[1][i]['question']['notes'] as List).isEmpty
                    ? null
                    : (args[1][i]['question']['notes'] as List).first['note'],
            quesId: args[1][i]['question']['id'],
            isMcq: 1,
            prevId: exIDS,
            quesContent: args[1][i]['question']['question_content'],
            quesNotes: args[1][i]['question']['question_notes'],
            subSubId: "-${args[5]}-",
            iswrong: 0,
            url: args[1][i]['question']['url'],
            isfavorite: 0));
      }
    } else {
      if (args[3].contains(QuestionModel(
          hurl: args[1][i]['h_url'],
          subjectID: args[4],
          note: (args[1][i]['question']['notes'] == null)
              ? null
              : (args[1][i]['question']['notes'] as List).isEmpty
                  ? null
                  : (args[1][i]['question']['notes'] as List).first['note'],
          quesId: args[1][i]['question']['id'],
          isMcq: 0,
          prevId: null,
          quesContent: args[1][i]['question']['question_content'],
          quesNotes: args[1][i]['question']['question_notes'],
          subSubId: "-${args[5]}-",
          iswrong: 0,
          url: args[1][i]['question']['url'],
          isfavorite: 0))) {
      } else {
        String? exIDS = '-';
        if ((args[1][i]['question']["previous_questions"] != null &&
            (args[1][i]['question']["previous_questions"] as List)
                .isNotEmpty)) {
          for (var ex
              in (args[1][i]['question']["previous_questions"] as List)) {
            if (examsLog.contains(ExamsLog.fromJson(ex["previous"]))) {
            } else {
              examsLog.add(ExamsLog.fromJson(ex["previous"]));
            }

            exIDS = '$exIDS${ex["previous"]["id"]}-';
          }
        }
        args[3].add(QuestionModel(
            hurl: args[1][i]['h_url'],
            subjectID: args[4],
            note: (args[1][i]['question']['notes'] == null)
                ? null
                : (args[1][i]['question']['notes'] as List).isEmpty
                    ? null
                    : (args[1][i]['question']['notes'] as List).first['note'],
            quesId: args[1][i]['question']['id'],
            isMcq: 0,
            prevId: exIDS,
            quesContent: args[1][i]['question']['question_content'],
            quesNotes: args[1][i]['question']['question_notes'],
            subSubId: "-${args[5]}",
            iswrong: 0,
            url: args[1][i]['question']['url'],
            isfavorite: 0));
      }
    }

    answer = args[1][i]['question']['answer'];

    if (args[1][i]['question']['is_mcq']) {
      await Future.forEach(answer, (element) async {
        AnswerModel answerObj = AnswerModel();
        element['correctness']
            ? answerObj = AnswerModel(
                correctness: 1,
                ansContent: element['answer_content'],
                ansId: element['id'],
                url: element['url'],
                ansNotes: element['answer_notes'],
                quesId: args[1][i]['question']['id'])
            : answerObj = AnswerModel(
                correctness: 0,
                url: element['url'],
                ansContent: element['answer_content'],
                ansId: element['id'],
                ansNotes: element['answer_notes'],
                quesId: args[1][i]['question']['id']);

        if (args[2].contains(answerObj)) {
        } else {
          args[2].add(answerObj);
          // batch.insert(tableAnswer, answerObj.toJson());
        }
      });
    } else {
      await Future.forEach(answer, (element) async {
        AnswerModel answerObj = AnswerModel();
        element['correctness'] ?? true
            ? answerObj = AnswerModel(
                correctness: 1,
                url: element['url'],
                ansContent: element['answer_content'],
                ansId: element['id'],
                ansNotes: element['answer_notes'],
                quesId: args[1][i]['question']['id'])
            : answerObj = AnswerModel(
                correctness: 0,
                url: element['url'],
                ansContent: element['answer_content'],
                ansId: element['id'],
                ansNotes: element['answer_notes'],
                quesId: args[1][i]['question']['id']);
        if (args[2].contains(answerObj)) {
        } else {
          args[2].add(answerObj);
        }
      });
    }
  }
  sendPort.send([args[2], args[3], examsLog]);
  // Isolate.exit(sendPort, [args[2], args[3]]);
}

useIsolates(List<dynamic> args) async {
  var ae = {};
  List<ExamsLog> examsLog = [];
  final SendPort sendPort = args[0];
  for (int i = 0; i < (args[1].length / 3).floor(); i++) {
    List answer = [];

    if (args[1][i]['question']['is_mcq']) {
      if (args[3].contains(QuestionModel(
          hurl: args[1][i]['question']['h_url'],
          subjectID: args[1][i]['sub_subject']['subject_id'],
          note: (args[1][i]['question']['notes'] == null)
              ? null
              : (args[1][i]['question']['notes'] as List).isEmpty
                  ? null
                  : (args[1][i]['question']['notes'] as List).first['note'],
          quesId: args[1][i]['question_id'],
          isMcq: 1,
          prevId: null,
          url: args[1][i]['question']['url'],
          quesContent: args[1][i]['question']['question_content'],
          quesNotes: args[1][i]['question']['question_notes'],
          subSubId: "-${args[1][i]['sub_subject_id']}-",
          iswrong: 0,
          isfavorite: 0))) {
        QuestionModel? questionToUpdate =
            args[3].firstWhere((QuestionModel? que) {
          return args[1][i]['question_id'] == que!.quesId;
        });
        if (questionToUpdate != null) {
          questionToUpdate.subSubId =
              questionToUpdate.subSubId! + "${args[1][i]['sub_subject_id']}-";
        }
        // if (ae['id'] == args[1][i]['question_id']) {
        //   print(args[1][i]['question']['question_content']);
        //   ae['subIds'] = ae['subIds'] + "${args[1][i]['sub_subject_id']}-";
        // } else {
        //   for (var element in args[3]) {
        //     if (element.quesId == args[1][i]['question_id']) {
        //       element.subSubId = ae['subIds'];
        //     } else {
        //       break;
        //     }
        //   }

        //   ae = {
        //     'id': args[1][i]['question_id'],
        //     'subIds': "-${args[1][i]['sub_subject_id']}-"
        //   };
        // }
      } else {
        String? exIDS = '-';
        if ((args[1][i]['question']["previous_questions"] != null &&
            (args[1][i]['question']["previous_questions"] as List)
                .isNotEmpty)) {
          for (var ex
              in (args[1][i]['question']["previous_questions"] as List)) {
            if (examsLog.contains(ExamsLog.fromJson(ex["previous"]))) {
            } else {
              examsLog.add(ExamsLog.fromJson(ex["previous"]));
            }

            exIDS = '$exIDS${ex["previous"]["id"]}-';
          }
        }
        args[3].add(QuestionModel(
            hurl: args[1][i]['question']['h_url'],
            subjectID: args[1][i]['sub_subject']['subject_id'],
            note: (args[1][i]['question']['notes'] == null)
                ? null
                : (args[1][i]['question']['notes'] as List).isEmpty
                    ? null
                    : (args[1][i]['question']['notes'] as List).first['note'],
            quesId: args[1][i]['question_id'],
            isMcq: 1,
            prevId: exIDS,
            url: args[1][i]['question']['url'],
            quesContent: args[1][i]['question']['question_content'],
            quesNotes: args[1][i]['question']['question_notes'],
            subSubId: "-${args[1][i]['sub_subject_id']}-",
            iswrong: 0,
            isfavorite: 0));
      }
    } else {
      if (args[3].contains(QuestionModel(
          hurl: args[1][i]['question']['h_url'],
          subjectID: args[1][i]['sub_subject']['subject_id'],
          note: (args[1][i]['question']['notes'] == null)
              ? null
              : (args[1][i]['question']['notes'] as List).isEmpty
                  ? null
                  : (args[1][i]['question']['notes'] as List).first['note'],
          quesId: args[1][i]['question_id'],
          isMcq: 0,
          prevId: null,
          quesContent: args[1][i]['question']['question_content'],
          quesNotes: args[1][i]['question']['question_notes'],
          subSubId: "-${args[1][i]['sub_subject_id']}-",
          iswrong: 0,
          url: args[1][i]['question']['url'],
          isfavorite: 0))) {
        QuestionModel? questionToUpdate = args[3].firstWhere(
          (QuestionModel que) {
            return args[1][i]['question_id'] == que.quesId;
          },
        );
        if (questionToUpdate != null) {
          questionToUpdate.subSubId =
              questionToUpdate.subSubId! + "${args[1][i]['sub_subject_id']}-";
        }
      } else {
        String? exIDS = '-';
        if ((args[1][i]['question']["previous_questions"] != null &&
            (args[1][i]['question']["previous_questions"] as List)
                .isNotEmpty)) {
          for (var ex
              in (args[1][i]['question']["previous_questions"] as List)) {
            if (examsLog.contains(ExamsLog.fromJson(ex["previous"]))) {
            } else {
              examsLog.add(ExamsLog.fromJson(ex["previous"]));
            }

            exIDS = '$exIDS${ex["previous"]["id"]}-';
          }
        }
        args[3].add(QuestionModel(
            hurl: args[1][i]['question']['h_url'],
            subjectID: args[1][i]['sub_subject']['subject_id'],
            note: (args[1][i]['question']['notes'] == null)
                ? null
                : (args[1][i]['question']['notes'] as List).isEmpty
                    ? null
                    : (args[1][i]['question']['notes'] as List).first['note'],
            quesId: args[1][i]['question_id'],
            isMcq: 0,
            prevId: exIDS,
            quesContent: args[1][i]['question']['question_content'],
            quesNotes: args[1][i]['question']['question_notes'],
            subSubId: "-${args[1][i]['sub_subject_id']}-",
            iswrong: 0,
            url: args[1][i]['question']['url'],
            isfavorite: 0));
      }
    }

    answer = args[1][i]['question']['answer'];

    if (args[1][i]['question']['is_mcq']) {
      await Future.forEach(answer, (element) async {
        AnswerModel answerObj = AnswerModel();
        element['correctness']
            ? answerObj = AnswerModel(
                correctness: 1,
                ansContent: element['answer_content'],
                ansId: element['id'],
                url: element['url'],
                ansNotes: element['answer_notes'],
                quesId: args[1][i]['question_id'])
            : answerObj = AnswerModel(
                correctness: 0,
                url: element['url'],
                ansContent: element['answer_content'],
                ansId: element['id'],
                ansNotes: element['answer_notes'],
                quesId: args[1][i]['question_id']);

        if (args[2].contains(answerObj)) {
        } else {
          args[2].add(answerObj);
          // batch.insert(tableAnswer, answerObj.toJson());
        }
      });
    } else {
      await Future.forEach(answer, (element) async {
        AnswerModel answerObj = AnswerModel();
        element['correctness'] ?? true
            ? answerObj = AnswerModel(
                correctness: 1,
                url: element['url'],
                ansContent: element['answer_content'],
                ansId: element['id'],
                ansNotes: element['answer_notes'],
                quesId: args[1][i]['question_id'])
            : answerObj = AnswerModel(
                correctness: 0,
                url: element['url'],
                ansContent: element['answer_content'],
                ansId: element['id'],
                ansNotes: element['answer_notes'],
                quesId: args[1][i]['question_id']);
        if (args[2].contains(answerObj)) {
        } else {
          args[2].add(answerObj);
        }
      });
    }
  }
  sendPort.send([args[2], args[3], examsLog]);
  // Isolate.exit(sendPort, [args[2], args[3]]);
}

useIsolates2(List<dynamic> args) async {
  var ae = {};
  List<ExamsLog> examsLog = [];
  final SendPort sendPort = args[0];
  for (int i = (args[1].length / 3).floor();
      i < (args[1].length / 3).floor() * 2;
      i++) {
    List answer = [];

    if (args[1][i]['question']['is_mcq']) {
      if (args[3].contains(QuestionModel(
          hurl: args[1][i]['question']['h_url'],
          subjectID: args[1][i]['sub_subject']['subject_id'],
          note: (args[1][i]['question']['notes'] == null)
              ? null
              : (args[1][i]['question']['notes'] as List).isEmpty
                  ? null
                  : (args[1][i]['question']['notes'] as List).first['note'],
          quesId: args[1][i]['question_id'],
          isMcq: 1,
          prevId: null,
          url: args[1][i]['question']['url'],
          quesContent: args[1][i]['question']['question_content'],
          quesNotes: args[1][i]['question']['question_notes'],
          subSubId: "-${args[1][i]['sub_subject_id']}-",
          iswrong: 0,
          isfavorite: 0))) {
        QuestionModel? questionToUpdate = args[3].firstWhere(
          (QuestionModel que) {
            return args[1][i]['question_id'] == que.quesId;
          },
        );
        if (questionToUpdate != null) {
          questionToUpdate.subSubId =
              questionToUpdate.subSubId! + "${args[1][i]['sub_subject_id']}-";
        }
      } else {
        String? exIDS = '-';
        if ((args[1][i]['question']["previous_questions"] != null &&
            (args[1][i]['question']["previous_questions"] as List)
                .isNotEmpty)) {
          for (var ex
              in (args[1][i]['question']["previous_questions"] as List)) {
            if (examsLog.contains(ExamsLog.fromJson(ex["previous"]))) {
            } else {
              examsLog.add(ExamsLog.fromJson(ex["previous"]));
            }

            exIDS = '$exIDS${ex["previous"]["id"]}-';
          }
        }
        args[3].add(QuestionModel(
            hurl: args[1][i]['question']['h_url'],
            subjectID: args[1][i]['sub_subject']['subject_id'],
            note: (args[1][i]['question']['notes'] == null)
                ? null
                : (args[1][i]['question']['notes'] as List).isEmpty
                    ? null
                    : (args[1][i]['question']['notes'] as List).first['note'],
            quesId: args[1][i]['question_id'],
            isMcq: 1,
            prevId: exIDS,
            url: args[1][i]['question']['url'],
            quesContent: args[1][i]['question']['question_content'],
            quesNotes: args[1][i]['question']['question_notes'],
            subSubId: "-${args[1][i]['sub_subject_id']}-",
            iswrong: 0,
            isfavorite: 0));
      }
    } else {
      if (args[3].contains(QuestionModel(
          hurl: args[1][i]['question']['h_url'],
          subjectID: args[1][i]['sub_subject']['subject_id'],
          note: (args[1][i]['question']['notes'] == null)
              ? null
              : (args[1][i]['question']['notes'] as List).isEmpty
                  ? null
                  : (args[1][i]['question']['notes'] as List).first['note'],
          quesId: args[1][i]['question_id'],
          isMcq: 0,
          prevId: null,
          quesContent: args[1][i]['question']['question_content'],
          quesNotes: args[1][i]['question']['question_notes'],
          subSubId: "-${args[1][i]['sub_subject_id']}-",
          iswrong: 0,
          url: args[1][i]['question']['url'],
          isfavorite: 0))) {
        QuestionModel? questionToUpdate = args[3].firstWhere(
          (QuestionModel que) {
            return args[1][i]['question_id'] == que.quesId;
          },
        );
        if (questionToUpdate != null) {
          questionToUpdate.subSubId =
              questionToUpdate.subSubId! + "${args[1][i]['sub_subject_id']}-";
        }
      } else {
        String? exIDS = '-';
        if ((args[1][i]['question']["previous_questions"] != null &&
            (args[1][i]['question']["previous_questions"] as List)
                .isNotEmpty)) {
          for (var ex
              in (args[1][i]['question']["previous_questions"] as List)) {
            if (examsLog.contains(ExamsLog.fromJson(ex["previous"]))) {
            } else {
              examsLog.add(ExamsLog.fromJson(ex["previous"]));
            }

            exIDS = '$exIDS${ex["previous"]["id"]}-';
          }
        }
        args[3].add(QuestionModel(
            hurl: args[1][i]['question']['h_url'],
            subjectID: args[1][i]['sub_subject']['subject_id'],
            note: (args[1][i]['question']['notes'] == null)
                ? null
                : (args[1][i]['question']['notes'] as List).isEmpty
                    ? null
                    : (args[1][i]['question']['notes'] as List).first['note'],
            quesId: args[1][i]['question_id'],
            isMcq: 0,
            prevId: exIDS,
            quesContent: args[1][i]['question']['question_content'],
            quesNotes: args[1][i]['question']['question_notes'],
            subSubId: "-${args[1][i]['sub_subject_id']}-",
            iswrong: 0,
            url: args[1][i]['question']['url'],
            isfavorite: 0));
      }
    }

    answer = args[1][i]['question']['answer'];

    if (args[1][i]['question']['is_mcq']) {
      await Future.forEach(answer, (element) async {
        AnswerModel answerObj = AnswerModel();
        element['correctness']
            ? answerObj = AnswerModel(
                correctness: 1,
                ansContent: element['answer_content'],
                ansId: element['id'],
                url: element['url'],
                ansNotes: element['answer_notes'],
                quesId: args[1][i]['question_id'])
            : answerObj = AnswerModel(
                correctness: 0,
                url: element['url'],
                ansContent: element['answer_content'],
                ansId: element['id'],
                ansNotes: element['answer_notes'],
                quesId: args[1][i]['question_id']);

        if (args[2].contains(answerObj)) {
        } else {
          args[2].add(answerObj);
          // batch.insert(tableAnswer, answerObj.toJson());
        }
      });
    } else {
      await Future.forEach(answer, (element) async {
        AnswerModel answerObj = AnswerModel();
        element['correctness'] ?? true
            ? answerObj = AnswerModel(
                correctness: 1,
                url: element['url'],
                ansContent: element['answer_content'],
                ansId: element['id'],
                ansNotes: element['answer_notes'],
                quesId: args[1][i]['question_id'])
            : answerObj = AnswerModel(
                correctness: 0,
                url: element['url'],
                ansContent: element['answer_content'],
                ansId: element['id'],
                ansNotes: element['answer_notes'],
                quesId: args[1][i]['question_id']);
        if (args[2].contains(answerObj)) {
        } else {
          args[2].add(answerObj);
        }
      });
    }
  }
  sendPort.send([args[2], args[3], examsLog]);
  // Isolate.exit(sendPort, [args[2], args[3]]);
}

useIsolates3(List<dynamic> args) async {
  var ae = {};
  List<ExamsLog> examsLog = [];
  final SendPort sendPort = args[0];
  for (int i = (args[1].length / 3).floor() * 2; i < args[1].length; i++) {
    List answer = [];

    if (args[1][i]['question']['is_mcq']) {
      if (args[3].contains(QuestionModel(
          hurl: args[1][i]['question']['h_url'],
          subjectID: args[1][i]['sub_subject']['subject_id'],
          note: (args[1][i]['question']['notes'] == null)
              ? null
              : (args[1][i]['question']['notes'] as List).isEmpty
                  ? null
                  : (args[1][i]['question']['notes'] as List).first['note'],
          quesId: args[1][i]['question_id'],
          isMcq: 1,
          prevId: null,
          url: args[1][i]['question']['url'],
          quesContent: args[1][i]['question']['question_content'],
          quesNotes: args[1][i]['question']['question_notes'],
          subSubId: "-${args[1][i]['sub_subject_id']}-",
          iswrong: 0,
          isfavorite: 0))) {
        QuestionModel? questionToUpdate = args[3].firstWhere(
          (QuestionModel que) {
            return args[1][i]['question_id'] == que.quesId;
          },
        );
        if (questionToUpdate != null) {
          questionToUpdate.subSubId =
              questionToUpdate.subSubId! + "${args[1][i]['sub_subject_id']}-";
        }
      } else {
        String? exIDS = '-';
        if ((args[1][i]['question']["previous_questions"] != null &&
            (args[1][i]['question']["previous_questions"] as List)
                .isNotEmpty)) {
          for (var ex
              in (args[1][i]['question']["previous_questions"] as List)) {
            if (examsLog.contains(ExamsLog.fromJson(ex["previous"]))) {
            } else {
              examsLog.add(ExamsLog.fromJson(ex["previous"]));
            }

            exIDS = '$exIDS${ex["previous"]["id"]}-';
          }
        }
        args[3].add(QuestionModel(
            hurl: args[1][i]['question']['h_url'],
            subjectID: args[1][i]['sub_subject']['subject_id'],
            note: (args[1][i]['question']['notes'] == null)
                ? null
                : (args[1][i]['question']['notes'] as List).isEmpty
                    ? null
                    : (args[1][i]['question']['notes'] as List).first['note'],
            quesId: args[1][i]['question_id'],
            isMcq: 1,
            prevId: exIDS,
            url: args[1][i]['question']['url'],
            quesContent: args[1][i]['question']['question_content'],
            quesNotes: args[1][i]['question']['question_notes'],
            subSubId: "-${args[1][i]['sub_subject_id']}-",
            iswrong: 0,
            isfavorite: 0));
      }
    } else {
      if (args[3].contains(QuestionModel(
          hurl: args[1][i]['question']['h_url'],
          subjectID: args[1][i]['sub_subject']['subject_id'],
          note: (args[1][i]['question']['notes'] == null)
              ? null
              : (args[1][i]['question']['notes'] as List).isEmpty
                  ? null
                  : (args[1][i]['question']['notes'] as List).first['note'],
          quesId: args[1][i]['question_id'],
          isMcq: 0,
          prevId: null,
          quesContent: args[1][i]['question']['question_content'],
          quesNotes: args[1][i]['question']['question_notes'],
          subSubId: "-${args[1][i]['sub_subject_id']}-",
          iswrong: 0,
          url: args[1][i]['question']['url'],
          isfavorite: 0))) {
        QuestionModel? questionToUpdate = args[3].firstWhere(
          (QuestionModel que) {
            return args[1][i]['question_id'] == que.quesId;
          },
        );
        if (questionToUpdate != null) {
          questionToUpdate.subSubId =
              questionToUpdate.subSubId! + "${args[1][i]['sub_subject_id']}-";
        }
      } else {
        String? exIDS = '-';
        if ((args[1][i]['question']["previous_questions"] != null &&
            (args[1][i]['question']["previous_questions"] as List)
                .isNotEmpty)) {
          for (var ex
              in (args[1][i]['question']["previous_questions"] as List)) {
            if (examsLog.contains(ExamsLog.fromJson(ex["previous"]))) {
            } else {
              examsLog.add(ExamsLog.fromJson(ex["previous"]));
            }

            exIDS = '$exIDS${ex["previous"]["id"]}-';
          }
        }
        args[3].add(QuestionModel(
            hurl: args[1][i]['question']['h_url'],
            subjectID: args[1][i]['sub_subject']['subject_id'],
            note: (args[1][i]['question']['notes'] == null)
                ? null
                : (args[1][i]['question']['notes'] as List).isEmpty
                    ? null
                    : (args[1][i]['question']['notes'] as List).first['note'],
            quesId: args[1][i]['question_id'],
            isMcq: 0,
            prevId: exIDS,
            quesContent: args[1][i]['question']['question_content'],
            quesNotes: args[1][i]['question']['question_notes'],
            subSubId: "-${args[1][i]['sub_subject_id']}-",
            iswrong: 0,
            url: args[1][i]['question']['url'],
            isfavorite: 0));
      }
    }

    answer = args[1][i]['question']['answer'];

    if (args[1][i]['question']['is_mcq']) {
      await Future.forEach(answer, (element) async {
        AnswerModel answerObj = AnswerModel();
        element['correctness']
            ? answerObj = AnswerModel(
                correctness: 1,
                ansContent: element['answer_content'],
                ansId: element['id'],
                url: element['url'],
                ansNotes: element['answer_notes'],
                quesId: args[1][i]['question_id'])
            : answerObj = AnswerModel(
                correctness: 0,
                url: element['url'],
                ansContent: element['answer_content'],
                ansId: element['id'],
                ansNotes: element['answer_notes'],
                quesId: args[1][i]['question_id']);

        if (args[2].contains(answerObj)) {
        } else {
          args[2].add(answerObj);
          // batch.insert(tableAnswer, answerObj.toJson());
        }
      });
    } else {
      await Future.forEach(answer, (element) async {
        AnswerModel answerObj = AnswerModel();
        element['correctness'] ?? true
            ? answerObj = AnswerModel(
                correctness: 1,
                url: element['url'],
                ansContent: element['answer_content'],
                ansId: element['id'],
                ansNotes: element['answer_notes'],
                quesId: args[1][i]['question_id'])
            : answerObj = AnswerModel(
                correctness: 0,
                url: element['url'],
                ansContent: element['answer_content'],
                ansId: element['id'],
                ansNotes: element['answer_notes'],
                quesId: args[1][i]['question_id']);
        if (args[2].contains(answerObj)) {
        } else {
          args[2].add(answerObj);
        }
      });
    }
  }
  sendPort.send([args[2], args[3], examsLog]);
  // Isolate.exit(sendPort, [args[2], args[3]]);
}

class QuestionDataSource {
  Function eq = const ListEquality().equals;
  TextController textController = Get.find();
  static QuestionDataSource instance = QuestionDataSource();
  Future<List<QuestionWithAnswer>?> getAllUserQuestions() async {
    int uId = textController.pref!.getInt('u_id')!;
    String token = textController.pref!.getString('token')!;
    var encodedBody = json.encode({"user_id": uId!, "token": token});
    // print(encodedBody);

    if (await checkConnection()) {
      try {
        var response = await http.put(
            Uri.parse(
                '${baseUrl}houdix/seen/app/user/get-user-questions-optimized/$uId'),
            headers: {'Content-Type': 'application/json'},
            body: encodedBody);

        // List<AnswerModel?>? localAnswers = await getAllAnswer();
        // List<QuestionModel?>? localQuestions = await getAllQuestion();
        List<AnswerModel> answers = [];
        List<QuestionModel> allQuestions = [];

        print('start' + DateTime.now().minute.toString());
        if ((jsonDecode(response.body)).runtimeType == List<dynamic>) {
          List<dynamic> a = (jsonDecode(response.body));

          // List<dynamic> a = e.getRange(0, 1000).toList();
          await clearAnswerTable();
          await clearQuestionTable();
          await clearExamsTable();
          Completer<bool> _completer = Completer<bool>();
          Completer<bool> _completer2 = Completer<bool>();
          Completer<bool> _completer3 = Completer<bool>();
          final ReceivePort receivePort = ReceivePort();
          final ReceivePort receivePort2 = ReceivePort();
          final ReceivePort receivePort3 = ReceivePort();

          Isolate.spawn(
              useIsolates, [receivePort.sendPort, a, answers, allQuestions]);
          Isolate.spawn(
              useIsolates2, [receivePort2.sendPort, a, answers, allQuestions]);

          Isolate.spawn(
              useIsolates3, [receivePort3.sendPort, a, answers, allQuestions]);

          bool sub1Ended = false;
          bool sub2Ended = false;
          bool sub3Ended = false;
          // await Future.forEach(a, (e) async {});
          receivePort.listen((message) async {
            await Future.forEach(message[1] as List<QuestionModel>,
                (element) async {
              await Future.forEach(element.subSubId!.split('-'), (el) async {
                if (el == '') {
                } else {
                  int? fatherId =
                      await getFatherIDSubSubjects(int.parse(el.trim()));
                  if (fatherId != null) {
                    await updateSubSubjectIfcontainsData(fatherId, 1);
                  }
                  await updateSubSubjectIfcontainsData(int.parse(el.trim()), 1);
                }
                // await updateSubjectIfcontainsData(int.parse(el), 1);
              });
              await insertQ(element);
            });
            await Future.forEach(message[0] as List<AnswerModel>,
                (element) async {
              await insertAnswer(element);
            });
            await Future.forEach(message[2] as List<ExamsLog>, (element) async {
              await insertEX(element);
            });
            // Handle the message received from the second isolate
            print('first isolate is done!');
            sub1Ended = true;
            _completer.isCompleted ? {} : _completer.complete(sub1Ended);
            print('end' + DateTime.now().minute.toString());
          }).onDone(() {});
          receivePort2.listen((message) async {
            await Future.forEach(message[1] as List<QuestionModel>,
                (element) async {
              // print('question_gnsddddddddddddddddddddddid');
              // // print((element as QuestionModel).note);
              // print('question_gnsddddddddddddddddddddddid');

              await Future.forEach(element.subSubId!.split('-'), (el) async {
                if (el == '') {
                } else {
                  int? fatherId =
                      await getFatherIDSubSubjects(int.parse(el.trim()));
                  if (fatherId != null) {
                    await updateSubSubjectIfcontainsData(fatherId, 1);
                  }
                  await updateSubSubjectIfcontainsData(int.parse(el.trim()), 1);
                }
                // await updateSubjectIfcontainsData(int.parse(el), 1);
              });
              await insertQ(element);
            });
            await Future.forEach(message[0] as List<AnswerModel>,
                (element) async {
              await insertAnswer(element);
            });
            await Future.forEach(message[2] as List<ExamsLog>, (element) async {
              await insertEX(element);
            });
            // Handle the message received from the second isolate
            print('Second isolate is done!');
            sub2Ended = true;
            _completer2.isCompleted ? {} : _completer2.complete(sub2Ended);
            print('end' + DateTime.now().minute.toString());
          }).onDone(() {});
          receivePort3.listen((message) async {
            await Future.forEach(message[1] as List<QuestionModel>,
                (element) async {
              // // print((element as QuestionModel).note);
              // print('question_gnsddddddddddddddddddddddid');

              await Future.forEach(element.subSubId!.split('-'), (el) async {
                if (el == '') {
                } else {
                  int? fatherId =
                      await getFatherIDSubSubjects(int.parse(el.trim()));
                  if (fatherId != null) {
                    await updateSubSubjectIfcontainsData(fatherId, 1);
                  }
                  await updateSubSubjectIfcontainsData(int.parse(el.trim()), 1);
                }
                // await updateSubjectIfcontainsData(int.parse(el), 1);
              });
              await insertQ(element);
            });
            await Future.forEach(message[0] as List<AnswerModel>,
                (element) async {
              await insertAnswer(element);
            });
            await Future.forEach(message[2] as List<ExamsLog>, (element) async {
              await insertEX(element);
            });
            // Handle the message received from the second isolate
            print('third isolate is done!');
            sub3Ended = true;
            _completer3.isCompleted ? {} : _completer3.complete(sub3Ended);
            print('end' + DateTime.now().minute.toString());
          }).onDone(() {});
          bool result = await _completer.future;
          bool result2 = await _completer2.future;
          bool result3 = await _completer3.future;
          print('######################################');
          List<int?>? subjectIds = await getSubjectsID();
          await Future.forEach(
            subjectIds!,
            (element) async {
              int res = await checkQuestionWithAnswersForSubject(element!);

              if (res == 1) {
                await updateSubjectIfcontainsData(element, 1);
              } else {
                await updateSubjectIfcontainsData(element, 0);
              }
            },
          );
          await WrongAnswerDataSource.instace.getAllWrongAnswers();

          // await BackgroundDataSource.instance.getFavorites();
          Get.back();
        }
        return <QuestionWithAnswer>[];
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {
      return [];
    }
  }

  Future<List<QuestionWithAnswer>?> getAllUserQuestionsForSubject(id) async {
    int uId = textController.pref!.getInt('u_id')!;
    String token = textController.pref!.getString('token')!;
    var encodedBody = json.encode({"subject_id": id, "token": token});

    if (await checkConnection()) {
      try {
        var response = await http.put(
            Uri.parse(
                '${baseUrl}houdix/seen/app/user/get-user-questions-one-subject/$uId'),
            headers: {'Content-Type': 'application/json'},
            body: encodedBody);

        // List<AnswerModel?>? localAnswers = await getAllAnswer();
        // List<QuestionModel?>? localQuestions = await getAllQuestion();
        List<AnswerModel> answers = [];
        List<QuestionModel> allQuestions = [];

        print('start' + DateTime.now().minute.toString());

        if ((jsonDecode(response.body)).runtimeType == List<dynamic>) {
          List<dynamic> a = (jsonDecode(response.body));

          // List<dynamic> a = e.getRange(0, 1000).toList();
          List<int?>? qIds = await getAllQuestionIDForSubject(id);
          await clearAnswerForSubject(qIds ?? []);
          await clearQuestionsForSubject(id);
          await clearExamsForSubject(id);
          Completer<bool> _completer = Completer<bool>();
          Completer<bool> _completer2 = Completer<bool>();
          Completer<bool> _completer3 = Completer<bool>();
          final ReceivePort receivePort = ReceivePort();
          final ReceivePort receivePort2 = ReceivePort();
          final ReceivePort receivePort3 = ReceivePort();

          Isolate.spawn(
              useIsolates, [receivePort.sendPort, a, answers, allQuestions]);
          Isolate.spawn(
              useIsolates2, [receivePort2.sendPort, a, answers, allQuestions]);

          Isolate.spawn(
              useIsolates3, [receivePort3.sendPort, a, answers, allQuestions]);

          bool sub1Ended = false;
          bool sub2Ended = false;
          bool sub3Ended = false;
          // await Future.forEach(a, (e) async {});
          receivePort.listen((message) async {
            await Future.forEach(message[1] as List<QuestionModel>,
                (element) async {
              await Future.forEach(element.subSubId!.split('-'), (el) async {
                if (el == '') {
                } else {
                  int? fatherId =
                      await getFatherIDSubSubjects(int.parse(el.trim()));
                  if (fatherId != null) {
                    await updateSubSubjectIfcontainsData(fatherId, 1);
                  }
                  await updateSubSubjectIfcontainsData(int.parse(el.trim()), 1);
                }
                // await updateSubjectIfcontainsData(int.parse(el), 1);
              });

              await insertQ(element);
            });
            await Future.forEach(message[0] as List<AnswerModel>,
                (element) async {
              await insertAnswer(element);
            });
            await Future.forEach(message[2] as List<ExamsLog>, (element) async {
              await insertEX(element);
            });
            // Handle the message received from the second isolate
            print('first isolate is done!');
            sub1Ended = true;
            _completer.isCompleted ? {} : _completer.complete(sub1Ended);
            print('end' + DateTime.now().minute.toString());
          }).onDone(() {});
          receivePort2.listen((message) async {
            await Future.forEach(message[1] as List<QuestionModel>,
                (element) async {
              await Future.forEach(element.subSubId!.split('-'), (el) async {
                if (el == '') {
                } else {
                  int? fatherId =
                      await getFatherIDSubSubjects(int.parse(el.trim()));
                  if (fatherId != null) {
                    await updateSubSubjectIfcontainsData(fatherId, 1);
                  }
                  await updateSubSubjectIfcontainsData(int.parse(el.trim()), 1);
                }
                // await updateSubjectIfcontainsData(int.parse(el), 1);
              });
              await insertQ(element);
            });
            await Future.forEach(message[0] as List<AnswerModel>,
                (element) async {
              await insertAnswer(element);
            });
            await Future.forEach(message[2] as List<ExamsLog>, (element) async {
              await insertEX(element);
            });
            // Handle the message received from the second isolate
            print('Second isolate is done!');
            sub2Ended = true;
            _completer2.isCompleted ? {} : _completer2.complete(sub2Ended);
            print('end' + DateTime.now().minute.toString());
          }).onDone(() {});
          receivePort3.listen((message) async {
            await Future.forEach(message[1] as List<QuestionModel>,
                (element) async {
              await Future.forEach(element.subSubId!.split('-'), (el) async {
                if (el == '') {
                } else {
                  int? fatherId =
                      await getFatherIDSubSubjects(int.parse(el.trim()));
                  if (fatherId != null) {
                    await updateSubSubjectIfcontainsData(fatherId, 1);
                  }
                  await updateSubSubjectIfcontainsData(int.parse(el.trim()), 1);
                }
                // await updateSubjectIfcontainsData(int.parse(el), 1);
              });
              await insertQ(element);
            });
            await Future.forEach(message[0] as List<AnswerModel>,
                (element) async {
              await insertAnswer(element);
            });
            await Future.forEach(message[2] as List<ExamsLog>, (element) async {
              await insertEX(element);
            });
            // Handle the message received from the second isolate
            print('third isolate is done!');
            sub3Ended = true;
            _completer3.isCompleted ? {} : _completer3.complete(sub3Ended);
            print('end' + DateTime.now().minute.toString());
          }).onDone(() {});
          bool result = await _completer.future;
          bool result2 = await _completer2.future;
          bool result3 = await _completer3.future;
          print('######################################');
          // if (a.isNotEmpty) {
          await updateSubjectIfcontainsData(id, 1);

          // await BackgroundDataSource.instance.getFavorites();
        }
        return <QuestionWithAnswer>[];
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {
      return [];
    }
  }

  Future<List<QuestionWithAnswer>?> getAllUserQuestionsForSubSubject(
      id, subjectID, bool isFather) async {
    int uId = textController.pref!.getInt('u_id')!;
    String token = textController.pref!.getString('token')!;
    var encodedBody = json.encode({"sub_subject_id": id, "token": token});

    if (await checkConnection()) {
      try {
        var response = await http.put(
            Uri.parse(
                '${baseUrl}houdix/seen/app/sub-subject/get-unlocked-sub/$uId'),
            headers: {'Content-Type': 'application/json'},
            body: encodedBody);

        // List<AnswerModel?>? localAnswers = await getAllAnswer();
        // List<QuestionModel?>? localQuestions = await getAllQuestion();
        List<AnswerModel> answers = [];
        List<QuestionModel> allQuestions = [];

        print('start' + DateTime.now().minute.toString());
        if ((jsonDecode(response.body)).runtimeType == List<dynamic>) {
          List<dynamic> a = (jsonDecode(response.body));
          List<SubSubject?>? subsSubQtodelete =
              await getSubSubjectsForFather(id);
          // List<dynamic> a = e.getRange(0, 1000).toList();
          if (subsSubQtodelete != null && subsSubQtodelete.isNotEmpty) {
            await Future.forEach(
              subsSubQtodelete,
              (element) async {
                List<int?>? qIds =
                    await getAllQuestionIDForSubSubject(element!.id!);
                await clearAnswerForSubject(qIds ?? []);
                await clearQuestionsForSubSubject(element!.id!);
              },
            );
          }

          Completer<bool> _completer = Completer<bool>();
          Completer<bool> _completer2 = Completer<bool>();
          Completer<bool> _completer3 = Completer<bool>();
          final ReceivePort receivePort = ReceivePort();
          final ReceivePort receivePort2 = ReceivePort();
          final ReceivePort receivePort3 = ReceivePort();

          Isolate.spawn(useIsolates,
              [receivePort.sendPort, a, answers, allQuestions, subjectID, id]);
          Isolate.spawn(useIsolates2,
              [receivePort2.sendPort, a, answers, allQuestions, subjectID, id]);

          Isolate.spawn(useIsolates3,
              [receivePort3.sendPort, a, answers, allQuestions, subjectID, id]);

          bool sub1Ended = false;
          bool sub2Ended = false;
          bool sub3Ended = false;
          // await Future.forEach(a, (e) async {});
          receivePort.listen((message) async {
            await Future.forEach(message[1] as List<QuestionModel>,
                (element) async {
              await insertQ(element);
            });
            await Future.forEach(message[0] as List<AnswerModel>,
                (element) async {
              await insertAnswer(element);
            });
            // await Future.forEach(message[2] as List<ExamsLog>, (element) async {
            //   await insertEX(element);
            // });
            // Handle the message received from the second isolate
            print('first isolate is done!');
            sub1Ended = true;
            _completer.isCompleted ? {} : _completer.complete(sub1Ended);
            print('end' + DateTime.now().minute.toString());
          }).onDone(() {});
          receivePort2.listen((message) async {
            await Future.forEach(message[1] as List<QuestionModel>,
                (element) async {
              // print('question_gnsddddddddddddddddddddddid');
              // // print((element as QuestionModel).note);
              // print('question_gnsddddddddddddddddddddddid');
              await insertQ(element);
            });
            await Future.forEach(message[0] as List<AnswerModel>,
                (element) async {
              await insertAnswer(element);
            });
            // await Future.forEach(message[2] as List<ExamsLog>, (element) async {
            //   await insertEX(element);
            // });
            // Handle the message received from the second isolate
            print('Second isolate is done!');
            sub2Ended = true;
            _completer2.isCompleted ? {} : _completer2.complete(sub2Ended);
            print('end' + DateTime.now().minute.toString());
          }).onDone(() {});
          receivePort3.listen((message) async {
            await Future.forEach(message[1] as List<QuestionModel>,
                (element) async {
              // // print((element as QuestionModel).note);
              // print('question_gnsddddddddddddddddddddddid');
              await insertQ(element);
            });
            await Future.forEach(message[0] as List<AnswerModel>,
                (element) async {
              await insertAnswer(element);
            });
            await Future.forEach(message[2] as List<ExamsLog>, (element) async {
              await insertEX(element);
            });
            // Handle the message received from the second isolate
            print('third isolate is done!');
            sub3Ended = true;
            _completer3.isCompleted ? {} : _completer3.complete(sub3Ended);
            print('end' + DateTime.now().minute.toString());
          }).onDone(() {});
          bool result = await _completer.future;
          bool result2 = await _completer2.future;
          bool result3 = await _completer3.future;
          print('######################################');
          // if (a.isNotEmpty) {
          //   if (isFather) {
          //     List<SubSubject?>? subsSub = await getSubSubjectsForFather(id);
          //     await updateSubSubjectIfcontainsData(id, 1);
          //     if (subsSub != null) {
          //       subsSub.map((e) async =>
          //           await updateSubSubjectIfcontainsData(e!.id!, 1));
          //     }
          //   } else {
          //     await updateSubSubjectIfcontainsData(id, 1);
          //   }
          // }

          // await BackgroundDataSource.instance.getFavorites();

          if (isFather) {
            List<SubSubject?>? subsSub = await getSubSubjectsForFather(id);
            await updateSubSubjectIfcontainsData(id, 1);
            await updateSubSubjectIfItsOpen(id, 1);
            if (subsSub != null) {
              await Future.forEach(subsSub, (e) async {
                // if (e!.id == 1728) {
                //   print('############# done #####################');
                // }
                await updateSubSubjectIfcontainsData(e!.id!, 1);
                return await updateSubSubjectIfItsOpen(e!.id!, 1);
              });
            }
          } else {
            await updateSubSubjectIfItsOpen(id, 1);
            await updateSubSubjectIfcontainsData(id, 1);
          }
          // await updateSubjectIfcontainsData(subjectID, 1);
        }

        // await updateSubjectStatus(subjectID, 1);
        ;
        return <QuestionWithAnswer>[];
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {
      return [];
    }
  }

  Future<List<QuestionWithAnswer>> getQuestions(int subSubject) async {
    int uId = textController.pref!.getInt('u_id')!;
    String token = textController.pref!.getString('token')!;

    var encodedBody = json.encode({"user_id": uId!, "token": token});

    final db = await SubjectLocalDataSource().dbe;
    Batch batch = db!.batch();
    if (await checkConnection()) {
      try {
        var response = await http.put(
            Uri.parse('${baseUrl}houdix/seen/app/question/get-sub/$subSubject'),
            headers: {'Content-Type': 'application/json'},
            body: encodedBody);

        List<dynamic> a = (jsonDecode(response.body)).map((e) async {
          List answer = [];

          if (e['is_mcq']) {
            await insertQ(QuestionModel(
                hurl: e['question']['h_url'],
                subjectID: e['sub_subject']['subject_id'],
                note: (e['notes'] == null)
                    ? null
                    : (e['notes'] as List).isEmpty
                        ? null
                        : (e['notes'] as List).first['note'],
                quesId: e['question_id'],
                isMcq: 0,
                prevId: e['question']['previous_id'],
                quesContent: e['question']['question_content'],
                quesNotes: e['question']['question_notes'],
                subSubId: "${e['sub_subject_id']}-",
                iswrong: 0,
                url: e['question']['url'],
                isfavorite: 0));
          } else {
            await insertQ(QuestionModel(
                hurl: e['question']['h_url'],
                subjectID: e['sub_subject']['subject_id'],
                note: (e['notes'] == null)
                    ? null
                    : (e['notes'] as List).isEmpty
                        ? null
                        : (e['notes'] as List).first['note'],
                quesId: e['question_id'],
                isMcq: 0,
                prevId: e['question']['previous_id'],
                quesContent: e['question']['question_content'],
                quesNotes: e['question']['question_notes'],
                subSubId: "${e['sub_subject_id']}-",
                iswrong: 0,
                url: e['question']['url'],
                isfavorite: 0));
          }

          answer = e['answer'];

          if (e['is_mcq']) {
            for (Map<String, dynamic> element in answer) {
              AnswerModel answerObj = AnswerModel();
              element['correctness']
                  ? answerObj = AnswerModel(
                      correctness: 1,
                      url: element['url'],
                      ansContent: element['answer_content'],
                      ansId: element['id'],
                      ansNotes: element['answer_notes'],
                      quesId: e['id'])
                  : answerObj = AnswerModel(
                      url: element['url'],
                      correctness: 0,
                      ansContent: element['answer_content'],
                      ansId: element['id'],
                      ansNotes: element['answer_notes'],
                      quesId: e['id']);
              await insertAnswer(
                answerObj,
              );
            }
          } else {
            for (Map<String, dynamic> element in answer) {
              AnswerModel answerObj = AnswerModel();
              element['correctness']
                  ? answerObj = AnswerModel(
                      url: element['url'],
                      correctness: 1,
                      ansContent: element['answer_content'],
                      ansId: element['id'],
                      ansNotes: element['answer_notes'],
                      quesId: e['id'])
                  : answerObj = AnswerModel(
                      correctness: 0,
                      url: element['url'],
                      ansContent: element['answer_content'],
                      ansId: element['id'],
                      ansNotes: element['answer_notes'],
                      quesId: e['id']);
              await insertAnswer(
                answerObj,
              );
            }
          }
        }).toList();

        return [];
      } catch (e) {
        throw Exception(e);
      }
    } else {
      Get.defaultDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
        title: 'لا يوجد اتصال',
        titleStyle: ownStyle(Colors.red, 16.5),
        content: Text(
          'الرجاء التأكد من اتصالك بالانترنت والمحاولة مرة أخرى',
          textAlign: TextAlign.center,
          style: ownStyle(Get.theme.primaryColor, 14.5),
        ),
      );
      return [];
    }
  }
}

// import 'dart:convert';
// import 'dart:isolate';
// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import 'package:get/get.dart';
// import 'package:seen/core/Services/Network.dart';
// import 'package:seen/core/constants/url.dart';
// import 'package:seen/model/DataSource/WrongAnswerDataSource.dart';
// import 'package:seen/model/LocalDataSource.dart/LocalData.dart';
// import 'package:seen/model/entites/AnswerModel.dart';
// import 'package:seen/model/entites/QuestionWithAnswer.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../controller/text_controller.dart';
// import '../../core/constants/TextStyles.dart';
// import '../../core/functions/QuestionFunction.dart';
// import '../../core/functions/localDataFunctions/AnsewrsFunction.dart';
// import '../../core/functions/localDataFunctions/userAnswerFunction.dart';
// import '../entites/QuestionModel.dart';

// useIsolates(
//   List<dynamic> a,
// ) async {
//   final ReceivePort receivePort = ReceivePort();
//   try {
//     await Isolate.spawn((e) async {
//       List<AnswerModel> answers = [];
//       List allQuestions = [];
//       final SendPort sendPort = e;
//       for (int i = 0; i < (a.length / 2).floor(); i++) {
//         List answer = [];
//         print(a[i]);
//         if (a[i]['question']['is_mcq']) {
//           allQuestions.add(QuestionModel(
//               note: (a[i]['question']['notes'] == null)
//                   ? null
//                   : (a[i]['question']['notes'] as List).isEmpty
//                       ? null
//                       : (a[i]['question']['notes'] as List).first['note'],
//               quesId: a[i]['question_id'],
//               isMcq: 1,
//               prevId: a[i]['question']['previous_id'],
//               url: a[i]['question']['url'],
//               quesContent: a[i]['question']['question_content'],
//               quesNotes: a[i]['question']['question_notes'],
//               subSubId: a[i]['sub_subject_id'],
//               iswrong: 0,
//               isfavorite: 0));
//         } else {
//           allQuestions.add(QuestionModel(
//               note: (a[i]['question']['notes'] == null)
//                   ? null
//                   : (a[i]['question']['notes'] as List).isEmpty
//                       ? null
//                       : (a[i]['question']['notes'] as List).first['note'],
//               quesId: a[i]['question_id'],
//               isMcq: 0,
//               prevId: a[i]['question']['previous_id'],
//               quesContent: a[i]['question']['question_content'],
//               quesNotes: a[i]['question']['question_notes'],
//               subSubId: a[i]['sub_subject_id'],
//               iswrong: 0,
//               url: a[i]['question']['url'],
//               isfavorite: 0));
//         }

//         answer = a[i]['question']['answer'];

//         if (a[i]['question']['is_mcq']) {
//           for (Map<String, dynamic> element in answer) {
//             AnswerModel answerObj = AnswerModel();
//             element['correctness']
//                 ? answerObj = AnswerModel(
//                     correctness: 1,
//                     ansContent: element['answer_content'],
//                     ansId: element['id'],
//                     url: element['url'],
//                     ansNotes: element['answer_notes'],
//                     quesId: a[i]['question_id'])
//                 : answerObj = AnswerModel(
//                     correctness: 0,
//                     url: element['url'],
//                     ansContent: element['answer_content'],
//                     ansId: element['id'],
//                     ansNotes: element['answer_notes'],
//                     quesId: a[i]['question_id']);

//             if (answers.contains(answerObj)) {
//             } else {
//               answers.add(answerObj);
//             }
//           }
//         } else {
//           for (Map<String, dynamic> element in answer) {
//             AnswerModel answerObj = AnswerModel();
//             element['correctness'] ?? true
//                 ? answerObj = AnswerModel(
//                     correctness: 1,
//                     url: element['url'],
//                     ansContent: element['answer_content'],
//                     ansId: element['id'],
//                     ansNotes: element['answer_notes'],
//                     quesId: a[i]['question_id'])
//                 : answerObj = AnswerModel(
//                     correctness: 0,
//                     url: element['url'],
//                     ansContent: element['answer_content'],
//                     ansId: element['id'],
//                     ansNotes: element['answer_notes'],
//                     quesId: a[i]['question_id']);
//             if (answers.contains(answerObj)) {
//             } else {
//               answers.add(answerObj);
//             }
//           }
//         }
//       }
//       await Future.forEach(allQuestions, (element) async {
//         // print('question_gnsddddddddddddddddddddddid');
//         // // print((element as QuestionModel).note);
//         // print('question_gnsddddddddddddddddddddddid');
//         await insertQ(element);
//       });
//       await Future.forEach(answers, (element) async {
//         await insertAnswer(element);
//       });
//     }, receivePort.sendPort);
//     Isolate.exit(receivePort.sendPort, 0);
//   } catch (e) {
//     throw Exception(e);
//   }
// }

// useIsolates2(
//   List<dynamic> a,
// ) async {
//   final ReceivePort receivePort = ReceivePort();
//   try {
//     await Isolate.spawn((e) async {
//       List<AnswerModel> answers = [];
//       List allQuestions = [];
//       final SendPort sendPort = e;
//       for (int i = (a.length ~/ 2).floor(); i < a.length; i++) {
//         List answer = [];

//         if (a[i]['question']['is_mcq']) {
//           allQuestions.add(QuestionModel(
//               note: (a[i]['question']['notes'] == null)
//                   ? null
//                   : (a[i]['question']['notes'] as List).isEmpty
//                       ? null
//                       : (a[i]['question']['notes'] as List).first['note'],
//               quesId: a[i]['question_id'],
//               isMcq: 1,
//               prevId: a[i]['question']['previous_id'],
//               url: a[i]['question']['url'],
//               quesContent: a[i]['question']['question_content'],
//               quesNotes: a[i]['question']['question_notes'],
//               subSubId: a[i]['sub_subject_id'],
//               iswrong: 0,
//               isfavorite: 0));
//         } else {
//           allQuestions.add(QuestionModel(
//               note: (a[i]['question']['notes'] == null)
//                   ? null
//                   : (a[i]['question']['notes'] as List).isEmpty
//                       ? null
//                       : (a[i]['question']['notes'] as List).first['note'],
//               quesId: a[i]['question_id'],
//               isMcq: 0,
//               prevId: a[i]['question']['previous_id'],
//               quesContent: a[i]['question']['question_content'],
//               quesNotes: a[i]['question']['question_notes'],
//               subSubId: a[i]['sub_subject_id'],
//               iswrong: 0,
//               url: a[i]['question']['url'],
//               isfavorite: 0));
//         }

//         answer = a[i]['question']['answer'];

//         if (a[i]['question']['is_mcq']) {
//           for (Map<String, dynamic> element in answer) {
//             AnswerModel answerObj = AnswerModel();
//             element['correctness']
//                 ? answerObj = AnswerModel(
//                     correctness: 1,
//                     ansContent: element['answer_content'],
//                     ansId: element['id'],
//                     url: element['url'],
//                     ansNotes: element['answer_notes'],
//                     quesId: a[i]['question_id'])
//                 : answerObj = AnswerModel(
//                     correctness: 0,
//                     url: element['url'],
//                     ansContent: element['answer_content'],
//                     ansId: element['id'],
//                     ansNotes: element['answer_notes'],
//                     quesId: a[i]['question_id']);

//             if (answers.contains(answerObj)) {
//             } else {
//               answers.add(answerObj);
//             }
//           }
//         } else {
//           for (Map<String, dynamic> element in answer) {
//             AnswerModel answerObj = AnswerModel();
//             element['correctness'] ?? true
//                 ? answerObj = AnswerModel(
//                     correctness: 1,
//                     url: element['url'],
//                     ansContent: element['answer_content'],
//                     ansId: element['id'],
//                     ansNotes: element['answer_notes'],
//                     quesId: a[i]['question_id'])
//                 : answerObj = AnswerModel(
//                     correctness: 0,
//                     url: element['url'],
//                     ansContent: element['answer_content'],
//                     ansId: element['id'],
//                     ansNotes: element['answer_notes'],
//                     quesId: a[i]['question_id']);
//             if (answers.contains(answerObj)) {
//             } else {
//               answers.add(answerObj);
//             }
//           }
//         }
//       }
//       await Future.forEach(allQuestions, (element) async {
//         // print('question_gnsddddddddddddddddddddddid');
//         // // print((element as QuestionModel).note);
//         // print('question_gnsddddddddddddddddddddddid');
//         await insertQ(element);
//       });
//       await Future.forEach(answers, (element) async {
//         await insertAnswer(element);
//       });
//       Isolate.exit(sendPort, 0);
//     }, receivePort.sendPort);
//   } catch (e) {
//     throw Exception(e);
//   }
// }

// divideList1() {}

// class QuestionDataSource {
//   Function eq = const ListEquality().equals;
//   TextController textController = Get.find();
//   static QuestionDataSource instance = QuestionDataSource();
//   Future<List<QuestionWithAnswer>?> getAllUserQuestions() async {
//     int uId = textController.pref!.getInt('u_id')!;
//     String token = textController.pref!.getString('token')!;
//     var encodedBody = json.encode({"user_id": uId!, "token": token});

//     if (await checkConnection()) {
//       try {
//         var response = await http.put(
//             Uri.parse('${baseUrl}houdix/seen/app/user/get-user-questions/$uId'),
//             headers: {'Content-Type': 'application/json'},
//             body: encodedBody);

//         // List<AnswerModel?>? localAnswers = await getAllAnswer();
//         // List<QuestionModel?>? localQuestions = await getAllQuestion();

//         print('start' + DateTime.now().minute.toString());
//         if ((jsonDecode(response.body)).runtimeType == List<dynamic>) {
//           List<dynamic> a = (jsonDecode(response.body));
//           print(a);
//           await clearQuestionTable();
//           await clearAnswerTable();
//           useIsolates(
//             a,
//           );
//           useIsolates2(
//             a,
//           );
//           // if (!eq(allQuestions, localQuestions)) {

//           // } else {
//           //   // Get.defaultDialog(
//           //   //   contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
//           //   //   title: 'لا يوجد تغيير على الاسئلة',
//           //   //   titleStyle: ownStyle(Colors.red, 16.5),
//           //   //   content: Text(
//           //   //     'لديك النسخة  المحدثة',
//           //   //     textAlign: TextAlign.center,
//           //   //     style: ownStyle(Get.theme.primaryColor, 14.5),
//           //   //   ),
//           //   // );
//           // }

//           // if (!eq(answers, localAnswers)) {

//           // } else {
//           //   // Get.defaultDialog(
//           //   //   contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
//           //   //   title: 'لا يوجد تغيير على الاجوبة',
//           //   //   titleStyle: ownStyle(Colors.red, 16.5),
//           //   //   content: Text(
//           //   //     'لديك النسخة المحدثة',
//           //   //     textAlign: TextAlign.center,
//           //   //     style: ownStyle(Get.theme.primaryColor, 14.5),
//           //   //   ),
//           //   // );
//           // }
//         }
//         print('end' + DateTime.now().minute.toString());
//         return [];
//       } catch (e) {
//         debugPrint(e.toString());
//       }
//     } else {
//       return [];
//     }
//   }

//   Future<List<QuestionWithAnswer>> getQuestions(int subSubject) async {
//     int uId = textController.pref!.getInt('u_id')!;
//     String token = textController.pref!.getString('token')!;
//     var encodedBody = json.encode({"user_id": uId!, "token": token});
//     if (await checkConnection()) {
//       try {
//         var response = await http.put(
//             Uri.parse('${baseUrl}houdix/seen/app/question/get-sub/$subSubject'),
//             headers: {'Content-Type': 'application/json'},
//             body: encodedBody);

//         List<dynamic> a = (jsonDecode(response.body)).map((e) async {
//           List answer = [];

//           if (e['is_mcq']) {
//             await insertQ(QuestionModel(
//                 note: (e['notes'] == null)
//                     ? null
//                     : (e['notes'] as List).isEmpty
//                         ? null
//                         : (e['notes'] as List).first['note'],
//                 quesId: e['question_id'],
//                 isMcq: 0,
//                 prevId: e['question']['previous_id'],
//                 quesContent: e['question']['question_content'],
//                 quesNotes: e['question']['question_notes'],
//                 subSubId: e['sub_subject_id'],
//                 iswrong: 0,
//                 url: e['question']['url'],
//                 isfavorite: 0));
//           } else {
//             await insertQ(QuestionModel(
//                 note: (e['notes'] == null)
//                     ? null
//                     : (e['notes'] as List).isEmpty
//                         ? null
//                         : (e['notes'] as List).first['note'],
//                 quesId: e['question_id'],
//                 isMcq: 0,
//                 prevId: e['question']['previous_id'],
//                 quesContent: e['question']['question_content'],
//                 quesNotes: e['question']['question_notes'],
//                 subSubId: e['sub_subject_id'],
//                 iswrong: 0,
//                 url: e['question']['url'],
//                 isfavorite: 0));
//           }

//           answer = e['answer'];

//           if (e['is_mcq']) {
//             for (Map<String, dynamic> element in answer) {
//               AnswerModel answerObj = AnswerModel();
//               element['correctness']
//                   ? answerObj = AnswerModel(
//                       correctness: 1,
//                       url: element['url'],
//                       ansContent: element['answer_content'],
//                       ansId: element['id'],
//                       ansNotes: element['answer_notes'],
//                       quesId: e['id'])
//                   : answerObj = AnswerModel(
//                       url: element['url'],
//                       correctness: 0,
//                       ansContent: element['answer_content'],
//                       ansId: element['id'],
//                       ansNotes: element['answer_notes'],
//                       quesId: e['id']);
//               await insertAnswer(answerObj);
//             }
//           } else {
//             for (Map<String, dynamic> element in answer) {
//               AnswerModel answerObj = AnswerModel();
//               element['correctness']
//                   ? answerObj = AnswerModel(
//                       url: element['url'],
//                       correctness: 1,
//                       ansContent: element['answer_content'],
//                       ansId: element['id'],
//                       ansNotes: element['answer_notes'],
//                       quesId: e['id'])
//                   : answerObj = AnswerModel(
//                       correctness: 0,
//                       url: element['url'],
//                       ansContent: element['answer_content'],
//                       ansId: element['id'],
//                       ansNotes: element['answer_notes'],
//                       quesId: e['id']);
//               await insertAnswer(answerObj);
//             }
//           }
//         }).toList();

//         return [];
//       } catch (e) {
//         throw Exception(e);
//       }
//     } else {
//       Get.defaultDialog(
//         contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
//         title: 'لا يوجد اتصال',
//         titleStyle: ownStyle(Colors.red, 16.5),
//         content: Text(
//           'الرجاء التأكد من اتصالك بالانترنت والمحاولة مرة أخرى',
//           textAlign: TextAlign.center,
//           style: ownStyle(Get.theme.primaryColor, 14.5),
//         ),
//       );
//       return [];
//     }
//   }
// }
