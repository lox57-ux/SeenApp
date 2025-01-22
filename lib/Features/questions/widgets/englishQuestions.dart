import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:seen/core/constants/Colors.dart';
import 'package:seen/core/functions/checkSolvedAnser/checkSolvedAnswer.dart';

import 'package:seen/Features/questions/widgets/QuestionAddition.dart';

import '../../../core/controller/text_controller.dart';
import '../../../core/controller/theme_controller.dart';
import '../../../core/constants/TextStyles.dart';
import '../../../core/functions/QuestionFunction.dart';
import '../../../core/functions/localDataFunctions/userAnswerFunction.dart';

import '../../../shared/model/LocalDataSource.dart/LocalData.dart';
import '../../Sections/controller/indexQuestionController/indexQuestionsController.dart';

import '../Controller/CheckAnswerController/checkAnswerController.dart';
import '../Controller/LessonController.dart';
import '../model/classes/QuestionAnswerModel.dart';
import 'AddNoteCard.dart';

class EnglishQuestion extends StatelessWidget {
  EnglishQuestion(
      {super.key,
      required this.answers,
      required this.index,
      required this.questionId,
      required this.selectGroup,
      required this.questionAnswerModel,
      required this.sub_id,
      required this.subject_id
      // required this.questionNumber
      });
  QuestionAnswerModel questionAnswerModel;
  CheckAnswerController checkAnswerController = Get.find();
  LessonController _lessonController = Get.find();
  IndexQuestionController indexQuestionController = Get.find();
  TextController textController = Get.find();
  ThemeController _themeController = Get.find();

  List<Answer1> answers;
  int questionId;
  int selectGroup;
  late int correctIndex;
  List letters = ['A', 'B', 'C', 'D', 'E'];
  final int index;
  final int? sub_id;
  final int? subject_id;
  bool answer = false;
  int? selectedAnswer;
  int? correctAnswer;
  int? isSelected;
  bool show = false;
  int? isRadioChoose;

