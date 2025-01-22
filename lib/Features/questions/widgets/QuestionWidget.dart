import 'package:collection/collection.dart';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_langdetect/flutter_langdetect.dart' as langdetect;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:seen/core/controller/theme_controller.dart';
import 'package:seen/core/constants/Colors.dart';
import 'package:seen/core/constants/url.dart';
import 'package:seen/core/functions/checkSolvedAnser/checkSolvedAnswer.dart';

import 'package:seen/core/functions/localDataFunctions/userAnswerFunction.dart';
import 'package:seen/Features/questions/widgets/QuestionAddition.dart';

import '../../../core/controller/QuestionsController/ExamsLogController.dart';

import '../../../core/controller/text_controller.dart';
import '../../../core/constants/TextStyles.dart';
import '../../../core/functions/QuestionFunction.dart';

import '../../../shared/model/LocalDataSource.dart/LocalData.dart';
import '../../Sections/controller/indexQuestionController/indexQuestionsController.dart';

import '../Controller/CheckAnswerController/checkAnswerController.dart';
import '../Controller/LessonController.dart';
import '../Controller/showFullListController.dart';
import '../model/classes/QuestionAnswerModel.dart';
import 'AddNoteCard.dart';

class QuestionWidget extends StatelessWidget {
  QuestionWidget(
      {super.key,
      required this.preID,
      required this.answers,
      required this.index,
      required this.questionId,
      required this.selectGroup,
      required this.questionAnswerModel,
      required this.sub_id,
      required this.subject_id,
      required this.languages
      // required this.questionNumber
      });
  int? preID;
  QuestionAnswerModel questionAnswerModel;
  CheckAnswerController checkAnswerController = Get.find();
  LessonController _lessonController = Get.find();
  IndexQuestionController indexQuestionController = Get.find();
  TextController textController = Get.find();
  ThemeController _themeController = Get.find();
  ShowListController showListController = Get.put(ShowListController());
  bool reloadingImage = false;
  List<Answer1> answers;
  int questionId;
  int selectGroup;
  int? length = 2;
  late int correctID;
  List letters = ['A', 'B', 'C', 'D', 'E'];
  List<dynamic?>? preNames = [];
  final int index;
  final int? sub_id;
  final int? subject_id;
  bool answer = false;
  int? selectedAnswer;
  int? correctAnswer;
  int? isSelected;
  bool show = false;
  int? isRadioChoose;
  String? languages;
  ExamsLogController examsLogController = Get.find();

  updateWrongValues() async {
    // indexQuestionController.update();
  }

