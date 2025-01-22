import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:latext/latext.dart';

import 'package:seen/Features/Randomize/controllers/RandomizeController.dart';
import 'package:seen/core/functions/QuestionFunction.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/constants/TextStyles.dart';

import '../../../core/functions/localDataFunctions/CurrentSession.dart';
import '../../../core/functions/localDataFunctions/userAnswerFunction.dart';

import '../../../shared/CustomizedButton.dart';

import '../../../shared/model/LocalDataSource.dart/LocalData.dart';
import '../../Sections/controller/indexQuestionController/indexQuestionsController.dart';
import '../Controller/CheckAnswerController/checkAnswerController.dart';
import '../Controller/LessonController.dart';
import '../Controller/ProgressController.dart';
import '../Controller/SearchController.dart';
import '../Controller/TimerController.dart';
import '../Function/confirmDeletingAllAnswer.dart';

class QuestionToolBar extends StatelessWidget {
  QuestionToolBar({
    super.key,
    this.isMath,
    required LessonController lessonController,
    required this.subID,
  }) : _lessonController = lessonController;
  final int subID;
  bool? isMath = false;
  bool tempCheck = false;
  bool tempSolved = false;
  IndexQuestionController indexQuestionController = Get.find();
  TimerController _timerController = Get.put(TimerController());
  final LessonController _lessonController;
  CheckAnswerController checkAnswerController = Get.find();
  RandomizeController randomizeController = Get.find();
  Progresscontroller progresscontroller = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuesSearchController>(builder: (searchController) {
      return searchController.active
          ? Container(
              margin: EdgeInsets.only(top: 3.w),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: SeenColors.iconColor.withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 1)
              ]),
              child: TextField(
                style: ownStyle(SeenColors.iconColor, 15.sp),
                decoration: InputDecoration(
                  constraints: BoxConstraints(maxHeight: 40.w, maxWidth: 340.w),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 3.w, horizontal: 6.w),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: SeenColors.iconColor,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.cancel_outlined,
                      color: SeenColors.iconColor,
                    ),
                    onPressed: () {
                      _lessonController.numberOfWrongQA = 0;
                      _lessonController.numberOfCorrectQA = 0;
                      _lessonController.resetQuestions();
                      checkAnswerController.check = false;
                      checkAnswerController.solvedCheck = false;
                      searchController.changeActivationState();
                      searchController.update();
                      _lessonController.numberOfWrongQA = 0;
                      _lessonController.numberOfCorrectQA = 0;
                    },
                  ),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10.r)),
                  hintText: 'بحث',
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10.r)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10.r)),
                ),
                onChanged: (value) {
                  searchController.runFilter(value);
                  _lessonController.update();
                },
              ),
            )
          : Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              width: double.infinity,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 100.w,
                      padding: EdgeInsets.all(5.w),
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(18.r)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Obx(() {
                              return SizedBox(
                                width: _lessonController
                                            .numberOfRemainingQA.value >=
                                        100
                                    ? 18.w
                                    : _lessonController
                                                .numberOfRemainingQA.value <
                                            10
                                        ? 8.w
                                        : 14.w,
                                child: FittedBox(
                                  child: Text(
                                      _lessonController
                                          .numberOfRemainingQA.value
                                          .toString(),
                                      maxLines: 1,
                                      style: ownStyle(
                                          SeenColors.iconColor, 12.sp)),
                                ),
                              );
                            }),
                            GetBuilder<CheckAnswerController>(builder: (check) {
                              return SizedBox(
                                child: Row(children: [
                                  Container(
                                      alignment: Alignment.center,
                                      width: 25.w,
                                      padding: EdgeInsets.all(3.w),
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.horizontal(
                                              right: Radius.circular(15.r))),
                                      child: Text(
                                          _lessonController.numberOfCorrectQA
                                              .toString(),
                                          style: ownStyle(
                                              Theme.of(context).cardColor,
                                              12.sp))),
                                  Container(
                                      alignment: Alignment.center,
                                      width: 25.w,
                                      padding: EdgeInsets.all(3.w),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.horizontal(
                                              left: Radius.circular(15.r))),
                                      child: Text(
                                          _lessonController.numberOfWrongQA
                                              .toString(),
                                          style: ownStyle(
                                              Theme.of(context).cardColor,
                                              12.sp)))
                                ]),
                              );
                            }),
                            Obx(() {
                              return SizedBox(
                                width: _lessonController.numberOfQA.value >= 100
                                    ? 18.w
                                    : _lessonController.numberOfQA.value < 10
                                        ? 8.w
                                        : 14.w,
                                child: FittedBox(
                                  child: Text(
                                      _lessonController.numberOfQA.value
                                          .toString(),
                                      style: ownStyle(
                                          SeenColors.iconColor, 12.sp)),
                                ),
                              );
                            })
                          ]),
                    ),
                    Row(
                      children: [
                        !isMath!
                            ? InkWell(
                                onLongPress: () {
                                  confirmDeleteingAllAnswer(
                                      subID,
                                      indexQuestionController,
                                      checkAnswerController,
                                      _lessonController,
                                      randomizeController,
                                      context);
                                  if (_lessonController.showHint) {
                                    _lessonController.showHint = false;
                                  }
                                },
                                borderRadius: BorderRadius.circular(15.r),
                                onTap: () async {
                                  _lessonController.numberOfWrongQA = 0;
                                  _lessonController.numberOfCorrectQA = 0;
                                  checkAnswerController.update();
                                  checkAnswerController.check = false;
                                  checkAnswerController.restoreAlreadycheck =
                                      false;
                                  checkAnswerController.solvedCheck = true;
                                  if (_lessonController.showHint) {
                                    _lessonController.showHint = false;
                                  }

                                  await Future.forEach(
                                    checkAnswerController.solvedAnswer,
                                    (element) async {
                                      if (element[correctnessColumn]) {
                                        await updateWrongness(
                                            element['questionId'], 0);
                                        int valueBeforeUpdateWrongness =
                                            element[rightTimes] ?? 0;
                                        valueBeforeUpdateWrongness++;
                                        var tempWronInfo =
                                            await getQuestionRightSolvedTimesAndNextTimes(
                                                element['questionId']);
                                        if (tempWronInfo == null) {
                                          print('#####1#######');
                                          element[rightTimes] = 0;
                                          element['is_wrong'] = false;
                                        } else {
                                          print('#####2#######');
                                          element[rightTimes] =
                                              tempWronInfo['right_times'] ?? 0;
                                          element[nextShowDate] =
                                              tempWronInfo[nextShowDate];
                                        }
                                        // print('###'
                                        //     '3'
                                        //     '###');

                                        print(tempWronInfo);

                                        if (valueBeforeUpdateWrongness == 5) {
                                          print('######vcat######00');
                                          element['is_wrong'] = false;
                                        } else {
                                          if (element['is_wrong'] ?? false) {
                                            element['is_wrong'] = true;
                                          } else {
                                            element['is_wrong'] = false;
                                          }
                                        }
                                      } else {
                                        await updateWrongness(
                                            element['questionId'], 1);
                                        var tempWronInfo =
                                            await getQuestionRightSolvedTimesAndNextTimes(
                                                element['questionId']);
                                        if (tempWronInfo == null) {
                                          print('#####1#22######');
                                          element[rightTimes] = 0;
                                          element['is_wrong'] = true;
                                        } else {
                                          print('#####2#22### ###');
                                          element[rightTimes] =
                                              tempWronInfo['right_times'] ?? 0;
                                          element[nextShowDate] =
                                              tempWronInfo[nextShowDate];
                                        }
                                      }

                                      if (!checkAnswerController
                                          .doubleCheckedAnswer
                                          .contains(element)) {
                                        checkAnswerController
                                            .doubleCheckedAnswer
                                            .add(element);
                                      }

                                      await insertUserAnswer(element['choice'],
                                          element[correctnessColumn]);

                                      await indexQuestionController.saveSession(
                                          subjectid: element[csSubjectID],
                                          isAllFav: _lessonController.isAllFave,
                                          isAllWrong:
                                              _lessonController.isAllWrong,
                                          isFav: _lessonController.isFave,
                                          isWrong: _lessonController.isWrong,
                                          isPrev: _lessonController
                                              .isPreiviosQuestios,
                                          prevId: element[cspreviousIdCol],
                                          subid: element['subid'],
                                          choice: element['choice'].toString(),
                                          qid: element['questionId'],
                                          index: element['index'],
                                          a_index: element['a_index'],
                                          correctness:
                                              element[correctnessColumn],
                                          a_content: element['answerContent'],
                                          correct_index:
                                              element['correctIndex'],
                                          alreadyChecke: true,
                                          isRandom:
                                              _lessonController.isRandomize);
                                    },
                                  );

                                  _lessonController.update();
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(6.0.w),
                                  child: SvgPicture.asset(
                                      'assets/Qustions/check solved answers .svg'),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  mathQuestionListDialog(
                                      context, searchController);
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(6.0.w),
                                  child: const Icon(
                                    Icons.table_rows_rounded,
                                    color: SeenColors.iconColor,
                                  ),
                                ),
                              ),
                        InkWell(
                          borderRadius: BorderRadius.circular(15.r),
                          onLongPress: () {
                            confirmDeleteingAllAnswer(
                                subID,
                                indexQuestionController,
                                checkAnswerController,
                                _lessonController,
                                randomizeController,
                                context);
                            if (_lessonController.showHint) {
                              _lessonController.showHint = false;
                            }
                            _lessonController.update();
                          },
                          onTap: () async {
                            if (checkAnswerController.check) {
                              _lessonController.showHint =
                                  !_lessonController.showHint;
                            } else {
                              if (!_lessonController.showHint) {
                                _lessonController.numberOfWrongQA = 0;
                                _lessonController.numberOfCorrectQA = 0;
                                checkAnswerController.update();
                                await Future.forEach(
                                    checkAnswerController.solvedAnswer,
                                    (element) async {
                                  if (element[correctnessColumn]) {
                                    await updateWrongness(
                                        element['questionId'], 0);
                                    int valueBeforeUpdateWrongness =
                                        element[rightTimes] ?? 0;
                                    valueBeforeUpdateWrongness++;
                                    var tempWronInfo =
                                        await getQuestionRightSolvedTimesAndNextTimes(
                                            element['questionId']);
                                    if (tempWronInfo == null) {
                                      print('#####1#######');
                                      element[rightTimes] = 0;
                                      element['is_wrong'] = false;
                                    } else {
                                      print('#####2#######');
                                      element[rightTimes] =
                                          tempWronInfo['right_times'] ?? 0;
                                      element[nextShowDate] =
                                          tempWronInfo[nextShowDate];
                                    }
                                    // print('###'
                                    //     '3'
                                    //     '###');

                                    print(tempWronInfo);

                                    if (valueBeforeUpdateWrongness == 5) {
                                      print('######vcat######00');
                                      element['is_wrong'] = false;
                                    } else {
                                      if (element['is_wrong'] ?? false) {
                                        element['is_wrong'] = true;
                                      } else {
                                        element['is_wrong'] = false;
                                      }
                                    }
                                  } else {
                                    await updateWrongness(
                                        element['questionId'], 1);
                                    var tempWronInfo =
                                        await getQuestionRightSolvedTimesAndNextTimes(
                                            element['questionId']);
                                    if (tempWronInfo == null) {
                                      print('#####1#22######');
                                      element[rightTimes] = 0;
                                      element['is_wrong'] = true;
                                    } else {
                                      print('#####2#22### ###');
                                      element[rightTimes] =
                                          tempWronInfo['right_times'] ?? 0;
                                      element[nextShowDate] =
                                          tempWronInfo[nextShowDate];
                                    }
                                  }

                                  await insertUserAnswer(element['choice'],
                                      element[correctnessColumn]);
                                  await indexQuestionController.saveSession(
                                      subjectid: element[csSubjectID],
                                      isAllFav: _lessonController.isAllFave,
                                      isAllWrong: _lessonController.isAllWrong,
                                      isFav: _lessonController.isFave,
                                      isWrong: _lessonController.isWrong,
                                      isPrev:
                                          _lessonController.isPreiviosQuestios,
                                      prevId: element[cspreviousIdCol],
                                      subid: element['subid'],
                                      choice: element['choice'].toString(),
                                      qid: element['questionId'],
                                      index: element['index'],
                                      a_index: element['a_index'],
                                      correctness: element[correctnessColumn],
                                      a_content: element['answerContent'],
                                      correct_index: element['correctIndex'],
                                      alreadyChecke: true,
                                      isRandom: _lessonController.isRandomize);
                                  if (!checkAnswerController.doubleCheckedAnswer
                                      .contains(element)) {
                                    checkAnswerController.doubleCheckedAnswer
                                        .add(element);
                                  }
                                });

                                checkAnswerController.restoreAlreadycheck =
                                    false;
                                checkAnswerController.solvedCheck = false;
                                checkAnswerController.check = true;
                                _lessonController.showHint = true;
                                _lessonController.update();
                                // checkAnswerController.update();
                              } else {
                                checkAnswerController.restoreAlreadycheck =
                                    false;
                                _lessonController.numberOfWrongQA = 0;
                                _lessonController.numberOfCorrectQA = 0;
                                _lessonController.showHint = false;

                                checkAnswerController.check = false;
                                checkAnswerController.solvedCheck = true;
                                _lessonController.update();
                              }
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0.w),
                            child: SvgPicture.asset(
                              'assets/Qustions/check all answers .svg',
                              colorFilter: ColorFilter.mode(
                                  SeenColors.iconColor, BlendMode.srcIn),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              if (_lessonController.showHint) {
                                _lessonController.showHint = false;
                              }
                              if (checkAnswerController.check) {
                                tempCheck = checkAnswerController.check;
                                checkAnswerController.check = false;
                              }
                              if (checkAnswerController.solvedCheck) {
                                tempSolved = checkAnswerController.check;
                                checkAnswerController.solvedCheck = false;
                              }
                              _lessonController.resetQuestions();
                              searchController.changeActivationState();
                              searchController.update();
                            },
                            icon: const Icon(Icons.search,
                                color: SeenColors.iconColor)),
                        GestureDetector(
                          onLongPress: () {
                            _timerController.resetTimer();
                          },
                          child: IconButton(
                              onPressed: () {
                                HapticFeedback.selectionClick();
                                if (_timerController.reset) {
                                  _timerController.reset = false;
                                  _timerController.restartTimer();
                                } else {
                                  _timerController.reset = true;
                                  _timerController.startTimer();
                                }
                              },
                              icon: const Icon(
                                Icons.timer_sharp,
                                color: SeenColors.iconColor,
                              )),
                        )
                      ],
                    ),
                    Container(
                        alignment: Alignment.center,
                        width: 65.w,
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(15.r)),
                        child: Obx(() {
                          return RichText(
                            text: TextSpan(
                                style: ownStyle(SeenColors.iconColor, 16.sp),
                                children: [
                                  TextSpan(
                                      text: _timerController.seconds.value < 10
                                          ? "0${_timerController.seconds} : "
                                          : "${_timerController.seconds.value} : "),
                                  TextSpan(
                                      text: _timerController.minuts.value < 10
                                          ? "0${_timerController.minuts.value}"
                                          : "${_timerController.minuts.value} "),
                                ]),
                          );
                        }))
                  ]),
            );
    });
  }

  Future<dynamic> mathQuestionListDialog(
      BuildContext context, searchController) {
    return showDialog(
      context: context,
      builder: (context) {
        return MathQuesyionList(
          searchController: searchController,
          isSearchList: false,
          lessonController: _lessonController,
        );
      },
    );
  }
}