  @override
  Widget build(BuildContext context) {
    // selectGroup = checkAnswerController.selected.value;
    for (int i = 0; i < answers.length; i++) {
      if (answers[i].correctness!) {
        correctIndex = i;
      }
    }

    if (checkAnswerController.check) {
      if (checkSolvedAnswer(questionId) != null) {
        show = questionAnswerModel.isMcq! ? false : true;
        if (checkSolvedAnswer(questionId)['correctness']) {
          updateWrongness(questionId, 0);
          correctAnswer = checkSolvedAnswer(questionId)['correctIndex'];
        } else {
          updateWrongness(questionId, 1);
          selectedAnswer = checkSolvedAnswer(questionId)['a_index'];
          correctAnswer = checkSolvedAnswer(questionId)['correctIndex'];
        }
      } else {
        show = true;
        if (!questionAnswerModel.isMcq!) {
          correctIndex = 1;
        }

        correctAnswer = correctIndex;
      }
    }

    if (checkAnswerController.solvedCheck) {
      if (checkSolvedAnswer(questionId) != null) {
        show = questionAnswerModel.isMcq! ? false : true;
        if (checkSolvedAnswer(questionId)['correctness']) {
          updateWrongness(questionId, 0);
          correctAnswer = checkSolvedAnswer(questionId)['a_index'];
        } else {
          updateWrongness(questionId, 1);
          selectedAnswer = checkSolvedAnswer(questionId)['a_index'];
          correctAnswer = checkSolvedAnswer(questionId)['correctIndex'];
        }
      }
    }
    if (checkAnswerController.restoreAlreadycheck) {
      if (restorAlreadyCheckedAnswer(questionId) != null) {
        show = questionAnswerModel.isMcq! ? false : true;

        if (restorAlreadyCheckedAnswer(questionId)['correctness']) {
          isSelected = restorAlreadyCheckedAnswer(questionId)['correctIndex'];
          correctAnswer =
              restorAlreadyCheckedAnswer(questionId)['correctIndex'];
          isSelected = correctIndex;
        } else {
          isSelected = restorAlreadyCheckedAnswer(questionId)['a_index'];
          selectedAnswer = restorAlreadyCheckedAnswer(questionId)['a_index'];
          if (questionAnswerModel.isMcq!) {
            correctAnswer =
                restorAlreadyCheckedAnswer(questionId)['correctIndex'];
          }
        }
      }
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SizedBox(
                    width: 250.w,
                    child: InkWell(
                      onLongPress: () {
                        show =
                            indexQuestionController.showHint_Note(true, show);
                      },
                      child: SizedBox(
                        width: 200.w,
                        child: Text(
                            "${index + 1}- ${questionAnswerModel.questionContent} ",
                            style: ownStyle(Get.theme.primaryColor, 16.sp)!
                                .copyWith(fontWeight: FontWeight.w700)),
                      ),
                    )),
                SizedBox(
                  width: 10.w,
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
                                        msg: 'أضف ملاحظاتك',
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
                                      msg: 'أضف ملاحظاتك',
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
                                      ? 'اضافة ملاحظة'
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
                                      ? 'ازالة من المفضلة'
                                      : 'اضافة الى المفضلة',
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
            for (int i = 0;
                i < (questionAnswerModel.isMcq! ? answers.length : 1);
                i++)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: questionAnswerModel.isMcq!
                    ? GetBuilder<CheckAnswerController>(
                        builder: (innerController) {
                        return GestureDetector(
                            onTap: () async {
                              checkAnswerController.solvedAnswer.removeWhere(
                                  (element) =>
                                      element['questionId'] == questionId);
                              checkAnswerController.solvedAnswer.add({
                                cspreviousIdCol: questionAnswerModel.previousId,
                                'a_index': i,
                                'subid': sub_id,
                                alreadyChecked: false,
                                'choice': answers[i].id,
                                "answerId": answers[i].id,
                                "correctness": answers[i].correctness,
                                "answerContent": answers[i].answerContent,
                                "questionId": questionId,
                                "index": index,
                                "correctIndex": correctIndex,
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
                                  prevId: questionAnswerModel.previousId,
                                  alreadyChecke: false,
                                  subid: sub_id,
                                  qid: questionId,
                                  choice: answers[i].id!.toString(),
                                  index: index,
                                  a_content: answers[i].answerContent!,
                                  a_index: i,
                                  correctness: answers[i].correctness!,
                                  correct_index: correctIndex,
                                  isRandom: _lessonController.isRandomize);
                              _lessonController.numberOfRemainingQA.value =
                                  _lessonController.numberOfQA.value -
                                      innerController.solvedAnswer.length;
                              checkAnswerController.update();
                            },
                            onLongPress: () async {
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
                                  isSelected = i;
                                  correctAnswer = i;
                                  _lessonController.numberOfCorrectQA++;
                                  questionAnswerModel.groupValue =
                                      answers[i].id!;

                                  questionAnswerModel.isWrong = false;
                                  updateWrongness(questionId, 0);

                                  checkAnswerController.update();
                                } else {
                                  questionAnswerModel.isWrong = true;
                                  updateWrongness(questionId, 1);
                                  correctAnswer = correctIndex;
                                  isSelected = i;
                                  selectedAnswer = i;
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
                                    correctAnswer = correctIndex;
                                    isSelected = i;

                                    correctAnswer = i;
                                    questionAnswerModel.groupValue =
                                        answers[i].id!;
                                    selectedAnswer = null;
                                    _lessonController.numberOfCorrectQA++;
                                    insertUserAnswer(answers[i].id!,
                                        answers[i].correctness!);
                                    questionAnswerModel.isWrong!
                                        ? {
                                            questionAnswerModel.isWrong = false,
                                            updateWrongness(questionId, 0)
                                          }
                                        : null;

                                    checkAnswerController.update();
                                  } else {
                                    correctAnswer = correctIndex;
                                    questionAnswerModel.isWrong!
                                        ? null
                                        : {
                                            questionAnswerModel.isWrong = true,
                                            updateWrongness(questionId, 1)
                                          };
                                    isSelected = i;
                                    selectedAnswer = i;
                                    _lessonController.numberOfWrongQA++;
                                    insertUserAnswer(answers[i].id!,
                                        answers[i].correctness!);
                                    questionAnswerModel.groupValue =
                                        answers[i].id!;
                                    checkAnswerController.update();
                                  }
                                } else if (answers[i].correctness!) {
                                  if (isSelected == i) {
                                  } else {
                                    if (_lessonController.numberOfWrongQA > 0) {
                                      _lessonController.numberOfWrongQA--;
                                    }
                                    correctAnswer = correctIndex;
                                    isSelected = i;

                                    correctAnswer = i;
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
                                  if (isSelected == i) {
                                  } else {
                                    questionAnswerModel.groupValue =
                                        answers[i].id!;
                                    if (isSelected == correctIndex) {
                                      _lessonController.numberOfWrongQA++;
                                      if (_lessonController.numberOfCorrectQA >
                                          0) {
                                        _lessonController.numberOfCorrectQA--;
                                      }
                                    }
                                    correctAnswer = correctIndex;
                                    questionAnswerModel.isWrong!
                                        ? null
                                        : {
                                            questionAnswerModel.isWrong = true,
                                            updateWrongness(questionId, 1)
                                          };
                                    isSelected = i;
                                    selectedAnswer = i;
                                    insertUserAnswer(answers[i].id!,
                                        answers[i].correctness!);
                                  }
                                  checkAnswerController.update();
                                }
                              }
                              checkAnswerController.solvedAnswer.add({
                                cspreviousIdCol: questionAnswerModel.previousId,
                                'subid': sub_id,
                                'a_index': i,
                                alreadyChecked: true,
                                'choice': answers[i].id,
                                "answerId": answers[i].id,
                                "correctness": answers[i].correctness,
                                "answerContent": answers[i].answerContent,
                                "questionId": questionId,
                                "index": index,
                                "correctIndex": correctIndex,
                                csSubjectID: subject_id
                              });
                              checkAnswerController.doubleCheckedAnswer.add({
                                cspreviousIdCol: questionAnswerModel.previousId,
                                'subid': sub_id,
                                'a_index': i,
                                alreadyChecked: true,
                                'choice': answers[i].id,
                                "answerId": answers[i].id,
                                "correctness": answers[i].correctness,
                                "answerContent": answers[i].answerContent,
                                "questionId": questionId,
                                "index": index,
                                "correctIndex": correctIndex,
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
                                  prevId: questionAnswerModel.previousId,
                                  alreadyChecke: true,
                                  subid: sub_id,
                                  qid: questionId,
                                  choice: answers[i].id!.toString(),
                                  index: index,
                                  a_content: answers[i].answerContent!,
                                  a_index: i,
                                  correctness: answers[i].correctness!,
                                  correct_index: correctIndex,
                                  isRandom: _lessonController.isRandomize);

                              _lessonController.numberOfRemainingQA.value =
                                  _lessonController.numberOfQA.value -
                                      innerController.solvedAnswer.length;
                              //  checkAnswerController.update();

                              indexQuestionController.update();
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 7.h),
                              padding: EdgeInsets.symmetric(horizontal: 3.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.r),
                                color: correctAnswer == i
                                    ? SeenColors.rightAnswer
                                    : selectedAnswer == i
                                        ? SeenColors.wrongAnswer
                                        : Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${letters[i]}-",
                                            textAlign: TextAlign.start,
                                            style: ownStyle(
                                                    correctAnswer == i
                                                        ? const Color.fromARGB(
                                                            255, 67, 126, 65)
                                                        : selectedAnswer == i
                                                            ? const Color
                                                                .fromARGB(255,
                                                                173, 56, 5120)
                                                            : _themeController
                                                                    .isDarkMode
                                                                    .value
                                                                ? SeenColors
                                                                    .iconColor
                                                                : SeenColors
                                                                    .answerText,
                                                    16.sp)!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                          SizedBox(
                                            width: 200.w,
                                            child: RichText(
                                                maxLines: 500,
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                    locale: Get.locale,
                                                    style: ownStyle(
                                                            correctAnswer == i
                                                                ? const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    67,
                                                                    126,
                                                                    65)
                                                                : selectedAnswer ==
                                                                        i
                                                                    ? const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        173,
                                                                        56,
                                                                        5120)
                                                                    : _themeController
                                                                            .isDarkMode
                                                                            .value
                                                                        ? SeenColors
                                                                            .iconColor
                                                                        : SeenColors
                                                                            .answerText,
                                                            16.sp)!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                    children: [
                                                      TextSpan(
                                                        text: answers[i]
                                                            .answerContent!,
                                                      ),
                                                    ])),
                                          ),
                                        ]),
                                  ),
                                  Radio(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: const VisualDensity(
                                        horizontal:
                                            VisualDensity.minimumDensity,
                                        vertical: VisualDensity.minimumDensity,
                                      ),
                                      splashRadius: 10.r,
                                      activeColor: correctAnswer == i
                                          ? const Color.fromARGB(
                                              255, 45, 92, 43)
                                          : selectedAnswer == i
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
                                          cspreviousIdCol:
                                              questionAnswerModel.previousId,
                                          'a_index': i,
                                          'subid': sub_id,
                                          alreadyChecked: false,
                                          'choice': answers[i].id,
                                          "answerId": answers[i].id,
                                          "correctness": answers[i].correctness,
                                          "answerContent":
                                              answers[i].answerContent,
                                          "questionId": questionId,
                                          "index": index,
                                          "correctIndex": correctIndex,
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
                                                prevId: questionAnswerModel
                                                    .previousId,
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
                                                correct_index: correctIndex,
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
                                questionAddition: questionAnswerModel.isMcq!
                                    ? questionAnswerModel.questionNote
                                    : questionAnswerModel
                                        .answer![0].answerContent),
                        questionAnswerModel.note == null
                            ? const SizedBox()
                            : QuestionAddition(
                                image: 'Note.svg',
                                leading: '',
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
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                      onLongPress: () {
                                        HapticFeedback.selectionClick();

                                        if (correctAnswer == null &&
                                            selectedAnswer == null) {
                                          selectedAnswer = null;
                                          correctAnswer = 1;
                                          _lessonController.numberOfCorrectQA++;
                                          checkAnswerController.solvedAnswer
                                              .add({
                                            cspreviousIdCol:
                                                questionAnswerModel.previousId,
                                            'subid': sub_id,
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
                                          insertUserAnswer(
                                              answers[0].id!, true);
                                          mc.update();
                                        }
                                        if (selectedAnswer == 0) {
                                          checkAnswerController.solvedAnswer
                                              .removeWhere((element) =>
                                                  element['questionId'] ==
                                                  questionId);
                                          checkAnswerController.solvedAnswer
                                              .add({
                                            cspreviousIdCol:
                                                questionAnswerModel.previousId,
                                            'subid': sub_id,
                                            'a_index': 1,
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
                                          correctAnswer = 1;
                                          _lessonController.numberOfCorrectQA++;
                                          _lessonController.numberOfWrongQA--;
                                          insertUserAnswer(
                                              answers[0].id!, true);
                                          questionAnswerModel.isWrong = false;
                                          updateWrongness(questionId, 0);
                                          mc.update();
                                        }
                                        indexQuestionController.saveSession(
                                            subjectid: subject_id,
                                            isAllFav:
                                                _lessonController.isAllFave,
                                            isAllWrong:
                                                _lessonController.isAllWrong,
                                            isFav: _lessonController.isFave,
                                            isWrong: _lessonController.isWrong,
                                            isPrev: _lessonController
                                                .isPreiviosQuestios,
                                            prevId:
                                                questionAnswerModel.previousId,
                                            alreadyChecke: true,
                                            subid: sub_id,
                                            qid: questionId,
                                            choice: answers[0].id!.toString(),
                                            index: index,
                                            a_content:
                                                answers[0].answerContent!,
                                            a_index: 1,
                                            correctness:
                                                answers[0].correctness!,
                                            correct_index: 1,
                                            isRandom:
                                                _lessonController.isRandomize);
                                        _lessonController
                                                .numberOfRemainingQA.value =
                                            _lessonController.numberOfQA.value -
                                                checkAnswerController
                                                    .solvedAnswer.length;
                                        indexQuestionController.update();
                                      },
                                      child: FaIcon(
                                          Icons.check_circle_outline_rounded,
                                          color: correctAnswer == 1
                                              ? Colors.green
                                              : Theme.of(context).primaryColor,
                                          size: 60.w)),
                                  SizedBox(
                                    width: 50.w,
                                  ),
                                  InkWell(
                                      onLongPress: () {
                                        HapticFeedback.selectionClick();
                                        questionAnswerModel.isWrong!
                                            ? null
                                            : {
                                                questionAnswerModel.isWrong =
                                                    true,
                                                updateWrongness(questionId, 1)
                                              };
                                        if (selectedAnswer == null &&
                                            correctAnswer == null) {
                                          checkAnswerController.solvedAnswer
                                              .add({
                                            cspreviousIdCol:
                                                questionAnswerModel.previousId,
                                            'subid': sub_id,
                                            'a_index': 0,
                                            alreadyChecked: true,
                                            'choice': answers[0].id,
                                            "answerId": 000,
                                            "correctness": true,
                                            "answerContent":
                                                answers[0].answerContent,
                                            "questionId": questionId,
                                            "index": index,
                                            "correctIndex": 0,
                                            csSubjectID: subject_id
                                          });
                                          selectedAnswer = 0;
                                          correctAnswer = null;
                                          _lessonController.numberOfWrongQA++;
                                          insertUserAnswer(
                                              answers[0].id!, false);
                                          questionAnswerModel.isWrong = true;
                                          updateWrongness(questionId, 1);
                                          mc.update();
                                        }
                                        if (correctAnswer == 1) {
                                          checkAnswerController.solvedAnswer
                                              .removeWhere((element) =>
                                                  element['questionId'] ==
                                                  questionId);
                                          checkAnswerController.solvedAnswer
                                              .add({
                                            cspreviousIdCol:
                                                questionAnswerModel.previousId,
                                            'a_index': 0,
                                            'subid': sub_id,
                                            "answerId": answers[0].id,
                                            "correctness": false,
                                            "answerContent": '',
                                            "questionId": questionId,
                                            "index": 0,
                                            "correctIndex": 0,
                                            csSubjectID: subject_id
                                          });
                                          selectedAnswer = 0;
                                          correctAnswer = null;
                                          _lessonController.numberOfWrongQA++;
                                          _lessonController.numberOfCorrectQA--;
                                          insertUserAnswer(
                                              answers[0].id!, false);
                                          questionAnswerModel.isWrong = true;
                                          updateWrongness(questionId, 1);
                                          mc.update();
                                        }

                                        indexQuestionController.saveSession(
                                            subjectid: subject_id,
                                            isAllFav:
                                                _lessonController.isAllFave,
                                            isAllWrong:
                                                _lessonController.isAllWrong,
                                            isFav: _lessonController.isFave,
                                            isWrong: _lessonController.isWrong,
                                            isPrev: _lessonController
                                                .isPreiviosQuestios,
                                            prevId:
                                                questionAnswerModel.previousId,
                                            alreadyChecke: true,
                                            subid: sub_id,
                                            qid: questionId,
                                            choice: answers[0].id!.toString(),
                                            index: index,
                                            a_content:
                                                answers[0].answerContent!,
                                            a_index: 0,
                                            correctness: false,
                                            correct_index: 1,
                                            isRandom:
                                                _lessonController.isRandomize);
                                        _lessonController
                                                .numberOfRemainingQA.value =
                                            _lessonController.numberOfQA.value -
                                                checkAnswerController
                                                    .solvedAnswer.length;
                                        indexQuestionController.update();
                                      },
                                      child: SvgPicture.asset(
                                          'assets/Qustions/wrongAnswer.svg',
                                          width: 52.w,
                                          colorFilter: ColorFilter.mode(
                                              selectedAnswer == 0
                                                  ? Colors.red
                                                  : Theme.of(context)
                                                      .primaryColor,
                                              BlendMode.srcIn)))
                                ]),
                          );
                        })
                      : const SizedBox(),
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Row(
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
                          ? SvgPicture.asset('assets/Qustions/X.svg',
                              height: 10.h,
                              colorFilter: ColorFilter.mode(
                                  Theme.of(context).primaryColor,
                                  BlendMode.srcIn))
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
                )),
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
