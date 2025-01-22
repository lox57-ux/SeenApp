import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:latext/latext.dart';
import 'package:seen/Features/Randomize/controllers/RandomizeController.dart';

import '../../../core/controller/QuestionsController/ExamsLogController.dart';

import '../../../shared/model/LocalDataSource.dart/LocalData.dart';
import '../../Sections/controller/indexQuestionController/indexQuestionsController.dart';
import '../../Sections/controller/subjectController/SubjectController.dart';
import '../../../core/controller/text_controller.dart';
import '../../../core/controller/theme_controller.dart';
import '../../../core/constants/Colors.dart';
import '../../../core/constants/TextStyles.dart';
import '../../../core/constants/url.dart';
import '../../../core/functions/QuestionFunction.dart';
import '../../../core/functions/checkSolvedAnser/checkSolvedAnswer.dart';
import '../../../core/functions/localDataFunctions/CurrentSession.dart';
import '../../../core/functions/localDataFunctions/userAnswerFunction.dart';

import '../../introPages/Widgets/IntroPageButton.dart';
import '../../../core/settings/widget/SkeletonList.dart';
import '../../../shared/CustomizedButton.dart';

import '../Controller/CheckAnswerController/checkAnswerController.dart';
import '../Controller/LessonController.dart';
import '../Controller/SearchController.dart';
import '../Controller/showFullListController.dart';
import '../model/classes/restoreResults.dart';
import '../widgets/AddNoteCard.dart';
import '../widgets/QuestionAddition.dart';
import '../widgets/QuestionToolBar.dart';

class MathQuestionScreen extends StatelessWidget {
  MathQuestionScreen({super.key});
  static const String routeName = '/MathQuestions';

  CheckAnswerController checkAnswerController = Get.find();
  LessonController _lessonController = Get.find();
  IndexQuestionController indexQuestionController = Get.find();
  TextController textController = Get.find();
  ThemeController _themeController = Get.find();
  QuesSearchController quesSearchController = Get.put(QuesSearchController());
  // Progresscontroller progresscontroller = Get.find();
  ShowListController showListController = Get.put(ShowListController());
  var arg = Get.arguments;
  ExamsLogController examsLogController = Get.put(ExamsLogController());
  // int selectGroup;
  bool reloadingImage = false;
  int? length = 2;
  int? correctID;
  int? tempQID;
  List letters = ['A', 'B', 'C', 'D', 'E'];
  List<dynamic?>? preNames = [];

  bool answer = false;
  int? selectedAnswer;
  int? correctAnswer;
  int? isSelected;

  int? isRadioChoose;
  RandomizeController randomizeController = Get.find();
  SubjectController subjectController = Get.find();
  resetValue() {
    selectedAnswer = null;
    correctID = null;
    isRadioChoose = null;
    isSelected = null;
    correctAnswer = null;
  }

