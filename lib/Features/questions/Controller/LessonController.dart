import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:seen/Features/questions/Controller/ProgressController.dart';

import '../../../core/functions/QuestionFunction.dart';
import '../../../core/functions/localDataFunctions/CurrentSession.dart';
import '../../../core/functions/localDataFunctions/SubsubjectsFunction.dart';
import '../../../shared/model/LocalDataSource.dart/LocalData.dart';
import '../../Sections/controller/indexQuestionController/indexQuestionsController.dart';

import '../model/classes/QuestionAnswerModel.dart';
import 'CheckAnswerController/checkAnswerController.dart';

class LessonController extends GetxController {
  List<QuestionAnswerModel?>? ans = [];
  CheckAnswerController checkAnswerController =
      Get.put(CheckAnswerController());

  IndexQuestionController indexQuestionController =
      Get.put(IndexQuestionController());

  bool isAllFave = false;
  bool isAllWrong = false;
  bool isFave = false;
  bool isPreiviosQuestios = false;
  bool isRandomize = false;
  RxBool isShuffleAnswers = false.obs;
  bool isWrong = false;
  RxString lesson = ''.obs;
  RxBool loading = true.obs;
  RxInt mathIndex = 0.obs;
  int numberOfCorrectQA = 0;
  RxInt numberOfQA = 00.obs;
  List<ScrollController> scrollControllers = [];
  RxInt numberOfRemainingQA = 0.obs;
  int numberOfWrongQA = 0;
  Progresscontroller progresscontroller = Get.put(Progresscontroller());
  bool resetGroup = false;
  bool showHint = false;

  resetSectionDivider() {
    isRandomize = false;
    isPreiviosQuestios = false;
    isWrong = false;
    isFave = false;
    isAllWrong = false;
    isAllFave = false;
  }

  setUpCounters() {
    if (checkAnswerController.check) {
      if (checkAnswerController.solvedAnswer.isNotEmpty) {
        for (int element = 0; element < ans!.length; element++) {
          if (element >= checkAnswerController.solvedAnswer.length) {
            // _lessonController.numberOfWrongQA++;
          } else {
            if (!checkAnswerController.solvedAnswer[element]['correctness']) {
              // updateWrongness(
              //     checkAnswerController.solvedAnswer[element]['questionId'], 1);
              numberOfWrongQA++;
            } else {
              // updateWrongness(
              //     checkAnswerController.solvedAnswer[element]['questionId'], 0);
              numberOfCorrectQA++;
            }
          }
        }
      } else {
        // _lessonController.numberOfWrongQA =
        //     _lessonController.numberOfQA.value;
      }
    }

    if (checkAnswerController.restoreAlreadycheck) {
      if (checkAnswerController.doubleCheckedAnswer.isNotEmpty) {
        numberOfWrongQA = 0;
        numberOfCorrectQA = 0;
        for (int element = 0;
            element < checkAnswerController.doubleCheckedAnswer.length;
            element++) {
          if (!checkAnswerController.doubleCheckedAnswer[element]
              ['correctness']) {
            numberOfWrongQA++;
          } else {
            numberOfCorrectQA++;
          }
        }
      }
    }
  }

