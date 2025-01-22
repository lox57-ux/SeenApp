// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_langdetect/flutter_langdetect.dart' as langdetect;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:seen/Features/Sections/controller/subjectController/SubjectController.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:seen/core/constants/TextStyles.dart';
import 'package:seen/core/functions/localDataFunctions/CurrentSession.dart';

import 'package:seen/core/settings/widget/SkeletonList.dart';

import '../../../core/controller/QuestionsController/ExamsLogController.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/functions/QuestionFunction.dart';

import '../../Sections/controller/indexQuestionController/indexQuestionsController.dart';
import '../../introPages/Widgets/IntroPageButton.dart';
import '../Controller/CheckAnswerController/checkAnswerController.dart';
import '../Controller/LessonController.dart';
import '../Controller/SearchController.dart';
import '../model/data/QuestionsDataSource.dart';
import '../widgets/QuestionToolBar.dart';
import '../widgets/QuestionWidget.dart';
import '../widgets/englishQuestions.dart';

class Questionss extends StatelessWidget {
  Questionss({
    super.key,
  });
  static const String routeName = '/Questions';

  var arg = Get.arguments;
  LessonController _lessonController = Get.find();
  QuestionDataSource questionDataSource = QuestionDataSource();
  SubjectController subjectController = Get.find();
  IndexQuestionController indexQuestionController = Get.find();
  QuesSearchController searchController = Get.put(QuesSearchController());
  CheckAnswerController checkAnswerController = Get.find();
  ExamsLogController examsLogController = Get.put(ExamsLogController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_outlined,
              color: Theme.of(context).primaryColor,
              size: 25.sp,
            ),
            onPressed: () async {
              checkAnswerController.check = false;
              checkAnswerController.solvedCheck = false;
              _lessonController.mathIndex.value = 0;
              checkAnswerController.restoreAlreadycheck = false;
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
              subjectController.update();
            },
          ),
          titleSpacing: 0,
          title: InkWell(
            highlightColor: Colors.transparent,
            onDoubleTap: () {
              indexQuestionController.index = 0;
              indexQuestionController.scrollToIndex(sc: 0);
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
            checkAnswerController.check = false;
            checkAnswerController.solvedCheck = false;
            checkAnswerController.restoreAlreadycheck = false;
            if (_lessonController.isRandomize) {
              if (await getRandomizeSessions() != null &&
                  (await getRandomizeSessions())!.isNotEmpty) {
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
                                '  هل تريد متابعة حل هذا الاختبار لاحقاً',
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
            subjectController.update();
            return false;
          },
          child: Obx(() {
            return !_lessonController.loading.value
                ? GetBuilder<LessonController>(builder: (outer) {
                    // checkAnswerController.check = false;
                    // checkAnswerController.solvedCheck = false;
                    //    checkAnswerController.setAnlyseForQuestion();
                    // indexQuestionController.scrollToIndex();

                    if (checkAnswerController.check) {
                      if (checkAnswerController.solvedAnswer.isNotEmpty) {
                        for (int element = 0;
                            element < _lessonController.ans!.length;
                            element++) {
                          if (element >=
                              checkAnswerController.solvedAnswer.length) {
                            // _lessonController.numberOfWrongQA++;
                          } else {
                            if (!checkAnswerController.solvedAnswer[element]
                                ['correctness']) {
//updateWrongness(
//checkAnswerController.solvedAnswer[element]
//['questionId'],
//1);
                              _lessonController.numberOfWrongQA++;
                            } else {
                              // updateWrongness(
                              //     checkAnswerController.solvedAnswer[element]
                              //         ['questionId'],
                              //     0);
                              _lessonController.numberOfCorrectQA++;
                            }
                          }
                        }
                      } else {
                        // _lessonController.numberOfWrongQA =
                        //     _lessonController.numberOfQA.value;
                      }
                    }

                    if (checkAnswerController.restoreAlreadycheck) {
                      if (checkAnswerController
                          .doubleCheckedAnswer.isNotEmpty) {
                        _lessonController.numberOfWrongQA = 0;
                        _lessonController.numberOfCorrectQA = 0;
                        for (int element = 0;
                            element <
                                checkAnswerController
                                    .doubleCheckedAnswer!.length;
                            element++) {
                          if (!checkAnswerController
                              .doubleCheckedAnswer[element]['correctness']) {
                            _lessonController.numberOfWrongQA++;
                          } else {
                            _lessonController.numberOfCorrectQA++;
                          }
                        }
                      }
                    }

                    if (checkAnswerController.solvedCheck) {
                      if (checkAnswerController.solvedAnswer.isNotEmpty) {
                        _lessonController.numberOfWrongQA = 0;
                        _lessonController.numberOfCorrectQA = 0;
                        for (var element
                            in checkAnswerController.solvedAnswer) {
                          if (!element['correctness']) {
                            // updateWrongness(element['questionId'], 1);

                            _lessonController.numberOfWrongQA++;
                          } else {
                            // updateWrongness(element['questionId'], 0);

                            _lessonController.numberOfCorrectQA++;
                          }
                        }
                      }
                    }
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      if (!_lessonController.loading.value) {
                        indexQuestionController.scrollToIndex();
                        // _lessonController.update();
                      }
                    });

                    return Column(
                      children: [
                        QuestionToolBar(
                            isMath: false,
                            lessonController: _lessonController,
                            subID: arg['subID'] ?? 0),
                        SizedBox(
                          height: 10.w,
                        ),
                        Expanded(
                          flex: 10,
                          child: Container(
                            height: 540.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Get.theme.cardColor,
                                borderRadius: BorderRadius.circular(10.r)),
                            margin: EdgeInsets.symmetric(horizontal: 10.w),
                            padding: EdgeInsets.all(8.w),
                            child: (_lessonController.ans == null ||
                                    _lessonController.ans!.isEmpty)
                                ? Center(
                                    child: Text(
                                    'لا يوجد أسئلة',
                                    style: ownStyle(
                                            Theme.of(context).primaryColor,
                                            18.sp)!
                                        .copyWith(fontWeight: FontWeight.w300),
                                  ))
                                : ScrollablePositionedList.builder(
                                    itemScrollController:
                                        indexQuestionController
                                            .itemScrollController,
                                    itemCount: _lessonController.ans == null
                                        ? 0
                                        : _lessonController.ans!.length,
                                    itemBuilder: (context, index) {
                                      // print(_lessonController.ans![index]!.url);
                                      if (_lessonController.ans!.isNotEmpty) {
                                        if (_lessonController.resetGroup) {
                                          for (var x
                                              in _lessonController.ans!) {
                                            x!.groupValue = x.id! + 50001;
                                          }
                                          _lessonController.resetGroup = false;
                                        }
                                        return QuestionWidget(
                                          preID: arg['prev_id'],
                                          languages: subjectController
                                              .questionsLanguage!.value,
                                          subject_id: arg['subjectID'],
                                          sub_id: arg['subID'],
                                          questionAnswerModel:
                                              _lessonController.ans![index]!,
                                          selectGroup: _lessonController
                                              .ans![index]!.groupValue!,
                                          index: index,
                                          questionId: _lessonController
                                              .ans![index]!.id!,
                                          answers: _lessonController
                                              .ans![index]!.answer!,
                                        );
                                        // : EnglishQuestion(
                                        //     subject_id: arg['subjectID'],
                                        //     sub_id: arg['subID'],
                                        //     questionAnswerModel:
                                        //         _lessonController.ans![index]!,
                                        //     selectGroup: _lessonController
                                        //         .ans![index]!.groupValue!,
                                        //     index: index,
                                        //     questionId: _lessonController
                                        //         .ans![index]!.id!,
                                        //     answers: _lessonController
                                        //         .ans![index]!.answer!,
                                        //   );
                                      } else if (_lessonController.ans ==
                                              null ||
                                          _lessonController.ans!.isEmpty) {
                                        return Center(
                                            child: Text(
                                          'لا يوجد أسئلة',
                                          style: ownStyle(
                                                  Theme.of(context)
                                                      .primaryColor,
                                                  18.sp)!
                                              .copyWith(
                                                  fontWeight: FontWeight.w300),
                                        ));
                                      } else {
                                        return Center(
                                            child: Text(
                                          'لا يوجد أسئلة',
                                          style: ownStyle(
                                                  Theme.of(context)
                                                      .primaryColor,
                                                  18.sp)!
                                              .copyWith(
                                                  fontWeight: FontWeight.w300),
                                        ));
                                      }
                                    }),
                          ),
                        )
                      ],
                    );
                  })
                : Directionality(
                    textDirection:
                        (subjectController.questionsLanguage!.value == "عربي")
                            ? TextDirection.ltr
                            : TextDirection.ltr,
                    child: const SkeletonList());
          }),
        ));
  }
}