  @override
  Widget build(BuildContext context) {
    if (_lessonController.isRandomize &&
        _lessonController.isShuffleAnswers.value) {
      shuffle(answers);
    }

    // selectGroup = checkAnswerController.selected.value;
    // print(answers);
    for (int i = 0; i < answers.length; i++) {
      if (answers[i].correctness!) {
        correctID = answers[i].id!;
      }
    }

    show = questionAnswerModel.show!;
    if (checkAnswerController.check) {
      if (checkSolvedAnswer(questionId) != null) {
        show = true;
        var tempq = checkSolvedAnswer(questionId);
        questionAnswerModel.right_times = tempq[rightTimes];
        questionAnswerModel.isWrong = tempq['is_wrong'];
        questionAnswerModel.nextDate = tempq[nextShowDate];
        if (checkSolvedAnswer(questionId)['correctness']) {
          print('############/ rt /###############');
          // updateWrongness(questionId, 0);
          // questionAnswerModel.right_times =
          //     checkSolvedAnswer(questionId)[rightTimes];
          // questionAnswerModel.nextDate =
          // checkSolvedAnswer(questionId)[nextShowDate];

          //updateWrongness(questionId, 0);
          //questionAnswerModel.right_times++;

          print('checkkka${questionAnswerModel.right_times}too');
          if (checkSolvedAnswer(questionId)['a_index'] == 111) {
            correctAnswer = 111;
          } else {
            correctAnswer = correctID;
          }
        } else {
          // updateWrongness(questionId, 1);
          questionAnswerModel.isWrong = true;
          if (checkSolvedAnswer(questionId)['a_index'] == 1000) {
            selectedAnswer = 1000;
          } else {
            selectedAnswer = checkSolvedAnswer(questionId)['choice'];

            correctAnswer = correctID;
          }
        }
      } else {
        show = true;
        if (!questionAnswerModel.isMcq!) {
          correctID = 111;
        } else {
          correctAnswer = correctID;
        }
      }
    }

    if (checkAnswerController.solvedCheck) {
      print("checkAnswerController.solvedCheck");

      if (checkSolvedAnswer(questionId) != null) {
        show = questionAnswerModel.isMcq! ? false : true;
        var tempq = checkSolvedAnswer(questionId);
        questionAnswerModel.right_times = tempq[rightTimes];
        questionAnswerModel.isWrong = tempq['is_wrong'];
        questionAnswerModel.nextDate = tempq[nextShowDate];
        if (checkSolvedAnswer(questionId)['correctness']) {
          // updateWrongness(questionId, 0);
          // questionAnswerModel.isWrong = false;
          if (checkSolvedAnswer(questionId)['a_index'] == 111) {
            correctAnswer = 111;
          } else {
            correctAnswer = correctID;
          }

          //  correctAnswer = checkSolvedAnswer(questionId)['a_index'];
        } else {
          // updateWrongness(questionId, 1);
          questionAnswerModel.isWrong = true;
          if (checkSolvedAnswer(questionId)['a_index'] == 1000) {
            selectedAnswer = 1000;
          } else {
            selectedAnswer = checkSolvedAnswer(questionId)['choice'];

            correctAnswer = checkSolvedAnswer(questionId)['correctIndex'];
          }
          //    selectedAnswer = checkSolvedAnswer(questionId)['a_index'];
          //  correctAnswer = checkSolvedAnswer(questionId)['correctIndex'];
        }
      }
    }
    if (checkAnswerController.restoreAlreadycheck) {
      print('checkAnswerController.restoreAlreadycheck');
      if (restorAlreadyCheckedAnswer(questionId) != null) {
        show = questionAnswerModel.isMcq! ? false : true;
        // var tempq = checkSolvedAnswer(questionId);
        // questionAnswerModel.right_times = tempq[rightTimes];
        // questionAnswerModel.isWrong = tempq['is_wrong'];
        // questionAnswerModel.nextDate = tempq[nextShowDate];
        if (restorAlreadyCheckedAnswer(questionId)['correctness']) {
          if (checkSolvedAnswer(questionId)['a_index'] == 111) {
            correctAnswer = 111;
          } else {
            //    isSelected = restorAlreadyCheckedAnswer(questionId)['correctIndex'];
            correctAnswer = correctID;
            isSelected = correctID;
          }
        } else {
          if (checkSolvedAnswer(questionId)['a_index'] == 1000) {
            selectedAnswer = 1000;
          } else {
            isSelected = checkSolvedAnswer(questionId)['choice'];
            selectedAnswer = checkSolvedAnswer(questionId)['choice'];

            if (questionAnswerModel.isMcq!) {
              correctAnswer = correctID;
            }
          }
        }
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await updateWrongValues();
      indexQuestionController.update();
    });

    return Directionality(
      textDirection: _lessonController.isRandomize
          ? (langdetect.detect(
                          questionAnswerModel.questionContent!.split('')[0]) ==
                      'ar' ||
                  langdetect.detect(
                          questionAnswerModel.questionContent!.split('')[0]) ==
                      'ur' ||
                  langdetect.detect(
                          questionAnswerModel.questionContent!.split('')[0]) ==
                      'fa')
              ? TextDirection.rtl
              : TextDirection.ltr
          : languages == "عربي"
              ? TextDirection.rtl
              : TextDirection.ltr,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                    width: 235.w,
                    child: InkWell(
                      onLongPress: () {
                        show =
                            indexQuestionController.showHint_Note(true, show);
                        questionAnswerModel.show = show;
                      },
                      child: SizedBox(
                        width: 235.w,
                        child: Text(
                            "${index + 1} - ${questionAnswerModel.questionContent}",
                            style: ownStyle(Get.theme.primaryColor, 15.sp)!
                                .copyWith(fontWeight: FontWeight.w700)),
                      ),
                    )),
                SizedBox(
                  width: 13.w,
                ),
                Expanded(
                    flex: 1,
                    child: PopupMenuButton(
                      shadowColor: SeenColors.iconColor,
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r)),
                      surfaceTintColor: Theme.of(context).canvasColor,
                      icon: Icon(Icons.more_horiz,
                          size: 20.w, color: Theme.of(context).primaryColor),
                      itemBuilder: (context) => <PopupMenuEntry>[
                        PopupMenuItem(
                            onTap: () async {
                              textController.noteController.text =
                                  questionAnswerModel.note ?? '';
                              if (questionAnswerModel.note == null) {
                                Future.delayed(
                                  const Duration(seconds: 0),
                                  () {
                                    return showDialog(
                                      context: context,
                                      builder: (context) => AddNoteCard(
                                        controller:
                                            textController.noteController,
                                        msg: 'إضافة ملاحظة',
                                        send: () async {
                                          await updateNote(
                                              questionId,
                                              textController.noteController.text
                                                      .isEmpty
                                                  ? ''
                                                  : textController
                                                      .noteController.text);
                                          questionAnswerModel.note =
                                              textController.noteController.text
                                                      .isEmpty
                                                  ? null
                                                  : textController
                                                      .noteController.text;
                                          indexQuestionController.update();
                                          Get.back();
                                        },
                                      ),
                                    );
                                  },
                                );
                              } else {
                                textController.noteController.text =
                                    questionAnswerModel.note ?? '';
                                Future.delayed(
                                  const Duration(seconds: 0),
                                  () => showDialog(
                                    context: context,
                                    builder: (context) => AddNoteCard(
                                      controller: textController.noteController,
                                      msg: 'إضافة ملاحظة',
                                      send: () async {
                                        await updateNote(
                                            questionId,
                                            questionAnswerModel.note =
                                                textController.noteController
                                                        .text.isEmpty
                                                    ? ''
                                                    : textController
                                                        .noteController.text);
                                        questionAnswerModel.note =
                                            textController
                                                    .noteController.text.isEmpty
                                                ? null
                                                : textController
                                                    .noteController.text;
                                        indexQuestionController.update();
                                        Get.back();
                                      },
                                    ),
                                  ),
                                );
                              }

                              indexQuestionController.update();
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  questionAnswerModel.note == null
                                      ? 'إضافة ملاحظة'
                                      : 'تعديل الملاحظة',
                                  style: ownStyle(
                                      Theme.of(context).primaryColor, 16.sp),
                                ),
                                Divider(
                                  color: Theme.of(context).primaryColor,
                                  endIndent: 10.w,
                                  indent: 3.w,
                                )
                              ],
                            )),
                        PopupMenuItem(
                            onTap: () async {
                              await {
                                questionAnswerModel.isFavorites!
                                    ? await addRemoveFavorites(questionId, 0)
                                    : await addRemoveFavorites(questionId, 1)
                              };
                              questionAnswerModel.isFavorites =
                                  !questionAnswerModel.isFavorites!;
                              indexQuestionController.update();
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  questionAnswerModel.isFavorites!
                                      ? 'إزالة من المفضلة'
                                      : 'إضافة إلى المفضلة',
                                  style: ownStyle(
                                      Theme.of(context).primaryColor, 16.sp),
                                ),
                                Divider(
                                  color: Theme.of(context).primaryColor,
                                  endIndent: 10.w,
                                  indent: 3.w,
                                )
                              ],
                            )),
                      ],
                    )),
              ],
            ),
            (questionAnswerModel.url == null ||
                    questionAnswerModel.url!.isEmpty)
                ? const SizedBox()
                : Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r)),
                    child: StatefulBuilder(builder: (context, setstate) {
                      return reloadingImage
                          ? SizedBox()
                          : InkWell(
                              onDoubleTap: () async {
                                setstate(() {
                                  reloadingImage = true;
                                });
                                await FastCachedImageConfig.deleteCachedImage(
                                    imageUrl: baseUrlForImage! +
                                        questionAnswerModel.url!);
                                await Future.delayed(
                                    Duration(milliseconds: 500));

                                setstate(() {
                                  reloadingImage = false;
                                });
                              },
                              child: FastCachedImage(
                                  fadeInDuration: Duration.zero,
                                  fit: BoxFit.fitWidth,
                                  width: 400.w,
                                  url: baseUrlForImage! +
                                      questionAnswerModel.url!,
                                  loadingBuilder: (context, downloadProgress) =>
                                      Center(
                                        child: CircularProgressIndicator(
                                            value: downloadProgress
                                                .progressPercentage.value,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                  errorBuilder: (context, url, error) =>
                                      const Icon(
                                        Icons.refresh,
                                        color: Colors.red,
                                      )),
                            );
                    }),
                  ),
            for (int i = 0;
                i < (questionAnswerModel.isMcq! ? answers.length : 1);
                i++)
              Padding(
                padding: EdgeInsets.only(bottom: 0.5.h),
                child: questionAnswerModel.isMcq!
                    ? GetBuilder<CheckAnswerController>(
                        builder: (innerController) {
                        return GestureDetector(
                            onTap: () async {
                              var tempWronInfo =
                                  await getQuestionRightSolvedTimesAndNextTimes(
                                      questionId);
                              if (tempWronInfo == null) {
                                questionAnswerModel.right_times = 0;
                              } else {
                                questionAnswerModel.right_times =
                                    tempWronInfo['right_times'] ?? 0;
                                questionAnswerModel.nextDate =
                                    tempWronInfo[nextShowDate];
                              }
                              checkAnswerController.solvedAnswer.removeWhere(
                                  (element) =>
                                      element['questionId'] == questionId);
                              checkAnswerController.solvedAnswer.add({
                                cspreviousIdCol: preID,
                                'a_index': i,
                                'subid': sub_id,
                                'is_wrong': questionAnswerModel.isWrong,
                                nextShowDate: questionAnswerModel.nextDate,
                                rightTimes: questionAnswerModel.right_times,
                                alreadyChecked: false,
                                'choice': answers[i].id,
                                "answerId": answers[i].id,
                                "correctness": answers[i].correctness,
                                "answerContent": answers[i].answerContent,
                                "questionId": questionId,
                                "index": index,
                                "correctIndex": correctID,
                                csSubjectID: subject_id
                              });

                              questionAnswerModel.groupValue = answers[i].id!;
                              questionAnswerModel.checked = true;

                              await indexQuestionController.saveSession(
                                  subjectid: subject_id,
                                  isAllFav: _lessonController.isAllFave,
                                  isAllWrong: _lessonController.isAllWrong,
                                  isFav: _lessonController.isFave,
                                  isWrong: _lessonController.isWrong,
                                  isPrev: _lessonController.isPreiviosQuestios,
                                  prevId: preID,
                                  alreadyChecke: false,
                                  subid: sub_id,
                                  qid: questionId,
                                  choice: answers[i].id!.toString(),
                                  index: index,
                                  a_content: answers[i].answerContent!,
                                  a_index: i,
                                  correctness: answers[i].correctness!,
                                  correct_index: correctID,
                                  isRandom: _lessonController.isRandomize);
                              _lessonController.numberOfRemainingQA.value =
                                  _lessonController.numberOfQA.value -
                                      innerController.solvedAnswer.length;
                              checkAnswerController.update();
                            },
                            onLongPress: () async {
                              int valueBeforeUpdateWrongness =
                                  questionAnswerModel.right_times ?? 0;
                              valueBeforeUpdateWrongness++;
                              print(questionId);
                              checkAnswerController.restoreAlreadycheck = true;
                              await HapticFeedback.selectionClick();

                              checkAnswerController.solvedAnswer.removeWhere(
                                  (element) =>
                                      element['questionId'] == questionId);

                              checkAnswerController.doubleCheckedAnswer
                                  .removeWhere((element) =>
                                      element['questionId'] == questionId);
                              if ((questionAnswerModel.groupValue! ==
                                  (questionId + 50001))) {
                                if (answers[i].correctness!) {
                                  isSelected = correctID;
                                  correctAnswer = correctID;
                                  _lessonController.numberOfCorrectQA++;
                                  questionAnswerModel.groupValue =
                                      answers[i].id!;

                                  questionAnswerModel.isWrong = false;
                                  updateWrongness(questionId, 0);

                                  checkAnswerController.update();
                                } else {
                                  questionAnswerModel.isWrong = true;
                                  updateWrongness(questionId, 1);
                                  correctAnswer = correctID;
                                  isSelected = answers[i].id;
                                  selectedAnswer = answers[i].id;
                                  _lessonController.numberOfWrongQA++;
                                  questionAnswerModel.groupValue =
                                      answers[i].id!;

                                  checkAnswerController.update();
                                }
                                insertUserAnswer(
                                    answers[i].id!, answers[i].correctness!);
                              } else {
                                if ((correctAnswer == null &&
                                    selectedAnswer == null)) {
                                  if (answers[i].correctness!) {
                                    correctAnswer = correctID;
                                    isSelected = answers[i].id;

                                    questionAnswerModel.groupValue =
                                        answers[i].id!;
                                    selectedAnswer = null;
                                    _lessonController.numberOfCorrectQA++;
                                    insertUserAnswer(answers[i].id!,
                                        answers[i].correctness!);
                                    questionAnswerModel.isWrong!
                                        ? {
                                            questionAnswerModel.isWrong = false,
                                          }
                                        : null;
                                    updateWrongness(questionId, 0);
                                    checkAnswerController.update();
                                  } else {
                                    correctAnswer = correctID;
                                    questionAnswerModel.isWrong!
                                        ? null
                                        : {
                                            questionAnswerModel.isWrong = true,
                                          };
                                    updateWrongness(questionId, 1);
                                    isSelected = answers[i].id;
                                    selectedAnswer = answers[i].id;
                                    _lessonController.numberOfWrongQA++;
                                    insertUserAnswer(answers[i].id!,
                                        answers[i].correctness!);
                                    questionAnswerModel.groupValue =
                                        answers[i].id!;
                                    checkAnswerController.update();
                                  }
                                } else if (answers[i].correctness!) {
                                  if (isSelected == answers[i].id) {
                                  } else {
                                    if (_lessonController.numberOfWrongQA > 0) {
                                      _lessonController.numberOfWrongQA--;
                                    }
                                    correctAnswer = correctID;
                                    isSelected = answers[i].id;

                                    // correctAnswer = answers[i].id;
                                    questionAnswerModel.groupValue =
                                        answers[i].id!;
                                    selectedAnswer = null;
                                    _lessonController.numberOfCorrectQA++;
                                    insertUserAnswer(answers[i].id!,
                                        answers[i].correctness!);

                                    questionAnswerModel.isWrong = false;
                                    updateWrongness(questionId, 0);
                                  }

                                  checkAnswerController.update();
                                } else {
                                  if (isSelected == answers[i].id) {
                                  } else {
                                    questionAnswerModel.groupValue =
                                        answers[i].id!;
                                    if (isSelected == correctID) {
                                      _lessonController.numberOfWrongQA++;
                                      if (_lessonController.numberOfCorrectQA >
                                          0) {
                                        _lessonController.numberOfCorrectQA--;
                                      }
                                    }
                                    correctAnswer = correctID;
                                    questionAnswerModel.isWrong!
                                        ? null
                                        : {
                                            questionAnswerModel.isWrong = true,
                                          };
                                    updateWrongness(questionId, 1);
                                    isSelected = answers[i].id;
                                    selectedAnswer = answers[i].id;
                                    insertUserAnswer(answers[i].id!,
                                        answers[i].correctness!);
                                  }
                                  checkAnswerController.update();
                                }
                              }
                              checkAnswerController.solvedAnswer.add({
                                cspreviousIdCol: preID,
                                'subid': sub_id,
                                'is_wrong': questionAnswerModel.isWrong,
                                'a_index': i,
                                nextShowDate: questionAnswerModel.nextDate,
                                rightTimes: questionAnswerModel.right_times,
                                alreadyChecked: true,
                                'choice': answers[i].id,
                                "answerId": answers[i].id,
                                "correctness": answers[i].correctness,
                                "answerContent": answers[i].answerContent,
                                "questionId": questionId,
                                "index": index,
                                "correctIndex": correctID,
                                csSubjectID: subject_id
                              });
                              checkAnswerController.doubleCheckedAnswer.add({
                                cspreviousIdCol: preID,
                                'subid': sub_id,
                                'a_index': i,
                                'is_wrong': questionAnswerModel.isWrong,
                                nextShowDate: questionAnswerModel.nextDate,
                                rightTimes: questionAnswerModel.right_times,
                                alreadyChecked: true,
                                'choice': answers[i].id,
                                "answerId": answers[i].id,
                                "correctness": answers[i].correctness,
                                "answerContent": answers[i].answerContent,
                                "questionId": questionId,
                                "index": index,
                                "correctIndex": correctID,
                                csSubjectID: subject_id
                              });
                              // checkAnswerController.update();
                              await indexQuestionController.saveSession(
                                  subjectid: subject_id,
                                  isAllFav: _lessonController.isAllFave,
                                  isAllWrong: _lessonController.isAllWrong,
                                  isFav: _lessonController.isFave,
                                  isWrong: _lessonController.isWrong,
                                  isPrev: _lessonController.isPreiviosQuestios,
                                  prevId: preID,
                                  alreadyChecke: true,
                                  subid: sub_id,
                                  qid: questionId,
                                  choice: answers[i].id!.toString(),
                                  index: index,
                                  a_content: answers[i].answerContent!,
                                  a_index: i,
                                  correctness: answers[i].correctness!,
                                  correct_index: correctID,
                                  isRandom: _lessonController.isRandomize);
                              var tempWronInfo =
                                  await getQuestionRightSolvedTimesAndNextTimes(
                                      questionId);
                              if (tempWronInfo == null) {
                                questionAnswerModel.right_times = 0;
                                questionAnswerModel.isWrong = false;
                              } else {
                                questionAnswerModel.right_times =
                                    tempWronInfo['right_times'] ?? 0;
                                questionAnswerModel.nextDate =
                                    tempWronInfo[nextShowDate];
                              }
                              print('############00');
                              print(tempWronInfo);

                              if (valueBeforeUpdateWrongness == 5) {
                                print('######vcat######00');
                                questionAnswerModel.isWrong = false;
                              } else {
                                questionAnswerModel.isWrong = true;
                              }

                              _lessonController.numberOfRemainingQA.value =
                                  _lessonController.numberOfQA.value -
                                      innerController.solvedAnswer.length;
                              //  checkAnswerController.update();

                              checkAnswerController.restoreAlreadycheck = true;
                              indexQuestionController.update();
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 0.h),
                              padding: EdgeInsets.only(right: 8.w, left: 3.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.r),
                                color: correctAnswer == answers[i].id
                                    ? SeenColors.rightAnswer
                                    : selectedAnswer == answers[i].id
                                        ? SeenColors.wrongAnswer
                                        : questionAnswerModel.groupValue ==
                                                answers[i].id!
                                            ? Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.4)
                                            : Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 4.h),
                                            child: Text(
                                              "${letters[i]} -  ",
                                              textAlign: TextAlign.center,
                                              style: ownStyle(
                                                      correctAnswer ==
                                                              answers[i].id
                                                          ? const Color
                                                              .fromARGB(255, 67,
                                                              126, 65)
                                                          : selectedAnswer ==
                                                                  answers[i].id
                                                              ? const Color
                                                                  .fromARGB(255,
                                                                  173, 56, 5120)
                                                              : questionAnswerModel
                                                                          .groupValue ==
                                                                      answers[i]
                                                                          .id!
                                                                  ? Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                          0.8)
                                                                  : _themeController
                                                                          .isDarkMode
                                                                          .value
                                                                      ? SeenColors
                                                                          .iconColor
                                                                      : SeenColors
                                                                          .answerText,
                                                      12.sp)!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                          ),
                                          SizedBox(
                                            width: (answers[i].url == null ||
                                                    answers[i].url!.isEmpty)
                                                ? 230.w
                                                : 150.w,
                                            child: RichText(
                                                maxLines: 500,
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                    locale: Get.locale,
                                                    style: ownStyle(
                                                            correctAnswer ==
                                                                    answers[i]
                                                                        .id
                                                                ? const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    67,
                                                                    126,
                                                                    65)
                                                                : selectedAnswer ==
                                                                        answers[i]
                                                                            .id
                                                                    ? const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        173,
                                                                        56,
                                                                        5120)
                                                                    : questionAnswerModel.groupValue ==
                                                                            answers[
                                                                                    i]
                                                                                .id!
                                                                        ? Theme.of(context)
                                                                            .primaryColor
                                                                            .withOpacity(
                                                                                0.8)
                                                                        : _themeController
                                                                                .isDarkMode.value
                                                                            ? SeenColors
                                                                                .iconColor
                                                                            : SeenColors
                                                                                .answerText,
                                                            15.sp)!
                                                        .copyWith(
                                                            height: 1.6,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            "${answers[i].answerContent!}",
                                                      ),
                                                    ])),
                                          ),
                                        ]),
                                  ),
                                  (answers[i].url == null ||
                                          answers[i].url!.isEmpty)
                                      ? const SizedBox()
                                      : Container(
                                          margin: EdgeInsets.all(2.w),
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15.r)),
                                          child: StatefulBuilder(
                                              builder: (context, states) {
                                            return answers[i].imgReload
                                                ? SizedBox()
                                                : InkWell(
                                                    onDoubleTap: () async {
                                                      states(() {
                                                        answers[i].imgReload =
                                                            true;
                                                      });
                                                      await FastCachedImageConfig
                                                          .deleteCachedImage(
                                                              imageUrl:
                                                                  baseUrlForImage! +
                                                                      answers[i]
                                                                          .url!);
                                                      await Future.delayed(
                                                          Duration(
                                                              milliseconds:
                                                                  500));

                                                      states(() {
                                                        answers[i].imgReload =
                                                            false;
                                                      });
                                                    },
                                                    child: FastCachedImage(
                                                        fadeInDuration:
                                                            Duration.zero,
                                                        fit: BoxFit.fill,
                                                        width: 75.w,
                                                        height: 45.h,
                                                        url: baseUrlForImage! +
                                                            answers[i].url!,
                                                        loadingBuilder: (context,
                                                                downloadProgress) =>
                                                            Center(
                                                              child: CircularProgressIndicator(
                                                                  value: downloadProgress
                                                                      .progressPercentage
                                                                      .value,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            ),
                                                        errorBuilder: (context,
                                                                url, error) =>
                                                            const Icon(
                                                              Icons.error,
                                                              color: Colors.red,
                                                            )),
                                                  );
                                          }),
                                        ),
                                  Radio(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: VisualDensity.comfortable,
                                      splashRadius: 10.r,
                                      activeColor:
                                          correctAnswer == answers[i].id
                                              ? const Color.fromARGB(
                                                  255, 45, 92, 43)
                                              : selectedAnswer == answers[i].id
                                                  ? const Color.fromARGB(
                                                      255, 161, 52, 47)
                                                  : Get.theme.primaryColor,
                                      value: answers[i].id,
                                      groupValue:
                                          questionAnswerModel.groupValue,
                                      onChanged: (val) async {
                                        questionAnswerModel.groupValue = val!;

                                        checkAnswerController.solvedAnswer
                                            .removeWhere((element) =>
                                                element['questionId'] ==
                                                questionId);
                                        checkAnswerController.solvedAnswer.add({
                                          cspreviousIdCol: preID,
                                          'a_index': i,
                                          'is_wrong':
                                              questionAnswerModel.isWrong,
                                          'subid': sub_id,
                                          nextShowDate:
                                              questionAnswerModel.nextDate,
                                          rightTimes:
                                              questionAnswerModel.right_times,
                                          alreadyChecked: false,
                                          'choice': answers[i].id,
                                          "answerId": answers[i].id,
                                          "correctness": answers[i].correctness,
                                          "answerContent":
                                              answers[i].answerContent,
                                          "questionId": questionId,
                                          "index": index,
                                          "correctIndex": correctID,
                                          csSubjectID: subject_id
                                        });

                                        questionAnswerModel.checked = true;

                                        await indexQuestionController
                                            .saveSession(
                                                subjectid: subject_id,
                                                isAllFav:
                                                    _lessonController.isAllFave,
                                                isAllWrong: _lessonController
                                                    .isAllWrong,
                                                isFav: _lessonController.isFave,
                                                isWrong:
                                                    _lessonController.isWrong,
                                                isPrev: _lessonController
                                                    .isPreiviosQuestios,
                                                prevId: preID,
                                                alreadyChecke: false,
                                                subid: sub_id,
                                                qid: questionId,
                                                choice:
                                                    answers[i].id!.toString(),
                                                index: index,
                                                a_content:
                                                    answers[i].answerContent!,
                                                a_index: i,
                                                correctness:
                                                    answers[i].correctness!,
                                                correct_index: correctID,
                                                isRandom: _lessonController
                                                    .isRandomize);
                                        _lessonController.numberOfRemainingQA
                                            .value = _lessonController
                                                .numberOfQA.value -
                                            innerController.solvedAnswer.length;
                                        checkAnswerController.update();
                                      })
                                ],
                              ),
                            ));
                      })
                    : const SizedBox(),
              ),
            GetBuilder<IndexQuestionController>(builder: (controller) {
              return show
                  ? Column(
                      children: [
                        (questionAnswerModel.questionNote == null ||
                                questionAnswerModel.answer![0].answerContent ==
                                    null)
                            ? const SizedBox()
                            : QuestionAddition(
                                image: 'hint.svg',
                                leading: '',
                                isMcq: questionAnswerModel.isMcq!,
                                url: _lessonController
                                    .ans![_lessonController.mathIndex.value]!
                                    .hurl,
                                questionAddition: questionAnswerModel.isMcq!
                                    ? questionAnswerModel.questionNote
                                    : questionAnswerModel
                                        .answer![0].answerContent),
                        questionAnswerModel.note == null
                            ? const SizedBox()
                            : QuestionAddition(
                                image: 'Note.svg',
                                leading: '',
                                isMcq: false,
                                questionAddition: questionAnswerModel.note),
                      ],
                    )
                  : const SizedBox();
            }),
            GetBuilder<IndexQuestionController>(
              builder: (controller) => questionAnswerModel.isMcq!
                  ? const SizedBox()
                  : show
                      ? GetBuilder<CheckAnswerController>(builder: (mc) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.0.w),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                        onLongPress: () async {
                                          int valueBeforeUpdateWrongness =
                                              questionAnswerModel.right_times ??
                                                  0;
                                          valueBeforeUpdateWrongness++;
                                          await HapticFeedback.selectionClick();

                                          if (correctAnswer == null &&
                                              selectedAnswer == null) {
                                            selectedAnswer = null;
                                            correctAnswer = 111;
                                            _lessonController
                                                .numberOfCorrectQA++;
                                            checkAnswerController.solvedAnswer
                                                .add({
                                              cspreviousIdCol: preID,
                                              'is_wrong':
                                                  questionAnswerModel.isWrong,
                                              'subid': sub_id,
                                              nextShowDate:
                                                  questionAnswerModel.nextDate,
                                              rightTimes: questionAnswerModel
                                                  .right_times,
                                              'a_index': correctAnswer,
                                              alreadyChecked: true,
                                              'choice': answers[0].id,
                                              "answerId": 000,
                                              "correctness": true,
                                              "answerContent":
                                                  answers[0].answerContent,
                                              "questionId": questionId,
                                              "index": index,
                                              "correctIndex": 1,
                                              csSubjectID: subject_id
                                            });
                                            checkAnswerController
                                                .doubleCheckedAnswer
                                                .add({
                                              'is_wrong':
                                                  questionAnswerModel.isWrong,
                                              nextShowDate:
                                                  questionAnswerModel.nextDate,
                                              rightTimes: questionAnswerModel
                                                  .right_times,
                                              cspreviousIdCol: preID,
                                              'subid': sub_id,
                                              'a_index': 111,
                                              alreadyChecked: true,
                                              'choice': answers[0].id,
                                              "answerId": 000,
                                              "correctness": true,
                                              "answerContent":
                                                  answers[0].answerContent,
                                              "questionId": questionId,
                                              "index": index,
                                              "correctIndex": 1,
                                              csSubjectID: subject_id
                                            });

                                            await updateWrongness(
                                                questionId, 0);
                                            await insertUserAnswer(
                                                answers[0].id!, true);

                                            mc.update();
                                          }
                                          if (selectedAnswer == 1000) {
                                            checkAnswerController.solvedAnswer
                                                .removeWhere((element) =>
                                                    element['questionId'] ==
                                                    questionId);
                                            checkAnswerController.solvedAnswer
                                                .add({
                                              nextShowDate:
                                                  questionAnswerModel.nextDate,
                                              rightTimes: questionAnswerModel
                                                  .right_times,
                                              'is_wrong':
                                                  questionAnswerModel.isWrong,
                                              cspreviousIdCol: preID,
                                              'subid': sub_id,
                                              'a_index': 111,
                                              alreadyChecked: true,
                                              'choice': answers[0].id,
                                              "answerId": 000,
                                              "correctness": true,
                                              "answerContent":
                                                  answers[0].answerContent,
                                              "questionId": questionId,
                                              "index": index,
                                              "correctIndex": 1,
                                              csSubjectID: subject_id
                                            });
                                            checkAnswerController
                                                .doubleCheckedAnswer
                                                .add({
                                              cspreviousIdCol: preID,
                                              'subid': sub_id,
                                              'a_index': 111,
                                              alreadyChecked: true,
                                              'choice': answers[0].id,
                                              "answerId": 000,
                                              "correctness": true,
                                              "answerContent":
                                                  answers[0].answerContent,
                                              "questionId": questionId,
                                              "index": index,
                                              "correctIndex": 1,
                                              csSubjectID: subject_id
                                            });
                                            selectedAnswer = null;
                                            correctAnswer = 111;
                                            _lessonController
                                                .numberOfCorrectQA++;
                                            _lessonController.numberOfWrongQA--;
                                            insertUserAnswer(
                                                answers[0].id!, true);

                                            // updateWrongness(questionId, 0);
                                            mc.update();
                                          }
                                          indexQuestionController.saveSession(
                                              subjectid: subject_id,
                                              isAllFav:
                                                  _lessonController.isAllFave,
                                              isAllWrong:
                                                  _lessonController.isAllWrong,
                                              isFav: _lessonController.isFave,
                                              isWrong:
                                                  _lessonController.isWrong,
                                              isPrev: _lessonController
                                                  .isPreiviosQuestios,
                                              prevId: preID,
                                              alreadyChecke: true,
                                              subid: sub_id,
                                              qid: questionId,
                                              choice: answers[0].id!.toString(),
                                              index: index,
                                              a_content:
                                                  answers[0].answerContent!,
                                              a_index: 111,
                                              correctness:
                                                  answers[0].correctness!,
                                              correct_index: 1,
                                              isRandom: _lessonController
                                                  .isRandomize);
                                          _lessonController.numberOfRemainingQA
                                              .value = _lessonController
                                                  .numberOfQA.value -
                                              checkAnswerController
                                                  .solvedAnswer.length;
                                          checkAnswerController
                                              .restoreAlreadycheck = true;
                                          checkAnswerController.check = false;
                                          checkAnswerController.solvedCheck =
                                              false;
                                          var tempWronInfo =
                                              await getQuestionRightSolvedTimesAndNextTimes(
                                                  questionId);
                                          if (tempWronInfo == null) {
                                            questionAnswerModel.right_times = 0;
                                          } else {
                                            questionAnswerModel.right_times =
                                                tempWronInfo['right_times'] ??
                                                    0;
                                            questionAnswerModel.nextDate =
                                                tempWronInfo[nextShowDate];
                                          }

                                          print(tempWronInfo);
                                          print(
                                              "questionAnswerModel.right_times");
                                          if (valueBeforeUpdateWrongness == 5) {
                                            questionAnswerModel.isWrong = false;
                                          } else {
                                            questionAnswerModel.isWrong = true;
                                          }
                                          indexQuestionController.update();
                                        },
                                        child: FaIcon(
                                            Icons.check_circle_outline_rounded,
                                            color: correctAnswer == 111
                                                ? Colors.green
                                                : Theme.of(context)
                                                    .primaryColor,
                                            size: 60.w)),
                                    SizedBox(
                                      width: 50.w,
                                    ),
                                    InkWell(
                                        onLongPress: () async {
                                          int valueBeforeUpdateWrongness =
                                              questionAnswerModel.right_times ??
                                                  0;
                                          valueBeforeUpdateWrongness++;
                                          checkAnswerController
                                              .restoreAlreadycheck = true;
                                          HapticFeedback.selectionClick();

                                          if (selectedAnswer == null &&
                                              correctAnswer == null) {
                                            checkAnswerController
                                                .doubleCheckedAnswer
                                                .add({
                                              cspreviousIdCol: preID,
                                              'subid': sub_id,
                                              'a_index': 1000,
                                              'is_wrong':
                                                  questionAnswerModel.isWrong,
                                              nextShowDate:
                                                  questionAnswerModel.nextDate,
                                              rightTimes: questionAnswerModel
                                                  .right_times,
                                              alreadyChecked: true,
                                              'choice': answers[0].id,
                                              "answerId": 000,
                                              "correctness": false,
                                              "answerContent":
                                                  answers[0].answerContent,
                                              "questionId": questionId,
                                              "index": index,
                                              "correctIndex": 0,
                                              csSubjectID: subject_id
                                            });
                                            checkAnswerController.solvedAnswer
                                                .add({
                                              cspreviousIdCol: preID,
                                              'subid': sub_id,
                                              'is_wrong':
                                                  questionAnswerModel.isWrong,
                                              nextShowDate:
                                                  questionAnswerModel.nextDate,
                                              rightTimes: questionAnswerModel
                                                  .right_times,
                                              'a_index': 1000,
                                              alreadyChecked: true,
                                              'choice': answers[0].id,
                                              "answerId": 000,
                                              "correctness": false,
                                              "answerContent":
                                                  answers[0].answerContent,
                                              "questionId": questionId,
                                              "index": index,
                                              "correctIndex": 0,
                                              csSubjectID: subject_id
                                            });
                                            selectedAnswer = 1000;
                                            correctAnswer = null;
                                            _lessonController.numberOfWrongQA++;
                                            await updateWrongness(
                                                questionId, 1);
                                            await insertUserAnswer(
                                                answers[0].id!, false);
                                            questionAnswerModel.isWrong = true;
                                            // updateWrongness(questionId, 1);
                                            mc.update();
                                          }
                                          if (correctAnswer == 111) {
                                            checkAnswerController.solvedAnswer
                                                .removeWhere((element) =>
                                                    element['questionId'] ==
                                                    questionId);
                                            checkAnswerController
                                                .doubleCheckedAnswer
                                                .add({
                                              cspreviousIdCol: preID,
                                              'subid': sub_id,
                                              'a_index': 1000,
                                              'is_wrong':
                                                  questionAnswerModel.isWrong,
                                              nextShowDate:
                                                  questionAnswerModel.nextDate,
                                              rightTimes: questionAnswerModel
                                                  .right_times,
                                              alreadyChecked: true,
                                              'choice': answers[0].id,
                                              "answerId": 000,
                                              "correctness": false,
                                              "answerContent":
                                                  answers[0].answerContent,
                                              "questionId": questionId,
                                              "index": index,
                                              "correctIndex": 0,
                                              csSubjectID: subject_id
                                            });
                                            checkAnswerController.solvedAnswer
                                                .add({
                                              cspreviousIdCol: preID,
                                              'is_wrong':
                                                  questionAnswerModel.isWrong,
                                              'a_index': 1000,
                                              nextShowDate:
                                                  questionAnswerModel.nextDate,
                                              rightTimes: questionAnswerModel
                                                  .right_times,
                                              'subid': sub_id,
                                              'choice': answers[0].id,
                                              "answerId": answers[0].id,
                                              "correctness": false,
                                              "answerContent": '',
                                              "questionId": questionId,
                                              "index": 0,
                                              "correctIndex": 0,
                                              csSubjectID: subject_id
                                            });
                                            selectedAnswer = 1000;
                                            correctAnswer = null;
                                            _lessonController.numberOfWrongQA++;
                                            _lessonController
                                                .numberOfCorrectQA--;
                                            insertUserAnswer(
                                                answers[0].id!, false);
                                            // questionAnswerModel.isWrong = true;
                                            // updateWrongness(questionId, 1);

                                            mc.update();
                                          }

                                          indexQuestionController.saveSession(
                                              subjectid: subject_id,
                                              isAllFav:
                                                  _lessonController.isAllFave,
                                              isAllWrong:
                                                  _lessonController.isAllWrong,
                                              isFav: _lessonController.isFave,
                                              isWrong:
                                                  _lessonController.isWrong,
                                              isPrev: _lessonController
                                                  .isPreiviosQuestios,
                                              prevId: preID,
                                              alreadyChecke: true,
                                              subid: sub_id,
                                              qid: questionId,
                                              choice: answers[0].id!.toString(),
                                              index: index,
                                              a_content:
                                                  answers[0].answerContent!,
                                              a_index: 1000,
                                              correctness: false,
                                              correct_index: 1,
                                              isRandom: _lessonController
                                                  .isRandomize);
                                          _lessonController.numberOfRemainingQA
                                              .value = _lessonController
                                                  .numberOfQA.value -
                                              checkAnswerController
                                                  .solvedAnswer.length;
                                          checkAnswerController
                                              .restoreAlreadycheck = true;
                                          var tempWronInfo =
                                              await getQuestionRightSolvedTimesAndNextTimes(
                                                  questionId);
                                          if (tempWronInfo == null) {
                                            questionAnswerModel.right_times = 0;
                                          } else {
                                            questionAnswerModel.right_times =
                                                tempWronInfo['right_times'] ??
                                                    0;
                                            questionAnswerModel.nextDate =
                                                tempWronInfo[nextShowDate];
                                          }

                                          print(tempWronInfo);
                                          print(
                                              "questionAnswerModel.right_times");
                                          if (valueBeforeUpdateWrongness == 5) {
                                            questionAnswerModel.isWrong = false;
                                          } else {
                                            questionAnswerModel.isWrong = true;
                                          }
                                          indexQuestionController.update();
                                        },
                                        child: SvgPicture.asset(
                                          'assets/Qustions/wrongAnswer.svg',
                                          width: 52.w,
                                          colorFilter: ColorFilter.mode(
                                              selectedAnswer == 1000
                                                  ? Colors.red
                                                  : Theme.of(context)
                                                      .primaryColor,
                                              BlendMode.srcIn),
                                        ))
                                  ]),
                            ),
                          );
                        })
                      : const SizedBox(),
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 4.h, left: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 10.w),
                        questionAnswerModel.questionNote != null
                            ? SvgPicture.asset('assets/Qustions/hint.svg',
                                height: 10.h,
                                colorFilter: ColorFilter.mode(
                                    Theme.of(context).primaryColor,
                                    BlendMode.srcIn))
                            : const SizedBox(),
                        SizedBox(width: 5.w),
                        GetBuilder<IndexQuestionController>(builder: (_) {
                          return questionAnswerModel.note != null
                              ? SvgPicture.asset('assets/Qustions/Note.svg',
                                  height: 10.h,
                                  colorFilter: ColorFilter.mode(
                                      Theme.of(context).primaryColor,
                                      BlendMode.srcIn))
                              : const SizedBox();
                        }),
                        SizedBox(width: 5.w),
                        GetBuilder<IndexQuestionController>(builder: (_) {
                          return questionAnswerModel.isWrong!
                              ? Row(
                                  children: [
                                    SvgPicture.asset('assets/Qustions/X.svg',
                                        height: 10.h,
                                        colorFilter: ColorFilter.mode(
                                            Theme.of(context).primaryColor,
                                            BlendMode.srcIn)),
                                    questionAnswerModel.right_times == null
                                        ? SizedBox()
                                        : Text(
                                            (5 -
                                                    (questionAnswerModel
                                                            .right_times ??
                                                        0))
                                                .toString(),
                                            style: ownStyle(
                                                    SeenColors.mainColor,
                                                    15.sp)!
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    height: 0.5),
                                            textAlign: TextAlign.start,
                                          ),
                                  ],
                                )
                              : const SizedBox();
                        }),
                        SizedBox(width: 5.w),
                        GetBuilder<IndexQuestionController>(builder: (_) {
                          return questionAnswerModel.isFavorites!
                              ? SvgPicture.asset('assets/Qustions/fav.svg',
                                  height: 10.h,
                                  colorFilter: ColorFilter.mode(
                                      Theme.of(context).primaryColor,
                                      BlendMode.srcIn))
                              : const SizedBox();
                        })
                      ],
                    ),
                    GetBuilder<IndexQuestionController>(builder: (_) {
                      return (questionAnswerModel.isWrong ?? false)
                          ? questionAnswerModel.nextDate == null
                              ? SizedBox()
                              : Text(
                                  '${DateTime.parse(questionAnswerModel.nextDate!).difference(DateTime.now()).inDays}D',
                                  style: ownStyle(SeenColors.mainColor, 15.sp)!
                                      .copyWith(
                                          fontWeight: FontWeight.w700,
                                          height: 0.5),
                                  textAlign: TextAlign.start,
                                )
                          : SizedBox();
                    })
                  ],
                )),
            SizedBox(
              height: 3.h,
            ),
            Row(
              children: [
                FutureBuilder(
                    future: getAllexamsForQuestion(questionId),
                    builder: (context, snap) {
                      if (snap.hasData) {
                        preNames = snap.data;
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          examsLogController.update();
                        });

                        return GetBuilder<ShowListController>(builder: (_) {
                          return SizedBox(
                            // height: (0 < length! && length! < 2) ? 35.h : null,
                            width: 250.w,
                            child: Wrap(
                                spacing: 8.w,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                // itemCount:,

                                children: [
                                  for (int index = 0;
                                      index <
                                          // (snap.data!.length <= 2
                                          snap.data!.length;
                                      // : length!);
                                      index++)
                                    Container(
                                      constraints: BoxConstraints(
                                          maxWidth: snap.data![index]
                                                      .toString()
                                                      .length >
                                                  13
                                              ? 200.w
                                              : 100.w,
                                          minWidth: 50.w),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 4.h),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(15.r)),
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3.w, horizontal: 5.w),
                                      child: Text(
                                        snap.data![index] == null
                                            ? ''
                                            : snap.data![index].toString(),
                                        style: ownStyle(Colors.white, 12.sp),
                                      ),
                                    ),
                                ]),
                          );
                        });
                      } else {
                        return SizedBox();
                      }
                    }),
                // GetBuilder<ExamsLogController>(builder: (_) {
                //   return (preNames!.isEmpty ||
                //           !(preNames!.length >= 2 && preNames![0].length >= 10))
                //       ? SizedBox()
                //       : InkWell(
                //           onTap: () {
                //             if (length == preNames!.length) {
                //               if (preNames!.length >= 2) {
                //                 if (preNames![0].length >= 10) {
                //                   length = 1;
                //                 } else {
                //                   length = 2;
                //                 }
                //               }
                //             } else {
                //               length = preNames!.length;
                //             }
                //             ;
                //             showListController.update();
                //           },
                //           child: Container(
                //               decoration: BoxDecoration(
                //                   color: Theme.of(context).primaryColor,
                //                   borderRadius: BorderRadius.circular(15.r)),
                //               alignment: Alignment.center,
                //               padding: EdgeInsets.symmetric(
                //                   vertical: 0.w, horizontal: 8.w),
                //               margin: EdgeInsets.symmetric(horizontal: 8.w),
                //               child: Icon(
                //                 Icons.more_horiz,
                //                 color: Colors.white,
                //               )),
                //         );
                // })
              ],
            ),
            SizedBox(
              height: 3.h,
            ),
            Divider(
              height: 2,
              thickness: 1.2,
              color: Get.theme.primaryColor,
            ),
            SizedBox(
              height: 3.h,
            ),
          ],
        ),
      ),
    );
  }
}
