import 'dart:async';
import 'dart:isolate';

import 'package:collection/collection.dart';
import 'package:get/get.dart';

import 'package:seen/core/functions/localDataFunctions/ActiveCoupon.dart';

import 'package:seen/Features/questions/screens/MathQuestionsScreen.dart';

import 'package:seen/Features/questions/screens/questions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/functions/ActiveCodeFunction.dart';
import '../../../core/functions/QuestionFunction.dart';
import '../../../core/functions/localDataFunctions/CurrentSession.dart';
import '../../../core/functions/localDataFunctions/RandomizeQuestionsFunction.dart';
import '../../../core/functions/localDataFunctions/SubjectFunctions.dart';
import '../../../core/functions/localDataFunctions/SubsubjectsFunction.dart';

import '../../../shared/model/LocalDataSource.dart/LocalData.dart';
import '../../CodeManaging/model/classes/ActiveCodesLocal.dart';
import '../../CodeManaging/model/classes/ActiveCouponsLocal.dart';
import '../../Sections/controller/indexQuestionController/indexQuestionsController.dart';
import '../../Sections/model/classes/SubSubjects.dart';
import '../../Sections/model/classes/SubjectModule.dart';
import '../../questions/Controller/CheckAnswerController/checkAnswerController.dart';
import '../../questions/Controller/LessonController.dart';
import '../../questions/Controller/ProgressController.dart';
import '../../questions/model/classes/QuestionAnswerModel.dart';

randomizeIsolate(List<dynamic> args) async {
  List<QuestionAnswerModel?>? f = [];
  final SendPort sendPort = args[0];
  for (int i = 0; i < (args[1]!.length / 2).floor(); i++) {
    await Future.forEach(args[2], (QuestionAnswerModel e) {
      if (e.id == args[1]![i]![randomQuestionId]) {
        f.add(e);
      }
    });
  }

  sendPort.send([f]);
  // Isolate.exit(sendPort, [args[2], args[3]]);
}

randomizeIsolate2(List<dynamic> args) async {
  List<QuestionAnswerModel?>? f = [];
  final SendPort sendPort = args[0];
  for (var e in args[1]) {
    for (int i = (args[2]!.length / 2).floor(); i < args[2]!.length; i++) {
      if (args[2]![i]!.id == e![randomQuestionId]) {
        f.add(args[2]![i]!);
      }
    }
  }

  sendPort.send([f]);
  // Isolate.exit(sendPort, [args[2], args[3]]);
}

class RandomizeController extends GetxController {
  List<int> baseId = [];
  List<int> subIds = [];
  int questionToSolveNumber = 0;
  RxInt numberOfQuestion = 0.obs;
  Progresscontroller progresscontroller = Get.put(Progresscontroller());
  RxBool numberOfQuestionLoading = false.obs;
  final LessonController _lessonController = Get.find();
  CheckAnswerController checkAnswerController = Get.find();
  IndexQuestionController indexQuestionController = Get.find();

  int tempNumberOfRemaining = 0;
  List<QuestionAnswerModel?>? questionWithAnswer = [];
  List<Subject?>? subjects = [];
  List<int> subjectID = [];
  List<SubSubject?>? subSubjects = [];
  List<SubSubject?>? fatherSubSubjects = [];
  resetValues() {
    ///we need to invoke
    questionWithAnswer = [];

    subjectID.clear();
    numberOfQuestion.value = 0;
    questionToSolveNumber = 0;
    baseId.clear();
    subIds.clear();
  }

  resetCounters() {
    _lessonController.numberOfRemainingQA.value = tempNumberOfRemaining;
  }

  expand(bool value, SubSubject s) {
    s.expanded = value;
    update();
  }

  expandSubject(bool value, Subject s) {
    s.expand = value;
    update();
  }

  Future<List<SubSubject?>?> getAllFathersSubject() async {
    subSubjects = await getSubSubjects();
    fatherSubSubjects =
        subSubjects!.where((element) => element!.fatherId == null).toList();
    return fatherSubSubjects;
  }

  restoreRandomizeSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _lessonController.isShuffleAnswers.value =
        pref.getBool('isShuffle') ?? false;
    _lessonController.lesson.value = 'اختبار عشوائي';
    _lessonController.resetSectionDivider();
    _lessonController.isRandomize = true;
    _lessonController.resetQuestions();
    List? qID = await getAllRandomizeID();
    questionWithAnswer = await getRandomQ(qID!);
    tempNumberOfRemaining = 0;
    _lessonController.numberOfRemainingQA.value = 0;
    checkAnswerController.check = false;
    checkAnswerController.solvedCheck = false;
    checkAnswerController.restoreAlreadycheck = false;
    resetCounters();
    checkAnswerController.solvedAnswer.clear();
    checkAnswerController.doubleCheckedAnswer.clear();
    var session = await getRandomizeSessions();
    // var qInfo = await getAllRandomizeInfo();

    if (session == null) {
    } else {
      if (session.isNotEmpty) {
        // if (qInfo!.isNotEmpty) {
        //   final ReceivePort receivePort = ReceivePort();
        //   Completer<bool> _completer = Completer<bool>();
        //   final ReceivePort receivePort2 = ReceivePort();
        //   Completer<bool> _completer2 = Completer<bool>();
        //   List<QuestionAnswerModel?>? tempList = [];

        //   Isolate.spawn(randomizeIsolate,
        //       [receivePort.sendPort, qInfo, questionWithAnswer]);
        //   Isolate.spawn(randomizeIsolate2,
        //       [receivePort2.sendPort, qInfo, questionWithAnswer]);
        //   bool sub1Ended = false;
        //   bool sub2Ended = false;
        //   List<QuestionAnswerModel?>? temp1 = [];
        //   List<QuestionAnswerModel?>? temp2 = [];
        //   receivePort.listen((message) async {
        //     temp1 = message[0];

        //     /// The above code is a comment in Dart programming language. Comments are used to provide
        //     /// explanations or notes within the code that are ignored by the compiler or interpreter.

        //     // Handle the message received from the second isolate
        //     print('first isolate is done!');
        //     sub1Ended = true;
        //     _completer.isCompleted ? {} : _completer.complete(sub1Ended);
        //     print('end' + DateTime.now().minute.toString());
        //   }).onDone(() {});
        //   receivePort2.listen((message) async {

        //     temp2 = message[0];
        //     print('second isolate is done!');

        //     // Handle the message received from the second isolate

        //     sub2Ended = true;
        //     _completer2.isCompleted ? {} : _completer2.complete(sub2Ended);
        //     print('end' + DateTime.now().minute.toString());
        //   }).onDone(() {});
        //   bool result = await _completer.future;
        //   bool result2 = await _completer2.future;
        //   tempList = temp1! + temp2!;

        //   tempNumberOfRemaining = tempList.length;
        //   questionWithAnswer = tempList;
        // }
        int quesIndex = 0;
        // await clearRandomizeTable();

        await Future.forEach(session, (Map<String, dynamic>? element) async {
          for (int i = 0; i < questionWithAnswer!.length; i++) {
            if (questionWithAnswer![i]!.id == element!['q_id']) {
              questionWithAnswer![i]!.groupValue = int.parse(element['choice']);
              quesIndex = quesIndex++;
              // tempQuess.add(questionWithAnswer![i]!);
              // questionWithAnswer!.remove(questionWithAnswer![i]!);
              tempNumberOfRemaining -= 1;
              if (element[alreadyChecked] == 1) {
                checkAnswerController.solvedAnswer.add({
                  cspreviousIdCol: element[cspreviousIdCol],
                  'a_index': element[answer_index],
                  'subid': element[csSubId],
                  'choice': int.parse(element['choice']),
                  alreadyChecked: true,
                  "answerId": int.parse(element['choice']),
                  "correctness": element[correctnessColumn] == 1 ? true : false,
                  "answerContent": element[answerContent],
                  "questionId": element[question_id],
                  "index": element['q_index'],
                  "correctIndex": element['correctIndex']
                });
                checkAnswerController.doubleCheckedAnswer.add({
                  cspreviousIdCol: element[cspreviousIdCol],
                  'a_index': element[answer_index],
                  'subid': element[csSubId],
                  'choice': int.parse(element['choice']),
                  alreadyChecked: true,
                  "answerId": int.parse(element['choice']),
                  "correctness": element[correctnessColumn] == 1 ? true : false,
                  "answerContent": element[answerContent],
                  "questionId": element[question_id],
                  "index": element['q_index'],
                  "correctIndex": element['correctIndex']
                });
              } else {
                checkAnswerController.solvedAnswer.add({
                  cspreviousIdCol: element[cspreviousIdCol],
                  'a_index': element[answer_index],
                  'subid': element[csSubId],
                  'choice': int.parse(element['choice']),
                  alreadyChecked: false,
                  "answerId": int.parse(element['choice']),
                  "correctness": element[correctnessColumn] == 1 ? true : false,
                  "answerContent": element[answerContent],
                  "questionId": element[question_id],
                  "index": element['q_index'],
                  "correctIndex": element['correctIndex']
                });
              }
              break;
            }
          }
        });

        questionWithAnswer!.sort((a, b) {
          return (a!.groupValue!.compareTo(b!.groupValue!));
        });

        if (checkAnswerController.doubleCheckedAnswer.isNotEmpty) {
          checkAnswerController.restoreAlreadycheck = true;
        } else {
          checkAnswerController.restoreAlreadycheck = false;
        }
        // indexQuestionController.index = session.last!['q_index'] ?? 0;
        indexQuestionController.index = quesIndex;
        _lessonController.numberOfQA.value = questionWithAnswer!.length;
        _lessonController.numberOfRemainingQA.value =
            questionWithAnswer!.length + tempNumberOfRemaining;

        _lessonController.ans = questionWithAnswer;
        _lessonController.loading.value = false;
        _lessonController.update();
        if (await pref.getBool('ismath') ?? false) {
          Get.toNamed(MathQuestionScreen.routeName,
              arguments: {"subjectID": null, "subID": null});
        } else {
          Get.toNamed(Questionss.routeName,
              arguments: {"subjectID": null, "subID": null});
        }
      } else {}
    }
  }

  setQuestionList(bool isMath) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('ismath', isMath);
    _lessonController.isShuffleAnswers.value =
        pref.getBool('isShuffle') ?? false;
    _lessonController.lesson.value = 'اختبار عشوائي';

    tempNumberOfRemaining = 0;

    resetCounters();

    _lessonController.resetSectionDivider();
    _lessonController.isRandomize = true;
    _lessonController.resetQuestions();
    _lessonController.numberOfRemainingQA.value = 0;
    checkAnswerController.check = false;
    checkAnswerController.solvedCheck = false;
    checkAnswerController.restoreAlreadycheck = false;
    checkAnswerController.solvedAnswer.clear();
    checkAnswerController.doubleCheckedAnswer.clear();

    shuffle(questionWithAnswer!);
    if (questionToSolveNumber <= numberOfQuestion.value) {
      var temp =
          questionWithAnswer!.getRange(0, questionToSolveNumber).toList();
      int i = 0;
      await clearRandomizeTable();

      for (var ele in temp) {
        await insertRandomQuestionInfo(
            {randomQuestionId: ele!.id, randomQuestionIndex: i});
        i++;
      }
      tempNumberOfRemaining = temp.length;
      _lessonController.ans = temp;
      _lessonController.numberOfQA.value = temp.length;
      _lessonController.numberOfRemainingQA.value =
          temp.length - checkAnswerController.solvedAnswer.length;
      _lessonController.update();
    } else {
      _lessonController.ans!.clear();
    }
    if (isMath) {
      if (_lessonController.ans!.isNotEmpty) {
        progresscontroller.calculateProgressPrecentage(
            _lessonController.ans!.length, _lessonController.mathIndex.value);
      }
    }
    _lessonController.loading.value = false;
  }

  List<SubSubject?>? getSubsubOfSubject(int id) {
    List<SubSubject?>? tempSubject =
        subSubjects!.where((element) => element!.subjectId == id).toList();

    return tempSubject;
  }

  bool isLatex = false;
  addId(int id, bool baseOrsub, bool isSubject, String? name, bool latX) async {
    if (!numberOfQuestionLoading.value) {
      numberOfQuestionLoading.value = true;
      if (isSubject) {
        if (name == 'رياضيات') {
          isLatex = true;
        }
        subjectID.add(id);
        List<SubSubject?>? tempSub = await getSubSubjectsForSubject(id);

        if (tempSub!.isNotEmpty) {
          List<int> tempIds = [];
          for (int i = 0; i < tempSub.length; i++) {
            if (subIds.contains(tempSub[i]!.id!)) {
            } else if (baseId.contains(tempSub[i]!.id!) &&
                subIds.contains(tempSub[i]!.id!)) {
            } else if (baseId.contains(tempSub[i]!.id!)) {
            } else {
              if (tempSub[i]!.fatherId == null) {
                tempIds.add(tempSub[i]!.id!);
                baseId.add(tempSub[i]!.id!);
                subIds.add(tempSub[i]!.id!);
              } else {
                tempIds.add(tempSub[i]!.id!);
                subIds.add(tempSub[i]!.id!);
              }
            }
          }
          int numberTemp = 0;

          List<QuestionAnswerModel?>? tempList =
              await getQuestionWithAnswersForSubject(id);

          if (tempList != null) {
            for (var ele in tempList) {
              if (questionWithAnswer!.contains(ele)) {
              } else {
                numberTemp += 1;
                questionWithAnswer!.add(ele);
              }
            }
          }
          if (numberOfQuestion.value == -1001) {
            numberOfQuestion.value = 0;
          }

          numberOfQuestion.value = numberOfQuestion.value + numberTemp;
        }
      } else if (baseOrsub) {
        if (baseId.contains(id)) {
        } else {
          baseId.add(id);
        }
        if (latX) {
          isLatex = true;
        }
        List<int> tempIds = [];
        tempIds.add(id);
        for (var element in subSubjects!) {
          if (element!.fatherId == id) {
            if (!subIds.contains(element.id)) {
              subIds.add(element.id!);
              tempIds.add(element.id!);
            } else {}
          }
        }

        int numberTemp = 0;
        for (int ids in tempIds) {
          List<QuestionAnswerModel?>? tempList =
              await getQuestionWithAnswers(ids);

          if (tempList != null) {
            for (var ele in tempList) {
              if (questionWithAnswer!.contains(ele)) {
              } else {
                numberTemp += 1;
                questionWithAnswer!.add(ele);
              }
            }
          }
        }
        numberOfQuestion.value = numberOfQuestion.value + numberTemp;
        update();
      } else {
        subIds.add(id);
        if (latX) {
          isLatex = true;
        }
        List<QuestionAnswerModel?>? tempList = await getQuestionWithAnswers(id);
        if (tempList != null) {
          for (var ele in tempList) {
            if (questionWithAnswer!.contains(ele)) {
            } else {
              questionWithAnswer!.add(ele);
              numberOfQuestion.value = numberOfQuestion.value + 1;
            }
          }
          numberOfQuestion.value = questionWithAnswer!.length;
        }
      }
      numberOfQuestionLoading.value = false;
      update();
    }
  }

  removeId(
      int id, bool baseOrsub, bool isSubject, String? name, bool latX) async {
    if (!numberOfQuestionLoading.value) {
      numberOfQuestionLoading.value = true;
      numberOfQuestionLoading.value = true;
      if (isSubject) {
        if (name == 'رياضيات') {
          isLatex = false;
        }
        subjectID.remove(id);
        List<SubSubject?>? tempSub = await getSubSubjectsForSubject(id);
        if (tempSub!.isNotEmpty) {
          List<int> tempIds = [];
          for (int i = 0; i < tempSub.length; i++) {
            if (tempSub[i]!.fatherId == null) {
              tempIds.add(tempSub[i]!.id!);
              baseId.remove(tempSub[i]!.id!);
              subIds.remove(tempSub[i]!.id!);
            } else {
              tempIds.add(tempSub[i]!.id!);
              subIds.remove(tempSub[i]!.id!);
            }
          }
          int numberTemp = 0;

          List<QuestionAnswerModel?>? tempList =
              await getQuestionWithAnswersForSubject(id);
          if (tempList != null) {
            for (var ele in tempList) {
              if (questionWithAnswer!.contains(ele)) {
                numberTemp += 1;
                questionWithAnswer!.remove(ele);
              }
            }
          }

          numberOfQuestion.value = numberOfQuestion.value >= numberTemp
              ? numberOfQuestion.value - numberTemp
              : 0;
        }
      } else if (baseOrsub) {
        List<int> tempIds = [];
        tempIds.add(id);
        for (var element in subSubjects!) {
          if (element!.fatherId == id) {
            if (!subIds.contains(element.id!)) {
            } else {
              tempIds.add(element.id!);
              subIds.remove(element.id!);
            }
          }
        }
        int numberTemp = 0;

        for (int ids in tempIds) {
          if (questionWithAnswer!.isEmpty) {
          } else {
            List<QuestionAnswerModel?>? tempList =
                await getQuestionWithAnswers(ids);
            if (tempList != null) {
              for (var ele in tempList) {
                numberTemp += 1;
                questionWithAnswer!.remove(ele);
              }
            }
          }
        }

        baseId.remove(id);
        tempIds.remove(id);
        numberOfQuestion.value -= numberTemp;
      } else {
        if (latX && name == 'رياضيات') {
          isLatex = true;
        } else if (latX) {
          isLatex = false;
        }
        List<QuestionAnswerModel?>? tempList = await getQuestionWithAnswers(id);
        if (tempList != null) {
          for (var ele in tempList) {
            if (questionWithAnswer!.contains(ele)) {
              questionWithAnswer!.remove(ele);
              numberOfQuestion.value -= 1;
            }
          }
        }
        subIds.remove(id);
      }
      numberOfQuestionLoading.value = false;
      update();
    }
  }

  setSubjects() async {
    subjects = await getSubjects();
    List<Subject?>? tempSubject = [];

    if (subjects == null || subjects!.isEmpty) {
    } else {
      for (var element in subjects!) {
        int numOFDisabeledcodes = 0;

        List<ActiveCodesLocal>? a = await getActiveCodeForSubject(element!.id!);

        if (element.subject_code != null) {
          if (a != null) {
            for (var valid in a) {
              List<ActiveCodesLocal>? b = await isValidCode(valid.id!);

              if (b != null) {
              } else {
                numOFDisabeledcodes++;
              }
            }
          }
          if (numOFDisabeledcodes >= element.subject_code!) {
          } else {
            tempSubject.add(element);
          }
        }
        if (element.subject_coupon != null) {
          int numOFDisabeledcoupons = 0;
          List<ActiveCouponsLocal>? acCoupon =
              await getActiveCouponForSubject(element.id!);

          if (acCoupon != null) {
            for (var valid in acCoupon) {
              List<ActiveCouponsLocal>? bcoupoun =
                  await isValidCoupon(valid.id!);

              if (bcoupoun != null) {
              } else {
                numOFDisabeledcoupons++;
              }
            }
          }
          if (numOFDisabeledcoupons >= element.subject_coupon!) {
          } else {
            if (tempSubject.contains(element)) {
            } else {
              tempSubject.add(element);
            }
          }
        }
        if (element.subject_code == null && element.subject_coupon == null) {
          subjects = [];
        }
      }
      subjects = tempSubject;

      await getAllFathersSubject();
      update();
    }
  }

  @override
  void onInit() async {
    subjects = await getSubjects();

    await getAllFathersSubject();
    update();
    super.onInit();
  }
}