  setQuestionList(int? subjectid, int? id, bool iswrong, bool isPreveios,
      bool isFavorites, bool isMath) async {
    indexQuestionController.index = 0;
    await resetQuestions();
    ans = [];

    checkAnswerController.check = false;
    checkAnswerController.solvedCheck = false;
    checkAnswerController.restoreAlreadycheck = false;
    await resetSectionDivider();
    checkAnswerController.solvedAnswer = [];
    checkAnswerController.doubleCheckedAnswer = [];

    if (isPreveios) {
      isPreiviosQuestios = true;

      ans = await getPreviosWithAnswers(id!);

      List<dynamic>? session = await getPreviousSessions(id);

      if (ans != null) {
        if (session!.isNotEmpty) {
          session.sort((a, b) => a!['q_index'].compareTo(b!['q_index']));

          for (Map<String, dynamic> element in session) {
            for (int i = 0; i < ans!.length; i++) {
              if (ans![i]!.id == element['q_id']) {
                ans![i]!.groupValue = int.parse(element['choice']);

                if (element[alreadyChecked] == 1) {
                  checkAnswerController.solvedAnswer.add({
                    csSubjectID: element[csSubjectID],
                    cspreviousIdCol: element[cspreviousIdCol],
                    'a_index': element[answer_index],
                    'subid': element[csSubId],
                    'choice': int.parse(element['choice']),
                    alreadyChecked: true,
                    "answerId": int.parse(element['choice']),
                    'is_wrong': ans![i]!.isWrong,
                    "correctness":
                        element[correctnessColumn] == 1 ? true : false,
                    "answerContent": element[answerContent],
                    "questionId": element[question_id],
                    "index": element['q_index'],
                    "correctIndex": element['correctIndex']
                  });
                  checkAnswerController.doubleCheckedAnswer.add({
                    csSubjectID: element[csSubjectID],
                    cspreviousIdCol: element[cspreviousIdCol],
                    'a_index': element[answer_index],
                    'subid': element[csSubId],
                    'choice': int.parse(element['choice']),
                    'is_wrong': ans![i]!.isWrong,
                    alreadyChecked: true,
                    "answerId": int.parse(element['choice']),
                    "correctness":
                        element[correctnessColumn] == 1 ? true : false,
                    "answerContent": element[answerContent],
                    "questionId": element[question_id],
                    "index": element['q_index'],
                    "correctIndex": element['correctIndex']
                  });
                } else {
                  checkAnswerController.solvedAnswer.add({
                    csSubjectID: element[csSubjectID],
                    cspreviousIdCol: element[cspreviousIdCol],
                    'a_index': element[answer_index],
                    'subid': element[csSubId],
                    'choice': int.parse(element['choice']),
                    alreadyChecked: false,
                    "answerId": int.parse(element['choice']),
                    'is_wrong': ans![i]!.isWrong,
                    "correctness":
                        element[correctnessColumn] == 1 ? true : false,
                    "answerContent": element[answerContent],
                    "questionId": element[question_id],
                    "index": element['q_index'],
                    "correctIndex": element['correctIndex']
                  });
                }
              }
            }
          }
          if (checkAnswerController.doubleCheckedAnswer.isNotEmpty) {
            checkAnswerController.restoreAlreadycheck = true;
          } else {
            checkAnswerController.restoreAlreadycheck = false;
          }
          indexQuestionController.index = session.last['q_index'] == null
              ? 0
              : session.last['q_index'] > 3
                  ? session.last['q_index']
                  : 0;

          numberOfRemainingQA.value = ans!.length - session.length;
        } else {
          numberOfRemainingQA.value = ans!.length;
        }
        numberOfQA.value = ans!.length;

        update();
      } else {
        numberOfQA.value = 0;
        numberOfRemainingQA.value = 0;
      }
    }

    if (iswrong) {
      checkAnswerController.solvedAnswer.clear();
      checkAnswerController.doubleCheckedAnswer.clear();
      List? session = [];

      if (subjectid == null) {
        isWrong = true;
        session = await getWrongnessSessions(id!);

        List<QuestionAnswerModel?>? tempQ =
            await getWrongQuestionWithAnswers(id);
        if (tempQ != null && tempQ.isNotEmpty) {
          ans = [];
          ans = tempQ;
        }
      } else {
        isAllWrong = true;
        session = await getAllWrongnessSessions(subjectid);
        // List<int?>? subIds = await getSubSubjectsidForSubject(subjectid);

        ans = [];

        ans = await getWrongQuestionWithAnswersForSubject(subjectid);
      }

      if (ans != null) {
        if (session!.isNotEmpty) {
          session.sort((a, b) => a!['q_index'].compareTo(b!['q_index']));

          for (Map<String, dynamic> element in session) {
            for (int i = 0; i < ans!.length; i++) {
              if (ans![i]!.id == element['q_id']) {
                ans![i]!.groupValue = int.parse(element['choice']);

                if (element[alreadyChecked] == 1) {
                  checkAnswerController.solvedAnswer.add({
                    csSubjectID: element[csSubjectID],
                    nextShowDate: ans![i]!.nextDate,
                    rightTimes: ans![i]!.right_times,
                    cspreviousIdCol: element[cspreviousIdCol],
                    'a_index': element[answer_index],
                    'subid': element[csSubId],
                    'choice': int.parse(element['choice']),
                    alreadyChecked: true,
                    "answerId": int.parse(element['choice']),
                    "correctness":
                        element[correctnessColumn] == 1 ? true : false,
                    "answerContent": element[answerContent],
                    "questionId": element[question_id],
                    'is_wrong': ans![i]!.isWrong,
                    "index": element['q_index'],
                    "correctIndex": element['correctIndex']
                  });
                  checkAnswerController.doubleCheckedAnswer.add({
                    csSubjectID: element[csSubjectID],
                    cspreviousIdCol: element[cspreviousIdCol],
                    'a_index': element[answer_index],
                    'subid': element[csSubId],
                    'choice': int.parse(element['choice']),
                    alreadyChecked: true,
                    "answerId": int.parse(element['choice']),
                    'is_wrong': ans![i]!.isWrong,
                    "correctness":
                        element[correctnessColumn] == 1 ? true : false,
                    "answerContent": element[answerContent],
                    "questionId": element[question_id],
                    "index": element['q_index'],
                    "correctIndex": element['correctIndex']
                  });
                } else {
                  checkAnswerController.solvedAnswer.add({
                    csSubjectID: element[csSubjectID],
                    nextShowDate: ans![i]!.nextDate,
                    rightTimes: ans![i]!.right_times,
                    cspreviousIdCol: element[cspreviousIdCol],
                    'a_index': element[answer_index],
                    'subid': element[csSubId],
                    'choice': int.parse(element['choice']),
                    alreadyChecked: false,
                    "answerId": int.parse(element['choice']),
                    'is_wrong': ans![i]!.isWrong,
                    "correctness":
                        element[correctnessColumn] == 1 ? true : false,
                    "answerContent": element[answerContent],
                    "questionId": element[question_id],
                    "index": element['q_index'],
                    "correctIndex": element['correctIndex']
                  });
                }
              } else {}
            }
          }
          if (checkAnswerController.doubleCheckedAnswer.isNotEmpty) {
            checkAnswerController.restoreAlreadycheck = true;
          } else {
            checkAnswerController.restoreAlreadycheck = false;
          }
          indexQuestionController.index = session.last['q_index'] == null
              ? 0
              : session.last['q_index'] > 3
                  ? session.last['q_index']
                  : 0;

          numberOfRemainingQA.value =
              ans!.length - checkAnswerController.solvedAnswer.length;
        } else {
          numberOfRemainingQA.value = ans!.length;
        }
        numberOfQA.value = ans!.length;
      } else {
        numberOfQA.value = 0;
        numberOfRemainingQA.value = 0;
      }
    }
    if (isFavorites) {
      List<dynamic>? session = [];
      if (subjectid == null) {
        isFave = true;
        session = await getFavoritesSessions(id!);
        List<QuestionAnswerModel?>? tempQ =
            await getFavoritesQuestionWithAnswers(id);
        if (tempQ != null && tempQ.isNotEmpty) {
          ans = [];
          ans = tempQ;
        }
        for (var element in session!) {}
      } else {
        isAllFave = true;
        session = await getAllFavoritesSessions(subjectid);
        List<int?>? subIds = await getSubSubjectsidForSubject(subjectid);
        ans = [];
        for (var ele in subIds!) {
          var tempList = await getFavoritesQuestionWithAnswers(ele!);

          if (tempList == null) {
          } else {
            for (var element in tempList) {
              ans!.add(element);
            }
          }
        }
      }

      if (ans != null) {
        if (session!.isNotEmpty) {
          session.sort((a, b) => a!['q_index'].compareTo(b!['q_index']));

          for (Map<String, dynamic> element in session) {
            for (int i = 0; i < ans!.length; i++) {
              if (ans![i]!.id == element['q_id']) {
                ans![i]!.groupValue = int.parse(element['choice']);

                if (element[alreadyChecked] == 1) {
                  checkAnswerController.solvedAnswer.add({
                    csSubjectID: element[csSubjectID],
                    nextShowDate: ans![i]!.nextDate,
                    rightTimes: ans![i]!.right_times,
                    cspreviousIdCol: element[cspreviousIdCol],
                    'a_index': element[answer_index],
                    'subid': element[csSubId],
                    'choice': int.parse(element['choice']),
                    alreadyChecked: true,
                    "answerId": int.parse(element['choice']),
                    'is_wrong': ans![i]!.isWrong,
                    "correctness":
                        element[correctnessColumn] == 1 ? true : false,
                    "answerContent": element[answerContent],
                    "questionId": element[question_id],
                    "index": element['q_index'],
                    "correctIndex": element['correctIndex']
                  });
                  checkAnswerController.doubleCheckedAnswer.add({
                    csSubjectID: element[csSubjectID],
                    cspreviousIdCol: element[cspreviousIdCol],
                    'a_index': element[answer_index],
                    'subid': element[csSubId],
                    'choice': int.parse(element['choice']),
                    alreadyChecked: true,
                    "answerId": int.parse(element['choice']),
                    'is_wrong': ans![i]!.isWrong,
                    "correctness":
                        element[correctnessColumn] == 1 ? true : false,
                    "answerContent": element[answerContent],
                    "questionId": element[question_id],
                    "index": element['q_index'],
                    "correctIndex": element['correctIndex']
                  });
                } else {
                  checkAnswerController.solvedAnswer.add({
                    'is_wrong': ans![i]!.isWrong,
                    csSubjectID: element[csSubjectID],
                    cspreviousIdCol: element[cspreviousIdCol],
                    nextShowDate: ans![i]!.nextDate,
                    rightTimes: ans![i]!.right_times,
                    'a_index': element[answer_index],
                    'subid': element[csSubId],
                    'choice': int.parse(element['choice']),
                    alreadyChecked: false,
                    "answerId": int.parse(element['choice']),
                    "correctness":
                        element[correctnessColumn] == 1 ? true : false,
                    "answerContent": element[answerContent],
                    "questionId": element[question_id],
                    "index": element['q_index'],
                    "correctIndex": element['correctIndex']
                  });
                }
              } else {}
            }
          }
          if (checkAnswerController.doubleCheckedAnswer.isNotEmpty) {
            checkAnswerController.restoreAlreadycheck = true;
          } else {
            checkAnswerController.restoreAlreadycheck = false;
          }
          indexQuestionController.index = session.last['q_index'] == null
              ? 0
              : session.last['q_index'] > 3
                  ? session.last['q_index']
                  : 0;

          numberOfRemainingQA.value =
              ans!.length - checkAnswerController.solvedAnswer.length;
        } else {
          numberOfRemainingQA.value = ans!.length;
        }
        numberOfQA.value = ans!.length;
      } else {
        numberOfQA.value = 0;
        numberOfRemainingQA.value = 0;
      }
    }
    if (!isPreveios && !iswrong && !isFavorites) {
      ans = await getQuestionWithAnswers(id!);
      print(ans);
      List<dynamic>? session = await getSessions(id);

      if (ans != null) {
        if (session!.isNotEmpty) {
          session.sort((a, b) => a!['q_index'].compareTo(b!['q_index']));

          for (Map<String, dynamic> element in session) {
            for (int i = 0; i < ans!.length; i++) {
              if (ans![i]!.id == element['q_id']) {
                ans![i]!.groupValue = int.parse(element['choice']);

                if (element[alreadyChecked] == 1) {
                  checkAnswerController.solvedAnswer.add({
                    csSubjectID: element[csSubjectID],
                    nextShowDate: ans![i]!.nextDate,
                    rightTimes: ans![i]!.right_times,
                    cspreviousIdCol: element[cspreviousIdCol],
                    'a_index': element[answer_index],
                    'subid': element[csSubId],
                    'choice': int.parse(element['choice']),
                    alreadyChecked: true,
                    "answerId": int.parse(element['choice']),
                    'is_wrong': ans![i]!.isWrong,
                    "correctness":
                        element[correctnessColumn] == 1 ? true : false,
                    "answerContent": element[answerContent],
                    "questionId": element[question_id],
                    "index": element['q_index'],
                    "correctIndex": element['correctIndex']
                  });
                  checkAnswerController.doubleCheckedAnswer.add({
                    csSubjectID: element[csSubjectID],
                    cspreviousIdCol: element[cspreviousIdCol],
                    'a_index': element[answer_index],
                    'is_wrong': ans![i]!.isWrong,
                    'subid': element[csSubId],
                    'choice': int.parse(element['choice']),
                    alreadyChecked: true,
                    "answerId": int.parse(element['choice']),
                    "correctness":
                        element[correctnessColumn] == 1 ? true : false,
                    "answerContent": element[answerContent],
                    "questionId": element[question_id],
                    "index": element['q_index'],
                    "correctIndex": element['correctIndex']
                  });
                } else {
                  checkAnswerController.solvedAnswer.add({
                    csSubjectID: element[csSubjectID],
                    'is_wrong': ans![i]!.isWrong,
                    nextShowDate: ans![i]!.nextDate,
                    rightTimes: ans![i]!.right_times,
                    cspreviousIdCol: element[cspreviousIdCol],
                    'a_index': element[answer_index],
                    'subid': element[csSubId],
                    'choice': int.parse(element['choice']),
                    alreadyChecked: false,
                    "answerId": int.parse(element['choice']),
                    "correctness":
                        element[correctnessColumn] == 1 ? true : false,
                    "answerContent": element[answerContent],
                    "questionId": element[question_id],
                    "index": element['q_index'],
                    "correctIndex": element['correctIndex']
                  });
                }
              } else {}
            }
          }
          if (checkAnswerController.doubleCheckedAnswer.isNotEmpty) {
            checkAnswerController.restoreAlreadycheck = true;
          } else {
            checkAnswerController.restoreAlreadycheck = false;
          }
          indexQuestionController.index = session.last['q_index'] == null
              ? 0
              : session.last['q_index'] > 3
                  ? session.last['q_index']
                  : 0;
          if (isMath) {
            // scrollControllers.addAll(List.filled(ans!.length, ScrollController()));
            mathIndex.value = session.last['q_index'] ?? 0;
          }
          numberOfRemainingQA.value = ans!.length - session.length;
        } else {
          numberOfRemainingQA.value = ans!.length;
        }
        numberOfQA.value = ans!.length;
      } else {
        numberOfQA.value = 0;
        numberOfRemainingQA.value = 0;
      }
    }

    await Future.delayed(const Duration(seconds: 1));
    // if (isMath) {
    //   if (ans != null && ans!.isNotEmpty) {
    //     progresscontroller.calculateProgressPrecentage(
    //         ans!.length, mathIndex.value);
    //   }
    // }
    // print('##################hello math#####');
    loading.value = false;
    // update();
  }

  // setLesson(lesson) {
  //   this.lesson.value = lesson;
  //   update();
  // }

  // RightOrWrong rightOrWrong = Get.put(RightOrWrong());

  // selectCorrectAnswer() {
  //   numberOfCorrectQA.value++;
  //   numberOfRemainingQA.value--;
  //   numberOfQA.value++;
  //   update();
  // }

  // selectWrongAnswer() {
  //   numberOfWrongQA.value++;
  //   numberOfRemainingQA.value--;
  //   numberOfQA.value++;
  //   update();
  // }

  // in seconds

  resetQuestions() {
    numberOfRemainingQA.value = ans == null ? 0 : ans!.length;
    numberOfCorrectQA = 0;
    numberOfWrongQA = 0;
  }

  // updateWrongness(numberOfCorrectQA) {
  //   this.numberOfCorrectQA += 1;
  //   update();
  // }
}