class MathQuesyionList extends StatelessWidget {
  const MathQuesyionList({
    required this.isSearchList,
    super.key,
    required LessonController lessonController,
    required this.searchController,
  }) : _lessonController = lessonController;
  final QuesSearchController searchController;
  final LessonController _lessonController;
  final bool isSearchList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            color: Get.theme.cardColor,
            borderRadius: BorderRadius.circular(30.r)),
        margin: EdgeInsets.symmetric(
            horizontal: 10.w, vertical: isSearchList ? 10 : 50.h),
        child: Column(
          children: [
            isSearchList
                ? SizedBox()
                : Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.h),
                    child: Text(
                      'جميع الأسئلة',
                      style: ownStyle(
                        context.theme.primaryColor,
                        25.sp,
                      )!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
            SizedBox(
              height: isSearchList ? 520 : 450.h,
              width: 400.w,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _lessonController.ans!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: SeenColors.iconColor))),
                      child: ListTile(
                        onTap: () {
                          if (isSearchList) {
                            searchController.active = false;
                            _lessonController.mathIndex.value = index;
                            print(index);
                          } else {
                            _lessonController.mathIndex.value = index;
                            Get.back();
                          }
                          _lessonController.update();
                        },
                        title: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Column(
                            children: [
                              LaTexT(
                                  laTeXCode: Text(
                                textDirection: TextDirection.rtl,
                                "${index + 1} - " +
                                    _lessonController
                                        .ans![index]!.questionContent!,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style:
                                    ownStyle(context.theme.primaryColor, 13.sp)!
                                        .copyWith(fontWeight: FontWeight.w400),
                              ))
                              // Text(
                              //   + normalText,
                              //   style: ownStyle(
                              //       context.theme.primaryColor, 15.sp),
                              // ),
                              // for (int t = 0; t < tex.length; t++)
                              //   Container(
                              //     margin: EdgeInsets.symmetric(
                              //         vertical: 5.h, horizontal: 10.w),
                              //     decoration: BoxDecoration(
                              //         borderRadius:
                              //             BorderRadius.circular(15.r)),
                              //     // child: FittedBox(
                              //     //   child: Math.tex(tex[t],
                              //     //       textStyle: ownStyle(
                              //     //           context.theme.primaryColor,
                              //     //           28.sp),
                              //     //       mathStyle: MathStyle.textCramped),
                              //     // )
                              //   ),
                            ],
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