  @override
  Widget build(BuildContext context) {
    if (!_lessonController.loading.value) {
      if (_lessonController.ans != null && _lessonController.ans!.isNotEmpty) {
        for (int i = 0;
            i <
                _lessonController
                    .ans![_lessonController.mathIndex.value]!.answer!.length;
            i++) {
          if (_lessonController.ans![_lessonController.mathIndex.value]!
              .answer![i].correctness!) {
            correctID = _lessonController
                .ans![_lessonController.mathIndex.value]!.answer![i].id!;
          }
        }
        _lessonController.setUpCounters();
      }
    }

    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leading: IconButton(
            onPressed: () async {
              checkAnswerController.check = false;
              checkAnswerController.solvedCheck = false;
              checkAnswerController.restoreAlreadycheck = false;
              _lessonController.mathIndex.value = 0;
              _lessonController.showHint = false;
              if (_lessonController.isRandomize) {
                if (await checkRandomizeSessionsIfEmpty() != null &&
                    (await checkRandomizeSessionsIfEmpty()) == 1) {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                          backgroundColor: Get.theme.cardColor,
                          surfaceTintColor: Get.theme.cardColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r)),
                          content: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.0.w, vertical: 10.0.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'هل تريد متابعة حل هذا الاختبار  لاحقاً؟',
                                  textAlign: TextAlign.center,
                                  style: ownStyle(
                                      Theme.of(context).primaryColor, 18.sp),
                                ),
                                SizedBox(
                                  height: 25.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                        child: IntroPageButton(
                                      fun: () async {
                                        await deleteRandomSession();
                                        Get.back();
                                        Get.back();
                                      },
                                      txt: 'لا',
                                      color: SeenColors.iconColor,
                                    )),
                                    IntroPageButton(
                                      fun: () async {
                                        Get.back();
                                        Get.back();
                                        Get.back();
                                      },
                                      txt: 'نعم',
                                      color: Theme.of(context).primaryColor,
                                    )
                                  ],
                                )
                              ],
                            ),
                          )));
                } else {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    Get.back();
                  });
                }
              } else {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  Navigator.of(context).maybePop();
                });
              }
            },
            icon: Icon(
              Icons.arrow_back_outlined,
              color: Theme.of(context).primaryColor,
              size: 25.sp,
            ),
          ),
          titleSpacing: 0,
          title: InkWell(
            highlightColor: Colors.transparent,
            onDoubleTap: () {
              _lessonController.mathIndex.value = 0;
              _lessonController.update();
            },
            splashColor: Colors.transparent,
            child: Text(
              _lessonController.lesson.value,
              style: introMsg()!.copyWith(
                  color: Theme.of(context).primaryColor, fontSize: 20.sp),
            ),
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            _lessonController.showHint = false;
            checkAnswerController.check = false;
            checkAnswerController.solvedCheck = false;
            checkAnswerController.restoreAlreadycheck = false;
            _lessonController.mathIndex.value = 0;
            if (_lessonController.isRandomize) {
              if (await checkRandomizeSessionsIfEmpty() != null &&
                  (await checkRandomizeSessionsIfEmpty()) == 1) {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                        backgroundColor: Get.theme.cardColor,
                        surfaceTintColor: Get.theme.cardColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r)),
                        content: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0.w, vertical: 10.0.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'هل تريد متابعة حل هذا الاختبار لاحقاً؟',
                                textAlign: TextAlign.center,
                                style: ownStyle(
                                    Theme.of(context).primaryColor, 18.sp),
                              ),
                              SizedBox(
                                height: 25.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                      child: IntroPageButton(
                                    fun: () async {
                                      await deleteRandomSession();
                                      Get.back();
                                      Get.back();
                                    },
                                    txt: 'لا',
                                    color: SeenColors.iconColor,
                                  )),
                                  IntroPageButton(
                                    fun: () async {
                                      Get.back();
                                      Get.back();
                                      Get.back();
                                    },
                                    txt: 'نعم',
                                    color: Theme.of(context).primaryColor,
                                  )
                                ],
                              )
                            ],
                          ),
                        )));
              } else {
                Get.back();
              }
            } else {
              Get.back();
            }
            return false;
          },
          child: GetBuilder<LessonController>(builder: (_) {
            ScrollController scrollController = ScrollController();
            return Obx(() {
              // if (quesSearchController.active) {
              //   tempQID = _lessonController.mathIndex.value;
              //   _lessonController.mathIndex.value = 0;
              // } else {
              //   if (tempQID != null) {
              //     _lessonController.mathIndex.value = tempQID!;
              //     tempQID = null;
              //   }
              // }
              if (_lessonController.ans != null &&
                  _lessonController.ans!.isNotEmpty) {
                if (_lessonController.showHint) {
                  if (_lessonController
                      .ans![_lessonController.mathIndex.value]!.show!) {
                  } else {
                    _lessonController
                        .ans![_lessonController.mathIndex.value]!.show = true;
                  }
                } else {
                  if (!_lessonController
                      .ans![_lessonController.mathIndex.value]!.show!) {
                  } else {
                    _lessonController
                        .ans![_lessonController.mathIndex.value]!.show = false;
                  }
                }
              }
              if (!_lessonController.loading.value) {
                if (_lessonController.ans != null &&
                    _lessonController.ans!.isNotEmpty) {
                  for (int i = 0;
                      i <
                          _lessonController
                              .ans![_lessonController.mathIndex.value]!
                              .answer!
                              .length;
                      i++) {
                    if (_lessonController
                        .ans![_lessonController.mathIndex.value]!
                        .answer![i]
                        .correctness!) {
                      correctID = _lessonController
                          .ans![_lessonController.mathIndex.value]!
                          .answer![i]
                          .id!;
                    }
                  }
                  if (_lessonController.resetGroup) {
                    if (_lessonController.ans != null) {
                      for (var x in _lessonController.ans!) {
                        x!.groupValue = x.id! + 50001;
                      }
                      resetValue();
                      _lessonController.resetGroup = false;
                    }
                  }
                }
              }
              // print(
              //     '@@@@@@@@@@@@${_lessonController.loading.value}${_lessonController.mathIndex.value}@@@@@@@@@@@@@@@@@@');
              return !_lessonController.loading.value
                  ? quesSearchController.active
                      ? SizedBox(
                          child: SingleChildScrollView(
                            physics: NeverScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                _lessonController.ans != null
                                    ? QuestionToolBar(
                                        isMath: true,
                                        lessonController: _lessonController,
                                        subID: arg['subID'] ?? 0)
                                    : SizedBox(),
                                SizedBox(
                                    height: media(context).height * 0.8,
                                    child: MathQuesyionList(
                                      lessonController: _lessonController,
                                      isSearchList: true,
                                      searchController: quesSearchController,
                                    )),
                              ],
                            ),
                          ),
                        )
                      : Column(children: [
                          _lessonController.ans != null
                              ? QuestionToolBar(
                                  isMath: true,
                                  lessonController: _lessonController,
                                  subID: arg['subID'] ?? 0)
                              : SizedBox(),

                          // : GetBuilder<Progresscontroller>(builder: (_) {
                          //     return Container(
                          //       margin: EdgeInsets.symmetric(vertical: 7.h),
                          //       width: 330.w,
                          //       height: 12.h,
                          //       decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(5.r),
                          //           color: Colors.grey[400]),
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.start,
                          //         children: [
                          //           Container(
                          //               width: progresscontroller.progress,
                          //               decoration: BoxDecoration(
                          //                   borderRadius:
                          //                       BorderRadius.circular(5.r),
                          //                   color: context.theme.primaryColor),
                          //               height: 15.h),
                          //         ],
                          //       ),
                          //     );
                          //   }),
                          if (_lessonController.ans == null ||
                              _lessonController.ans!.isEmpty)
                            Expanded(
                                flex: 4,
                                child: Center(
                                  child: Text(
                                    'لا يوجد أسئلة',
                                    style: ownStyle(
                                            Theme.of(context).primaryColor,
                                            18.sp)!
                                        .copyWith(fontWeight: FontWeight.w300),
                                  ),
                                ))
                          else
                            Obx(() {
                              for (int i = 0;
                                  i <
                                      _lessonController
                                          .ans![_lessonController
                                              .mathIndex.value]!
                                          .answer!
                                          .length;
                                  i++) {
                                if (_lessonController
                                    .ans![_lessonController.mathIndex.value]!
                                    .answer![i]
                                    .correctness!) {
                                  correctID = _lessonController
                                      .ans![_lessonController.mathIndex.value]!
                                      .answer![i]
                                      .id!;
                                }
                              }
                              WidgetsBinding.instance
                                  .addPostFrameCallback((timeStamp) {
                                if (!_lessonController.loading.value) {
                                  correctAnswer = null;
                                  selectedAnswer = null;
                                  if (checkSolvedAnswer(_lessonController
                                          .ans![_lessonController
                                              .mathIndex.value]!
                                          .id!) !=
                                      null) {
                                    checkAnswerController.restoreAlreadycheck =
                                        true;
                                  } else {
                                    checkAnswerController.restoreAlreadycheck =
                                        false;
                                  }
                                  RestoreResults? result = checkAnswerController
                                      .restoreQuestionWidgetState(
                                          correctAnswer: correctAnswer,
                                          correctID: correctID,
                                          isMcq: _lessonController
                                              .ans![_lessonController
                                                  .mathIndex.value]!
                                              .isMcq,
                                          isSelected: isSelected,
                                          questionId: _lessonController
                                              .ans![_lessonController
                                                  .mathIndex.value]!
                                              .id,
                                          selectedAnswer: selectedAnswer,
                                          show: _lessonController
                                              .ans![_lessonController
                                                  .mathIndex.value]!
                                              .show);
                                  print(result);
                                  if (result != null) {
                                    correctAnswer = result!.correctAnswer;
                                    correctID = result!.correctID;

                                    isSelected = result!.isSelected;

                                    selectedAnswer = result!.selectedAnswer;
                                    _lessonController
                                        .ans![
                                            _lessonController.mathIndex.value]!
                                        .show = result!.show!;

                                    _lessonController
                                        .ans![
                                            _lessonController.mathIndex.value]!
                                        .isWrong = _lessonController
                                            .ans![_lessonController
                                                .mathIndex.value]!
                                            .isWrong ??
                                        false;
                                    _lessonController
                                        .ans![
                                            _lessonController.mathIndex.value]!
                                        .right_times = result.right_times;
                                    checkAnswerController.update();
                                  }

                                  if (checkAnswerController
                                      .solvedAnswer.isNotEmpty) {
                                    _lessonController.numberOfWrongQA = 0;
                                    _lessonController.numberOfCorrectQA = 0;
                                    for (var element
                                        in checkAnswerController.solvedAnswer) {
                                      if (!element['correctness']) {
                                        // updateWrongness(
                                        //     element['questionId'], 1);

                                        _lessonController.numberOfWrongQA++;
                                      } else {
                                        // updateWrongness(
                                        //     element['questionId'], 0);

                                        _lessonController.numberOfCorrectQA++;
                                      }
                                    }
                                  }

                                  // print(result!.correctID);
                                  // print('########${result.correctAnswer}##########');
                                  // print(result!.selectedAnswer);
                                }
                              });

                              return Expanded(
                                  flex: 6,
                                  child: Card(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0.w, vertical: 5.w),
                                          child: SizedBox(
                                            height: media(context).height < 730
                                                ? media(context).height * 0.6

                                                ///4
                                                : media(context).height * 0.67,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 30.h,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: InkWell(
                                                            child: SizedBox(
                                                              width: 280.w,
                                                              child: Text(
                                                                  "${_lessonController.mathIndex.value + 1} - ",
                                                                  style: ownStyle(
                                                                          Get.theme
                                                                              .primaryColor,
                                                                          15
                                                                              .sp)!
                                                                      .copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w700)),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                            flex: 1,
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child:
                                                                  PopupMenuButton(
                                                                shadowColor:
                                                                    SeenColors
                                                                        .iconColor,
                                                                elevation: 20,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15.r)),
                                                                surfaceTintColor:
                                                                    Theme.of(
                                                                            context)
                                                                        .canvasColor,
                                                                icon: Icon(
                                                                    Icons
                                                                        .more_horiz,
                                                                    size: 20.w,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor),
                                                                itemBuilder:
                                                                    (context) =>
                                                                        <PopupMenuEntry>[
                                                                  PopupMenuItem(
                                                                      onTap:
                                                                          () async {
                                                                        textController
                                                                            .noteController
                                                                            .text = _lessonController
                                                                                .ans![_lessonController.mathIndex.value]!.note ??
                                                                            '';
                                                                        if (_lessonController.ans![_lessonController.mathIndex.value]!.note ==
                                                                            null) {
                                                                          Future
                                                                              .delayed(
                                                                            const Duration(seconds: 0),
                                                                            () {
                                                                              return showDialog(
                                                                                context: context,
                                                                                builder: (context) => AddNoteCard(
                                                                                  controller: textController.noteController,
                                                                                  msg: 'إضافة ملاحظة',
                                                                                  send: () async {
                                                                                    await updateNote(_lessonController.ans![_lessonController.mathIndex.value]!.id!, textController.noteController.text.isEmpty ? '' : textController.noteController.text);
                                                                                    _lessonController.ans![_lessonController.mathIndex.value]!.note = textController.noteController.text.isEmpty ? null : textController.noteController.text;
                                                                                    indexQuestionController.update();
                                                                                    Get.back();
                                                                                  },
                                                                                ),
                                                                              );
                                                                            },
                                                                          );
                                                                        } else {
                                                                          textController
                                                                              .noteController
                                                                              .text = _lessonController
                                                                                  .ans![_lessonController.mathIndex.value]!.note ??
                                                                              '';
                                                                          Future
                                                                              .delayed(
                                                                            const Duration(seconds: 0),
                                                                            () =>
                                                                                showDialog(
                                                                              context: context,
                                                                              builder: (context) => AddNoteCard(
                                                                                controller: textController.noteController,
                                                                                msg: 'إضافة ملاحظة',
                                                                                send: () async {
                                                                                  await updateNote(_lessonController.ans![_lessonController.mathIndex.value]!.id!, _lessonController.ans![_lessonController.mathIndex.value]!.note = textController.noteController.text.isEmpty ? '' : textController.noteController.text);
                                                                                  _lessonController.ans![_lessonController.mathIndex.value]!.note = textController.noteController.text.isEmpty ? null : textController.noteController.text;
                                                                                  indexQuestionController.update();
                                                                                  Get.back();
                                                                                },
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }

                                                                        indexQuestionController
                                                                            .update();
                                                                      },
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            _lessonController.ans![_lessonController.mathIndex.value]!.note == null
                                                                                ? 'إضافة ملاحظة'
                                                                                : 'تعديل الملاحظة',
                                                                            style:
                                                                                ownStyle(Theme.of(context).primaryColor, 16.sp),
                                                                          ),
                                                                          Divider(
                                                                            color:
                                                                                Theme.of(context).primaryColor,
                                                                            endIndent:
                                                                                10.w,
                                                                            indent:
                                                                                3.w,
                                                                          )
                                                                        ],
                                                                      )),
                                                                  PopupMenuItem(
                                                                      onTap:
                                                                          () async {
                                                                        await {
                                                                          _lessonController.ans![_lessonController.mathIndex.value]!.isFavorites!
                                                                              ? await addRemoveFavorites(_lessonController.ans![_lessonController.mathIndex.value]!.id!, 0)
                                                                              : await addRemoveFavorites(_lessonController.ans![_lessonController.mathIndex.value]!.id!, 1)
                                                                        };
                                                                        _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .isFavorites = !_lessonController.ans![_lessonController.mathIndex.value]!.isFavorites!;
                                                                        indexQuestionController
                                                                            .update();
                                                                      },
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            _lessonController.ans![_lessonController.mathIndex.value]!.isFavorites!
                                                                                ? 'إزالة من المفضلة'
                                                                                : 'إضافة إلى المفضلة',
                                                                            style:
                                                                                ownStyle(Theme.of(context).primaryColor, 16.sp),
                                                                          ),
                                                                          Divider(
                                                                            color:
                                                                                Theme.of(context).primaryColor,
                                                                            endIndent:
                                                                                10.w,
                                                                            indent:
                                                                                3.w,
                                                                          )
                                                                        ],
                                                                      )),
                                                                ],
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  // SizedBox(
                                                  //   height: 6.h,
                                                  // ),
                                                  Directionality(
                                                    textDirection:
                                                        TextDirection.ltr,
                                                    child: Column(
                                                      children: [
                                                        Scrollbar(
                                                          controller:
                                                              scrollController,
                                                          interactive: true,
                                                          thumbVisibility: true,
                                                          trackVisibility: true,
                                                          thickness: 3,
                                                          scrollbarOrientation:
                                                              ScrollbarOrientation
                                                                  .bottom,
                                                          child:
                                                              SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            controller:
                                                                scrollController,
                                                            child: InkWell(
                                                              onLongPress: () {
                                                                _lessonController
                                                                        .ans![_lessonController
                                                                            .mathIndex
                                                                            .value]!
                                                                        .show =
                                                                    indexQuestionController.showHint_Note(
                                                                        true,
                                                                        _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .show!);
                                                                _lessonController
                                                                        .ans![_lessonController
                                                                            .mathIndex
                                                                            .value]!
                                                                        .show =
                                                                    _lessonController
                                                                        .ans![_lessonController
                                                                            .mathIndex
                                                                            .value]!
                                                                        .show;
                                                              },
                                                              child: Container(
                                                                  width: media(
                                                                              context)
                                                                          .width *
                                                                      0.85,
                                                                  margin: EdgeInsets.only(
                                                                      top: 0,
                                                                      bottom:
                                                                          10.h,
                                                                      left: 5.w,
                                                                      right:
                                                                          5.w),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(15
                                                                              .r)),
                                                                  child: LaTexT(
                                                                      laTeXCode:
                                                                          Text(
                                                                    _lessonController
                                                                        .ans![_lessonController
                                                                            .mathIndex
                                                                            .value]!
                                                                        .questionContent!,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    textDirection:
                                                                        TextDirection
                                                                            .rtl,
                                                                    style: ownStyle(context.theme.primaryColor, 22.sp)!.copyWith(
                                                                        height: 2.4
                                                                            .h,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ))),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  (_lessonController
                                                                  .ans![_lessonController
                                                                      .mathIndex
                                                                      .value]!
                                                                  .url ==
                                                              null ||
                                                          _lessonController
                                                              .ans![
                                                                  _lessonController
                                                                      .mathIndex
                                                                      .value]!
                                                              .url!
                                                              .isEmpty)
                                                      ? const SizedBox()
                                                      : Container(
                                                          clipBehavior:
                                                              Clip.hardEdge,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.r)),
                                                          child: StatefulBuilder(
                                                              builder: (context,
                                                                  setstate) {
                                                            return reloadingImage
                                                                ? SizedBox()
                                                                : InkWell(
                                                                    onDoubleTap:
                                                                        () async {
                                                                      setstate(
                                                                          () {
                                                                        reloadingImage =
                                                                            true;
                                                                      });
                                                                      await FastCachedImageConfig.deleteCachedImage(
                                                                          imageUrl:
                                                                              baseUrlForImage! + _lessonController.ans![_lessonController.mathIndex.value]!.url!);
                                                                      await Future.delayed(Duration(
                                                                          milliseconds:
                                                                              500));

                                                                      setstate(
                                                                          () {
                                                                        reloadingImage =
                                                                            false;
                                                                      });
                                                                    },
                                                                    child: FastCachedImage(
                                                                        fadeInDuration: Duration.zero,
                                                                        fit: BoxFit.fitWidth,
                                                                        width: 400.w,
                                                                        url: baseUrlForImage! + _lessonController.ans![_lessonController.mathIndex.value]!.url!,
                                                                        loadingBuilder: (context, downloadProgress) => Center(
                                                                              child: CircularProgressIndicator(value: downloadProgress.progressPercentage.value, color: Theme.of(context).primaryColor),
                                                                            ),
                                                                        errorBuilder: (context, url, error) => const Icon(
                                                                              Icons.refresh,
                                                                              color: Colors.red,
                                                                            )),
                                                                  );
                                                          }),
                                                        ),
                                                  ListView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: _lessonController
                                                            .ans![
                                                                _lessonController
                                                                    .mathIndex
                                                                    .value]!
                                                            .isMcq!
                                                        ? _lessonController
                                                            .ans![
                                                                _lessonController
                                                                    .mathIndex
                                                                    .value]!
                                                            .answer!
                                                            .length
                                                        : 1,
                                                    itemBuilder: (context, i) {
                                                      return Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 5.h),
                                                        child: _lessonController
                                                                .ans![_lessonController
                                                                    .mathIndex
                                                                    .value]!
                                                                .isMcq!
                                                            ? GetBuilder<
                                                                    CheckAnswerController>(
                                                                builder:
                                                                    (innerController) {
                                                                return GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      checkAnswerController.solvedAnswer.removeWhere((element) =>
                                                                          element[
                                                                              'questionId'] ==
                                                                          _lessonController
                                                                              .ans![_lessonController.mathIndex.value]!
                                                                              .id!);
                                                                      checkAnswerController
                                                                          .solvedAnswer
                                                                          .add({
                                                                        'is_wrong': _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .isWrong,
                                                                        nextShowDate: _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .nextDate,
                                                                        rightTimes: _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .right_times,
                                                                        cspreviousIdCol:
                                                                            arg['prev_id'],
                                                                        'a_index':
                                                                            i,
                                                                        'subid':
                                                                            arg['subID'],
                                                                        alreadyChecked:
                                                                            false,
                                                                        'choice': _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .answer![i]
                                                                            .id,
                                                                        "answerId": _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .answer![i]
                                                                            .id,
                                                                        "correctness": _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .answer![i]
                                                                            .correctness,
                                                                        "answerContent": _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .answer![i]
                                                                            .answerContent,
                                                                        "questionId": _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .id!,
                                                                        "index": _lessonController
                                                                            .mathIndex
                                                                            .value,
                                                                        "correctIndex":
                                                                            correctID,
                                                                        csSubjectID:
                                                                            arg['subjectID']
                                                                      });

                                                                      _lessonController.ans![_lessonController.mathIndex.value]!.groupValue = _lessonController
                                                                          .ans![_lessonController
                                                                              .mathIndex
                                                                              .value]!
                                                                          .answer![
                                                                              i]
                                                                          .id!;
                                                                      _lessonController
                                                                          .ans![_lessonController
                                                                              .mathIndex
                                                                              .value]!
                                                                          .checked = true;

                                                                      await indexQuestionController.saveSession(
                                                                          subjectid: arg[
                                                                              'subjectID'],
                                                                          isAllFav: _lessonController
                                                                              .isAllFave,
                                                                          isAllWrong: _lessonController
                                                                              .isAllWrong,
                                                                          isFav: _lessonController
                                                                              .isFave,
                                                                          isWrong: _lessonController
                                                                              .isWrong,
                                                                          isPrev: _lessonController
                                                                              .isPreiviosQuestios,
                                                                          prevId: arg[
                                                                              'prev_id'],
                                                                          alreadyChecke:
                                                                              false,
                                                                          subid: arg[
                                                                              'subID'],
                                                                          qid: _lessonController
                                                                              .ans![_lessonController
                                                                                  .mathIndex.value]!
                                                                              .id!,
                                                                          choice: _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id!
                                                                              .toString(),
                                                                          index: _lessonController
                                                                              .mathIndex
                                                                              .value,
                                                                          a_content: _lessonController
                                                                              .ans![_lessonController.mathIndex.value]!
                                                                              .answer![i]
                                                                              .answerContent!,
                                                                          a_index: i,
                                                                          correctness: _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].correctness!,
                                                                          correct_index: correctID!,
                                                                          isRandom: _lessonController.isRandomize);
                                                                      _lessonController
                                                                          .numberOfRemainingQA
                                                                          .value = _lessonController
                                                                              .numberOfQA
                                                                              .value -
                                                                          innerController
                                                                              .solvedAnswer
                                                                              .length;
                                                                      checkAnswerController
                                                                          .update();
                                                                    },
                                                                    onLongPress:
                                                                        () async {
                                                                      int valueBeforeUpdateWrongness =
                                                                          _lessonController.ans![_lessonController.mathIndex.value]!.right_times ??
                                                                              0;

                                                                      checkAnswerController
                                                                              .restoreAlreadycheck =
                                                                          true;
                                                                      print(
                                                                          '############${valueBeforeUpdateWrongness}#########');
                                                                      await HapticFeedback
                                                                          .selectionClick();

                                                                      checkAnswerController.solvedAnswer.removeWhere((element) =>
                                                                          element[
                                                                              'questionId'] ==
                                                                          _lessonController
                                                                              .ans![_lessonController.mathIndex.value]!
                                                                              .id!);

                                                                      checkAnswerController.doubleCheckedAnswer.removeWhere((element) =>
                                                                          element[
                                                                              'questionId'] ==
                                                                          _lessonController
                                                                              .ans![_lessonController.mathIndex.value]!
                                                                              .id!);
                                                                      if (_lessonController
                                                                          .ans![_lessonController
                                                                              .mathIndex
                                                                              .value]!
                                                                          .answer![
                                                                              i]
                                                                          .correctness!) {
                                                                        valueBeforeUpdateWrongness++;
                                                                        await updateWrongness(
                                                                            _lessonController.ans![_lessonController.mathIndex.value]!.id!,
                                                                            0);
                                                                      } else {
                                                                        await updateWrongness(
                                                                            _lessonController.ans![_lessonController.mathIndex.value]!.id!,
                                                                            1);
                                                                      }

                                                                      var tempWronInfo = await getQuestionRightSolvedTimesAndNextTimes(_lessonController
                                                                          .ans![_lessonController
                                                                              .mathIndex
                                                                              .value]!
                                                                          .id!);
                                                                      if (tempWronInfo ==
                                                                          null) {
                                                                        _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .right_times = 0;
                                                                        _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .isWrong = false;
                                                                      } else {
                                                                        _lessonController
                                                                            .ans![_lessonController
                                                                                .mathIndex.value]!
                                                                            .right_times = tempWronInfo[
                                                                                'right_times'] ??
                                                                            0;
                                                                        _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .nextDate = tempWronInfo[nextShowDate];
                                                                      }
                                                                      print(
                                                                          '############00');
                                                                      print(
                                                                          tempWronInfo);

                                                                      if (valueBeforeUpdateWrongness ==
                                                                          5) {
                                                                        print(
                                                                            '######vcat######00');
                                                                        _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .isWrong = false;
                                                                      }

                                                                      if (!_lessonController
                                                                          .ans![_lessonController
                                                                              .mathIndex
                                                                              .value]!
                                                                          .answer![
                                                                              i]
                                                                          .correctness!) {
                                                                        _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .isWrong = true;
                                                                      }
                                                                      if ((_lessonController
                                                                              .ans![_lessonController
                                                                                  .mathIndex.value]!
                                                                              .groupValue! ==
                                                                          (_lessonController.ans![_lessonController.mathIndex.value]!.id! +
                                                                              50001))) {
                                                                        if (_lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .answer![i]
                                                                            .correctness!) {
                                                                          isSelected =
                                                                              correctID;
                                                                          correctAnswer =
                                                                              correctID;
                                                                          _lessonController
                                                                              .numberOfCorrectQA++;
                                                                          _lessonController.ans![_lessonController.mathIndex.value]!.groupValue = _lessonController
                                                                              .ans![_lessonController.mathIndex.value]!
                                                                              .answer![i]
                                                                              .id!;

                                                                          //   _lessonController
                                                                          //       .ans![_lessonController.mathIndex.value]!
                                                                          //       .isWrong = false;
                                                                          // updateWrongness(
                                                                          //     _lessonController.ans![_lessonController.mathIndex.value]!.id!,
                                                                          //     0);

                                                                          checkAnswerController
                                                                              .update();
                                                                        } else {
                                                                          //   _lessonController
                                                                          //       .ans![_lessonController.mathIndex.value]!
                                                                          //       .isWrong = true;
                                                                          // updateWrongness(
                                                                          //     _lessonController.ans![_lessonController.mathIndex.value]!.id!,
                                                                          //     1);
                                                                          correctAnswer =
                                                                              correctID;
                                                                          isSelected = _lessonController
                                                                              .ans![_lessonController.mathIndex.value]!
                                                                              .answer![i]
                                                                              .id;
                                                                          selectedAnswer = _lessonController
                                                                              .ans![_lessonController.mathIndex.value]!
                                                                              .answer![i]
                                                                              .id;
                                                                          _lessonController
                                                                              .numberOfWrongQA++;
                                                                          _lessonController.ans![_lessonController.mathIndex.value]!.groupValue = _lessonController
                                                                              .ans![_lessonController.mathIndex.value]!
                                                                              .answer![i]
                                                                              .id!;

                                                                          checkAnswerController
                                                                              .update();
                                                                        }
                                                                        insertUserAnswer(
                                                                            _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id!,
                                                                            _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].correctness!);
                                                                      } else {
                                                                        if ((correctAnswer ==
                                                                                null &&
                                                                            selectedAnswer ==
                                                                                null)) {
                                                                          if (_lessonController
                                                                              .ans![_lessonController.mathIndex.value]!
                                                                              .answer![i]
                                                                              .correctness!) {
                                                                            correctAnswer =
                                                                                correctID;
                                                                            isSelected =
                                                                                _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id;

                                                                            _lessonController.ans![_lessonController.mathIndex.value]!.groupValue =
                                                                                _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id!;
                                                                            selectedAnswer =
                                                                                null;
                                                                            _lessonController.numberOfCorrectQA++;
                                                                            insertUserAnswer(_lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id!,
                                                                                _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].correctness!);
                                                                            _lessonController.ans![_lessonController.mathIndex.value]!.isWrong!
                                                                                ? {
                                                                                    // _lessonController.ans![_lessonController.mathIndex.value]!.isWrong = false,
                                                                                  }
                                                                                : null;
//  await  updateWrongness(_lessonController.ans![_lessonController.mathIndex.value]!.id!, 0);
                                                                            checkAnswerController.update();
                                                                          } else {
                                                                            correctAnswer =
                                                                                correctID;
                                                                            _lessonController.ans![_lessonController.mathIndex.value]!.isWrong!
                                                                                ? null
                                                                                : {
                                                                                    // _lessonController.ans![_lessonController.mathIndex.value]!.isWrong = true,
                                                                                  };
                                                                            //  await                 updateWrongness(_lessonController.ans![_lessonController.mathIndex.value]!.id!, 1);
                                                                            isSelected =
                                                                                _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id;
                                                                            selectedAnswer =
                                                                                _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id;
                                                                            _lessonController.numberOfWrongQA++;
                                                                            insertUserAnswer(_lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id!,
                                                                                _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].correctness!);
                                                                            _lessonController.ans![_lessonController.mathIndex.value]!.groupValue =
                                                                                _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id!;
                                                                            checkAnswerController.update();
                                                                          }
                                                                        } else if (_lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .answer![i]
                                                                            .correctness!) {
                                                                          if (isSelected ==
                                                                              _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id) {
                                                                          } else {
                                                                            if (_lessonController.numberOfWrongQA >
                                                                                0) {
                                                                              _lessonController.numberOfWrongQA--;
                                                                            }
                                                                            correctAnswer =
                                                                                correctID;
                                                                            isSelected =
                                                                                _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id;

                                                                            // correctAnswer = _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id;
                                                                            _lessonController.ans![_lessonController.mathIndex.value]!.groupValue =
                                                                                _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id!;
                                                                            selectedAnswer =
                                                                                null;
                                                                            _lessonController.numberOfCorrectQA++;
                                                                            insertUserAnswer(_lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id!,
                                                                                _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].correctness!);

                                                                            // _lessonController.ans![_lessonController.mathIndex.value]!.isWrong =
                                                                            // false;
                                                                            // updateWrongness(_lessonController.ans![_lessonController.mathIndex.value]!.id!,
                                                                            //     0);
                                                                          }

                                                                          checkAnswerController
                                                                              .update();
                                                                        } else {
                                                                          if (isSelected ==
                                                                              _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id) {
                                                                          } else {
                                                                            _lessonController.ans![_lessonController.mathIndex.value]!.groupValue =
                                                                                _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id!;
                                                                            if (isSelected ==
                                                                                correctID) {
                                                                              _lessonController.numberOfWrongQA++;
                                                                              if (_lessonController.numberOfCorrectQA > 0) {
                                                                                _lessonController.numberOfCorrectQA--;
                                                                              }
                                                                            }
                                                                            correctAnswer =
                                                                                correctID;
                                                                            _lessonController.ans![_lessonController.mathIndex.value]!.isWrong!
                                                                                ? null
                                                                                : {
                                                                                    // _lessonController.ans![_lessonController.mathIndex.value]!.isWrong = true,
                                                                                  };
                                                                            //  await   updateWrongness(_lessonController.ans![_lessonController.mathIndex.value]!.id!, 1);
                                                                            isSelected =
                                                                                _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id;
                                                                            selectedAnswer =
                                                                                _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id;
                                                                            insertUserAnswer(_lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id!,
                                                                                _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].correctness!);
                                                                          }
                                                                          checkAnswerController
                                                                              .update();
                                                                        }
                                                                      }
                                                                      checkAnswerController
                                                                          .solvedAnswer
                                                                          .add({
                                                                        'is_wrong': _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .isWrong,
                                                                        nextShowDate: _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .nextDate,
                                                                        rightTimes: _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .right_times,
                                                                        cspreviousIdCol:
                                                                            arg['prev_id'],
                                                                        'subid':
                                                                            arg['subID'],
                                                                        'a_index':
                                                                            i,
                                                                        alreadyChecked:
                                                                            true,
                                                                        'choice': _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .answer![i]
                                                                            .id,
                                                                        "answerId": _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .answer![i]
                                                                            .id,
                                                                        "correctness": _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .answer![i]
                                                                            .correctness,
                                                                        "answerContent": _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .answer![i]
                                                                            .answerContent,
                                                                        "questionId": _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .id!,
                                                                        "index": _lessonController
                                                                            .mathIndex
                                                                            .value,
                                                                        "correctIndex":
                                                                            correctID,
                                                                        csSubjectID:
                                                                            arg['subjectID']
                                                                      });
                                                                      checkAnswerController
                                                                          .doubleCheckedAnswer
                                                                          .add({
                                                                        'is_wrong': _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .isWrong,
                                                                        nextShowDate: _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .nextDate,
                                                                        rightTimes: _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .right_times,
                                                                        cspreviousIdCol:
                                                                            arg['prev_id'],
                                                                        'subid':
                                                                            arg['subID'],
                                                                        'a_index':
                                                                            i,
                                                                        alreadyChecked:
                                                                            true,
                                                                        'choice': _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .answer![i]
                                                                            .id,
                                                                        "answerId": _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .answer![i]
                                                                            .id,
                                                                        "correctness": _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .answer![i]
                                                                            .correctness,
                                                                        "answerContent": _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .answer![i]
                                                                            .answerContent,
                                                                        "questionId": _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .id!,
                                                                        "index": _lessonController
                                                                            .mathIndex
                                                                            .value,
                                                                        "correctIndex":
                                                                            correctID,
                                                                        csSubjectID:
                                                                            arg['subjectID']
                                                                      });
                                                                      // checkAnswerController.update();
                                                                      await indexQuestionController.saveSession(
                                                                          subjectid: arg[
                                                                              'subjectID'],
                                                                          isAllFav: _lessonController
                                                                              .isAllFave,
                                                                          isAllWrong: _lessonController
                                                                              .isAllWrong,
                                                                          isFav: _lessonController
                                                                              .isFave,
                                                                          isWrong: _lessonController
                                                                              .isWrong,
                                                                          isPrev: _lessonController
                                                                              .isPreiviosQuestios,
                                                                          prevId: arg[
                                                                              'prev_id'],
                                                                          alreadyChecke:
                                                                              true,
                                                                          subid: arg[
                                                                              'subID'],
                                                                          qid: _lessonController
                                                                              .ans![_lessonController
                                                                                  .mathIndex.value]!
                                                                              .id!,
                                                                          choice: _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id!
                                                                              .toString(),
                                                                          index: _lessonController
                                                                              .mathIndex
                                                                              .value,
                                                                          a_content: _lessonController
                                                                              .ans![_lessonController.mathIndex.value]!
                                                                              .answer![i]
                                                                              .answerContent!,
                                                                          a_index: i,
                                                                          correctness: _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].correctness!,
                                                                          correct_index: correctID!,
                                                                          isRandom: _lessonController.isRandomize);

                                                                      _lessonController
                                                                          .numberOfRemainingQA
                                                                          .value = _lessonController
                                                                              .numberOfQA
                                                                              .value -
                                                                          innerController
                                                                              .solvedAnswer
                                                                              .length;
                                                                      //  checkAnswerController.update();

                                                                      checkAnswerController
                                                                              .restoreAlreadycheck =
                                                                          true;

                                                                      indexQuestionController
                                                                          .update();
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      margin: EdgeInsets.only(
                                                                          bottom:
                                                                              0.h),
                                                                      padding: EdgeInsets.only(
                                                                          right: 8
                                                                              .w,
                                                                          left:
                                                                              3.w),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(30.r),
                                                                        color: correctAnswer ==
                                                                                _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id
                                                                            ? SeenColors.rightAnswer
                                                                            : selectedAnswer == _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id
                                                                                ? SeenColors.wrongAnswer
                                                                                : _lessonController.ans![_lessonController.mathIndex.value]!.groupValue == _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id!
                                                                                    ? Theme.of(context).primaryColor.withOpacity(0.4)
                                                                                    : Colors.transparent,
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.only(top: 4.h),
                                                                                child: Text(
                                                                                  "${letters[i]} -  ",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: ownStyle(
                                                                                          correctAnswer == _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id
                                                                                              ? const Color.fromARGB(255, 67, 126, 65)
                                                                                              : selectedAnswer == _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id
                                                                                                  ? const Color.fromARGB(255, 173, 56, 5120)
                                                                                                  : _lessonController.ans![_lessonController.mathIndex.value]!.groupValue == _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id!
                                                                                                      ? Theme.of(context).primaryColor.withOpacity(0.8)
                                                                                                      : _themeController.isDarkMode.value
                                                                                                          ? SeenColors.iconColor
                                                                                                          : SeenColors.answerText,
                                                                                          13.sp)!
                                                                                      .copyWith(fontWeight: FontWeight.w600),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: (_lessonController.ans![_lessonController.mathIndex.value]!.answer![i].url == null || _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].url!.isEmpty) ? 230.w : 150.w,
                                                                                child: Directionality(
                                                                                  textDirection: TextDirection.ltr,
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Scrollbar(
                                                                                        controller: scrollController,
                                                                                        interactive: true,
                                                                                        thumbVisibility: true,
                                                                                        trackVisibility: true,
                                                                                        thickness: 2,
                                                                                        child: SingleChildScrollView(
                                                                                          controller: ScrollController(),
                                                                                          child: Container(
                                                                                            margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                                                                                            alignment: Alignment.center,
                                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.r)),
                                                                                            child: LaTexT(
                                                                                                laTeXCode: Text(
                                                                                              _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].answerContent ?? '',
                                                                                              textAlign: TextAlign.center,
                                                                                              textDirection: TextDirection.rtl,
                                                                                              style: ownStyle(
                                                                                                      correctAnswer == _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id
                                                                                                          ? const Color.fromARGB(255, 67, 126, 65)
                                                                                                          : selectedAnswer == _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id
                                                                                                              ? const Color.fromARGB(255, 173, 56, 5120)
                                                                                                              : _lessonController.ans![_lessonController.mathIndex.value]!.groupValue == _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id!
                                                                                                                  ? Theme.of(context).primaryColor.withOpacity(0.8)
                                                                                                                  : _themeController.isDarkMode.value
                                                                                                                      ? SeenColors.iconColor
                                                                                                                      : SeenColors.answerText,
                                                                                                      16.sp)!
                                                                                                  .copyWith(height: 1.6, fontWeight: FontWeight.w400),
                                                                                            )),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ]),
                                                                          ),
                                                                          (_lessonController.ans![_lessonController.mathIndex.value]!.answer![i].url == null || _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].url!.isEmpty)
                                                                              ? const SizedBox()
                                                                              : Container(
                                                                                  margin: EdgeInsets.all(2.w),
                                                                                  clipBehavior: Clip.hardEdge,
                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.r)),
                                                                                  child: FastCachedImage(
                                                                                      fadeInDuration: Duration.zero,
                                                                                      fit: BoxFit.fill,
                                                                                      width: 75.w,
                                                                                      height: 45.h,
                                                                                      url: baseUrlForImage! + _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].url!,
                                                                                      loadingBuilder: (context, downloadProgress) => Center(
                                                                                            child: CircularProgressIndicator(value: downloadProgress.progressPercentage.value, color: Theme.of(context).primaryColor),
                                                                                          ),
                                                                                      errorBuilder: (context, url, error) => const Icon(
                                                                                            Icons.error,
                                                                                            color: Colors.red,
                                                                                          )),
                                                                                ),
                                                                          Radio(
                                                                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                              visualDensity: VisualDensity.comfortable,
                                                                              splashRadius: 10.r,
                                                                              activeColor: correctAnswer == _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id
                                                                                  ? const Color.fromARGB(255, 45, 92, 43)
                                                                                  : selectedAnswer == _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id
                                                                                      ? const Color.fromARGB(255, 161, 52, 47)
                                                                                      : Get.theme.primaryColor,
                                                                              value: _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id,
                                                                              groupValue: _lessonController.ans![_lessonController.mathIndex.value]!.groupValue,
                                                                              onChanged: (val) async {
                                                                                _lessonController.ans![_lessonController.mathIndex.value]!.groupValue = val!;

                                                                                checkAnswerController.solvedAnswer.removeWhere((element) => element['questionId'] == _lessonController.ans![_lessonController.mathIndex.value]!.id!);
                                                                                checkAnswerController.solvedAnswer.add({
                                                                                  'is_wrong': _lessonController.ans![_lessonController.mathIndex.value]!.isWrong,
                                                                                  nextShowDate: _lessonController.ans![_lessonController.mathIndex.value]!.nextDate,
                                                                                  rightTimes: _lessonController.ans![_lessonController.mathIndex.value]!.right_times,
                                                                                  cspreviousIdCol: arg['prev_id'],
                                                                                  'a_index': i,
                                                                                  'subid': arg['subID'],
                                                                                  alreadyChecked: false,
                                                                                  'choice': _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id,
                                                                                  "answerId": _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id,
                                                                                  "correctness": _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].correctness,
                                                                                  "answerContent": _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].answerContent,
                                                                                  "questionId": _lessonController.ans![_lessonController.mathIndex.value]!.id!,
                                                                                  "index": _lessonController.mathIndex.value,
                                                                                  "correctIndex": correctID,
                                                                                  csSubjectID: arg['subjectID']
                                                                                });

                                                                                _lessonController.ans![_lessonController.mathIndex.value]!.checked = true;

                                                                                await indexQuestionController.saveSession(subjectid: arg['subjectID'], isAllFav: _lessonController.isAllFave, isAllWrong: _lessonController.isAllWrong, isFav: _lessonController.isFave, isWrong: _lessonController.isWrong, isPrev: _lessonController.isPreiviosQuestios, prevId: arg['prev_id'], alreadyChecke: false, subid: arg['subID'], qid: _lessonController.ans![_lessonController.mathIndex.value]!.id!, choice: _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].id!.toString(), index: _lessonController.mathIndex.value, a_content: _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].answerContent!, a_index: i, correctness: _lessonController.ans![_lessonController.mathIndex.value]!.answer![i].correctness!, correct_index: correctID!, isRandom: _lessonController.isRandomize);
                                                                                _lessonController.numberOfRemainingQA.value = _lessonController.numberOfQA.value - innerController.solvedAnswer.length;
                                                                                checkAnswerController.update();
                                                                              })
                                                                        ],
                                                                      ),
                                                                    ));
                                                              })
                                                            : const SizedBox(),
                                                      );
                                                    },
                                                  ),
                                                  GetBuilder<
                                                          IndexQuestionController>(
                                                      builder: (controller) {
                                                    return _lessonController
                                                                .ans![_lessonController
                                                                    .mathIndex
                                                                    .value]!
                                                                .show ??
                                                            false
                                                        ? Column(
                                                            children: [
                                                              (_lessonController.ans![_lessonController.mathIndex.value]!.questionNote ==
                                                                          null ||
                                                                      _lessonController.ans![_lessonController.mathIndex.value]!.answer![0].answerContent ==
                                                                          null)
                                                                  ? const SizedBox()
                                                                  : QuestionAddition(
                                                                      image:
                                                                          'hint.svg',
                                                                      leading:
                                                                          '',
                                                                      isMcq: _lessonController
                                                                          .ans![_lessonController
                                                                              .mathIndex
                                                                              .value]!
                                                                          .isMcq!,
                                                                      url: _lessonController
                                                                          .ans![_lessonController
                                                                              .mathIndex
                                                                              .value]!
                                                                          .hurl,
                                                                      isMath:
                                                                          true,
                                                                      questionAddition: _lessonController.ans![_lessonController.mathIndex.value]!.isMcq!
                                                                          ? _lessonController
                                                                              .ans![_lessonController
                                                                                  .mathIndex.value]!
                                                                              .questionNote
                                                                          : _lessonController
                                                                              .ans![_lessonController.mathIndex.value]!
                                                                              .answer![0]
                                                                              .answerContent),
                                                              _lessonController
                                                                          .ans![_lessonController
                                                                              .mathIndex
                                                                              .value]!
                                                                          .note ==
                                                                      null
                                                                  ? const SizedBox()
                                                                  : QuestionAddition(
                                                                      image:
                                                                          'Note.svg',
                                                                      leading:
                                                                          '',
                                                                      isMcq:
                                                                          false,
                                                                      questionAddition: _lessonController
                                                                          .ans![_lessonController
                                                                              .mathIndex
                                                                              .value]!
                                                                          .note),
                                                            ],
                                                          )
                                                        : const SizedBox();
                                                  }),
                                                  SizedBox(
                                                    height: 3.h,
                                                  ),
                                                  Row(
                                                    children: [
                                                      FutureBuilder(
                                                          future: getAllexamsForQuestion(
                                                              _lessonController
                                                                  .ans![_lessonController
                                                                      .mathIndex
                                                                      .value]!
                                                                  .id!),
                                                          builder:
                                                              (context, snap) {
                                                            if (snap.hasData) {
                                                              preNames =
                                                                  snap.data;
                                                              WidgetsBinding
                                                                  .instance
                                                                  .addPostFrameCallback(
                                                                      (timeStamp) {
                                                                examsLogController
                                                                    .update();
                                                              });

                                                              return GetBuilder<
                                                                      ShowListController>(
                                                                  builder: (_) {
                                                                return SizedBox(
                                                                  height: (0 <
                                                                              length! &&
                                                                          length! <
                                                                              2)
                                                                      ? 35.h
                                                                      : null,
                                                                  width: 250.w,
                                                                  child: Wrap(
                                                                      spacing:
                                                                          8.w,
                                                                      clipBehavior:
                                                                          Clip.antiAliasWithSaveLayer,
                                                                      // itemCount:,

                                                                      children: [
                                                                        for (int index =
                                                                                0;
                                                                            index <
                                                                                (snap.data!.length <= 2 ? snap.data!.length : length!);
                                                                            index++)
                                                                          Container(
                                                                            constraints:
                                                                                BoxConstraints(maxWidth: snap.data![index].toString().length > 15 ? 200.w : 100.w, minWidth: 50.w),
                                                                            margin:
                                                                                EdgeInsets.symmetric(vertical: 4.h),
                                                                            decoration:
                                                                                BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(15.r)),
                                                                            alignment:
                                                                                Alignment.center,
                                                                            padding:
                                                                                EdgeInsets.symmetric(vertical: 3.w, horizontal: 5.w),
                                                                            child:
                                                                                Text(
                                                                              snap.data![index] == null ? '' : snap.data![index].toString(),
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
                                                      GetBuilder<
                                                              ExamsLogController>(
                                                          builder: (_) {
                                                        return (preNames!
                                                                    .isEmpty ||
                                                                !(preNames!.length >=
                                                                        2 &&
                                                                    preNames![0]
                                                                            .length >=
                                                                        10))
                                                            ? SizedBox()
                                                            : InkWell(
                                                                onTap: () {
                                                                  if (length ==
                                                                      preNames!
                                                                          .length) {
                                                                    if (preNames!
                                                                            .length >=
                                                                        2) {
                                                                      if (preNames![0]
                                                                              .length >=
                                                                          10) {
                                                                        length =
                                                                            1;
                                                                      } else {
                                                                        length =
                                                                            2;
                                                                      }
                                                                    }
                                                                  } else {
                                                                    length =
                                                                        preNames!
                                                                            .length;
                                                                  }
                                                                  ;
                                                                  showListController
                                                                      .update();
                                                                },
                                                                child:
                                                                    Container(
                                                                        decoration: BoxDecoration(
                                                                            color: Theme.of(context)
                                                                                .primaryColor,
                                                                            borderRadius: BorderRadius.circular(15
                                                                                .r)),
                                                                        alignment:
                                                                            Alignment
                                                                                .center,
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical: 0
                                                                                .w,
                                                                            horizontal: 8
                                                                                .w),
                                                                        margin: EdgeInsets.symmetric(
                                                                            horizontal: 8
                                                                                .w),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .more_horiz,
                                                                          color:
                                                                              Colors.white,
                                                                        )),
                                                              );
                                                      })
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 4.h, top: 10.h),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(width: 10.w),
                                                    _lessonController
                                                                .ans![_lessonController
                                                                    .mathIndex
                                                                    .value]!
                                                                .questionNote !=
                                                            null
                                                        ? SvgPicture.asset(
                                                            'assets/Qustions/hint.svg',
                                                            height: 10.h,
                                                            colorFilter:
                                                                ColorFilter.mode(
                                                                    Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    BlendMode
                                                                        .srcIn))
                                                        : const SizedBox(),
                                                    SizedBox(width: 5.w),
                                                    GetBuilder<
                                                            IndexQuestionController>(
                                                        builder: (_) {
                                                      return _lessonController
                                                                  .ans![_lessonController
                                                                      .mathIndex
                                                                      .value]!
                                                                  .note !=
                                                              null
                                                          ? SvgPicture.asset(
                                                              'assets/Qustions/Note.svg',
                                                              height: 10.h,
                                                              colorFilter: ColorFilter.mode(
                                                                  Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  BlendMode
                                                                      .srcIn))
                                                          : const SizedBox();
                                                    }),
                                                    SizedBox(width: 5.w),
                                                    GetBuilder<
                                                            IndexQuestionController>(
                                                        builder: (_) {
                                                      return _lessonController
                                                              .ans![
                                                                  _lessonController
                                                                      .mathIndex
                                                                      .value]!
                                                              .isWrong!
                                                          ? Row(
                                                              children: [
                                                                SvgPicture.asset(
                                                                    'assets/Qustions/X.svg',
                                                                    height:
                                                                        10.h,
                                                                    colorFilter: ColorFilter.mode(
                                                                        Theme.of(context)
                                                                            .primaryColor,
                                                                        BlendMode
                                                                            .srcIn)),
                                                                _lessonController
                                                                            .ans![_lessonController.mathIndex.value]!
                                                                            .right_times ==
                                                                        null
                                                                    ? SizedBox()
                                                                    : Text(
                                                                        (5 - (_lessonController.ans![_lessonController.mathIndex.value]!.right_times ?? 0))
                                                                            .toString(),
                                                                        style: ownStyle(SeenColors.mainColor, 15.sp)!.copyWith(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            height: 0.5),
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                      ),
                                                              ],
                                                            )
                                                          : const SizedBox();
                                                    }),
                                                    SizedBox(width: 5.w),
                                                    GetBuilder<
                                                            IndexQuestionController>(
                                                        builder: (_) {
                                                      return _lessonController
                                                              .ans![
                                                                  _lessonController
                                                                      .mathIndex
                                                                      .value]!
                                                              .isFavorites!
                                                          ? SvgPicture.asset(
                                                              'assets/Qustions/fav.svg',
                                                              height: 10.h,
                                                              colorFilter: ColorFilter.mode(
                                                                  Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  BlendMode
                                                                      .srcIn))
                                                          : const SizedBox();
                                                    })
                                                  ],
                                                ),
                                                GetBuilder<
                                                        IndexQuestionController>(
                                                    builder: (_) {
                                                  return (_lessonController
                                                              .ans![
                                                                  _lessonController
                                                                      .mathIndex
                                                                      .value]!
                                                              .isWrong ??
                                                          false)
                                                      ? _lessonController
                                                                  .ans![_lessonController
                                                                      .mathIndex
                                                                      .value]!
                                                                  .nextDate ==
                                                              null
                                                          ? SizedBox()
                                                          : DateTime.parse(_lessonController
                                                                          .ans![_lessonController
                                                                              .mathIndex
                                                                              .value]!
                                                                          .nextDate!)
                                                                      .difference(
                                                                          DateTime
                                                                              .now())
                                                                      .inDays <
                                                                  0
                                                              ? SizedBox()
                                                              : Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              8.0.w),
                                                                  child: Text(
                                                                    '${DateTime.parse(_lessonController.ans![_lessonController.mathIndex.value]!.nextDate!).difference(DateTime.now()).inDays}D',
                                                                    style: ownStyle(SeenColors.mainColor, 15.sp)!.copyWith(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        height:
                                                                            0.5),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                  ),
                                                                )
                                                      : SizedBox();
                                                }),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ));
                            }),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomizedButton(
                                  codeBack: true,
                                  fun: () {
                                    checkAnswerController.solvedCheck = false;
                                    if (_lessonController.mathIndex.value > 0) {
                                      // if (progresscontroller.progress !=
                                      //     progresscontroller.x) {
                                      //   progresscontroller.decreaseProgress();
                                      // }
                                      resetValue();
                                      _lessonController.mathIndex.value--;
                                    }
                                  },
                                  color: Theme.of(context).cardColor,
                                  isCode: false,
                                  width: 100.w,
                                  txt: 'السابق',
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                CustomizedButton(
                                  codeBack: false,
                                  fun: () async {
                                    int valueBeforeUpdateWrongness =
                                        _lessonController
                                                .ans![_lessonController
                                                    .mathIndex.value]!
                                                .right_times ??
                                            0;
                                    valueBeforeUpdateWrongness++;
                                    if (_lessonController.ans!.isNotEmpty) {
                                      _lessonController.numberOfWrongQA = 0;
                                      _lessonController.numberOfCorrectQA = 0;
                                      // checkAnswerController.update();
                                      checkAnswerController.check = false;
                                      checkAnswerController
                                          .restoreAlreadycheck = false;
                                      checkAnswerController.solvedCheck = true;
                                      if (_lessonController.showHint) {
                                        _lessonController.showHint = false;
                                      }
                                      await Future.forEach(
                                          checkAnswerController.solvedAnswer,
                                          (element) async {
                                        if (!element['correctness']) {
                                          await updateWrongness(
                                              element['questionId'], 1);

                                          _lessonController.numberOfWrongQA++;
                                        } else {
                                          await updateWrongness(
                                              element['questionId'], 0);
                                          _lessonController.numberOfCorrectQA++;
                                        }

                                        if (!checkAnswerController
                                            .doubleCheckedAnswer
                                            .contains(element)) {
                                          checkAnswerController
                                              .doubleCheckedAnswer
                                              .add(element);
                                        }

                                        await insertUserAnswer(
                                            element['choice'],
                                            element[correctnessColumn]);

                                        await indexQuestionController
                                            .saveSession(
                                                subjectid: element[csSubjectID],
                                                isAllFav:
                                                    _lessonController.isAllFave,
                                                isAllWrong: _lessonController
                                                    .isAllWrong,
                                                isFav: _lessonController.isFave,
                                                isWrong:
                                                    _lessonController.isWrong,
                                                isPrev: _lessonController
                                                    .isPreiviosQuestios,
                                                prevId:
                                                    element[cspreviousIdCol],
                                                subid: element['subid'],
                                                choice: element['choice']
                                                    .toString(),
                                                qid: element['questionId'],
                                                index: element['index'],
                                                a_index: element['a_index'],
                                                correctness:
                                                    element[correctnessColumn],
                                                a_content:
                                                    element['answerContent'],
                                                correct_index:
                                                    element['correctIndex'],
                                                alreadyChecke: true,
                                                isRandom: _lessonController
                                                    .isRandomize);
                                      });

                                      var tempWronInfo =
                                          await getQuestionRightSolvedTimesAndNextTimes(
                                              _lessonController
                                                  .ans![_lessonController
                                                      .mathIndex.value]!
                                                  .id!);
                                      if (tempWronInfo == null) {
                                        _lessonController
                                            .ans![_lessonController
                                                .mathIndex.value]!
                                            .right_times = 0;
                                        _lessonController
                                            .ans![_lessonController
                                                .mathIndex.value]!
                                            .isWrong = false;
                                      } else {
                                        _lessonController
                                                .ans![_lessonController
                                                    .mathIndex.value]!
                                                .right_times =
                                            tempWronInfo['right_times'] ?? 0;
                                        _lessonController
                                                .ans![_lessonController
                                                    .mathIndex.value]!
                                                .nextDate =
                                            tempWronInfo[nextShowDate];
                                      }
                                      print('############00');
                                      print(tempWronInfo);

                                      if (valueBeforeUpdateWrongness == 5) {
                                        print('######vcat######00');
                                        _lessonController
                                            .ans![_lessonController
                                                .mathIndex.value]!
                                            .isWrong = false;
                                      } else {
                                        _lessonController
                                            .ans![_lessonController
                                                .mathIndex.value]!
                                            .isWrong = true;
                                      }
                                      checkAnswerController.update();
                                      _lessonController.update();
                                    }
                                  },
                                  color: Theme.of(context).cardColor,
                                  isCode: false,
                                  width: 100.w,
                                  txt: 'تحقق',
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                CustomizedButton(
                                  codeBack: true,
                                  fun: () {
                                    checkAnswerController.solvedCheck = false;
                                    if (_lessonController.mathIndex.value <
                                        _lessonController.ans!.length - 1) {
                                      _lessonController.mathIndex.value++;
                                      resetValue();
                                      // progresscontroller.increaseProgress();
                                    }
                                  },
                                  color: Theme.of(context).cardColor,
                                  isCode: false,
                                  width: 100.w,
                                  txt: 'التالي',
                                ),
                              ],
                            ),
                          ),
                        ])
                  : Directionality(
                      textDirection:
                          (subjectController.questionsLanguage!.value == "عربي")
                              ? TextDirection.ltr
                              : TextDirection.ltr,
                      child: const SkeletonList());
            });
          }),
        ));
  }
}
