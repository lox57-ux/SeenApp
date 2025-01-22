import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:seen/Features/Randomize/controllers/RandomizeController.dart';
import 'package:seen/Features/Sections/controller/subjectController/SubSubjectController.dart';
import 'package:seen/Features/Sections/controller/subjectController/SubjectController.dart';
import 'package:seen/core/constants/Colors.dart';
import 'package:seen/core/constants/TextStyles.dart';

import 'package:seen/Features/questions/screens/MathQuestionsScreen.dart';

import '../../questions/Controller/LessonController.dart';
import '../../questions/model/data/QuestionsDataSource.dart';
import '../controller/subjectController/CustomOptionController.dart';
import '../../../core/functions/QuestionFunction.dart';
import '../../../core/functions/localDataFunctions/indexedSubjectsFunction.dart';

import '../../questions/screens/questions.dart';
import '../../../shared/InvokeWaitingDialog.dart';
import '../model/classes/SubSubjects.dart';

class SectionsList extends StatelessWidget {
  SectionsList(
      {super.key,
      required this.subjectid,
      required this.isLockedSubject,
      required this.tabController});
  final int subjectid;
  final TabController tabController;
  final bool isLockedSubject;
  SubSubjectController subjectController = Get.find();
  LessonController lessonController = Get.put(LessonController());
  RandomizeController randomizeController = Get.put(RandomizeController());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx < 0) {
          Get.nestedKey(1)!.currentState!.pop();
        }
      },
      child: GetBuilder<SubjectController>(builder: (contr) {
        return Card(
          shadowColor: Get.theme.cardColor,
          elevation: 0,
          margin: EdgeInsets.zero,
          surfaceTintColor: Get.theme.cardColor,
          child: SizedBox(
            width: double.infinity,
            child: FutureBuilder(
              future: subjectController.getFathersSubject(subjectid),
              builder: (context, snapshot) => snapshot.hasData
                  ? ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ExpansionTile(
                              onExpansionChanged: (value) async {
                                // await deleteAllIndexedSubjects();
                                SubSubject? sub = subjectController.subSubjects!
                                    .firstWhereOrNull((element) =>
                                        (element!.fatherId ==
                                            snapshot.data![index]!.id) &&
                                        element.isUnlocked!);

                                if (sub != null) {
                                  if (!sub.has_data!) {
                                    if (!snapshot.data![index]!.has_data!) {
                                      InvokeWaitingDialog(context);
                                      await QuestionDataSource.instance
                                          .getAllUserQuestionsForSubSubject(
                                              snapshot.data![index]!.id,
                                              snapshot.data![index]!.subjectId!,
                                              true);
                                      snapshot.data![index]!.has_data = true;
                                      contr.update();
                                      Get.back();
                                    }
                                  }
                                  subjectController.expand(
                                      value, snapshot.data![index]!);
                                } else {
                                  Get.nestedKey(1)!.currentState!.pushNamed(
                                        '/notAmember',
                                      );
                                }
                              },
                              childrenPadding: EdgeInsets.symmetric(
                                  vertical: 10.w, horizontal: 0),
                              initiallyExpanded:
                                  snapshot.data![index]!.expanded!,
                              shape: const Border(),
                              collapsedShape: const Border(),
                              title: Text(
                                  snapshot.data![index]!.subSubjectName ?? '',
                                  style:
                                      ownStyle(Get.theme.primaryColor, 17.sp)),
                              subtitle: Text(
                                  snapshot.data![index]!.subSubjectNotes ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  style: ownStyle(SeenColors.iconColor, 13.sp)!
                                      .copyWith(fontWeight: FontWeight.w300)),
                              trailing: SizedBox(
                                width: 65.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                        width: 35.w,
                                        height: 45.w,
                                        child:
                                            GetBuilder<CustomOptionController>(
                                                builder: (customOption) {
                                          return CircleAvatar(
                                            backgroundColor: snapshot
                                                    .data![index]!.isUnlocked!
                                                ? SeenColors.mainColor
                                                : SeenColors.iconColor,
                                            child:
                                                // openSubject!
                                                //     ? hasData!
                                                snapshot.data![index]!
                                                        .isUnlocked!
                                                    ? snapshot.data![index]!
                                                                .has_data ??
                                                            false
                                                        ? IconButton(
                                                            color: Colors.white,
                                                            onPressed:
                                                                () async {
                                                              InvokeWaitingDialog(
                                                                  context);
                                                              await QuestionDataSource
                                                                  .instance
                                                                  .getAllUserQuestionsForSubSubject(
                                                                      snapshot
                                                                          .data![
                                                                              index]!
                                                                          .id,
                                                                      snapshot
                                                                          .data![
                                                                              index]!
                                                                          .subjectId!,
                                                                      true);

                                                              // await WrongAnswerDataSource
                                                              //     .instace
                                                              //     .getWrongAnswersForSubject(
                                                              //         snapshot
                                                              //             .data![
                                                              //                 index]!
                                                              //             .id!);
                                                              // await BackgroundDataSource
                                                              //     .instance
                                                              //     .getSubjectFavorites(
                                                              //         snapshot
                                                              //             .data![
                                                              //                 index]!
                                                              //             .id!);

                                                              snapshot
                                                                  .data![index]!
                                                                  .has_data = true;
                                                              contr.update();
                                                              Get.back();
                                                            },
                                                            icon: Icon(
                                                                Icons.refresh,
                                                                size: 17.w))
                                                        : IconButton(
                                                            color: Colors.white,
                                                            onPressed:
                                                                () async {
                                                              InvokeWaitingDialog(
                                                                  context);
                                                              await QuestionDataSource
                                                                  .instance
                                                                  .getAllUserQuestionsForSubSubject(
                                                                      snapshot
                                                                          .data![
                                                                              index]!
                                                                          .id,
                                                                      snapshot
                                                                          .data![
                                                                              index]!
                                                                          .subjectId!,
                                                                      true);
                                                              // await WrongAnswerDataSource
                                                              //     .instace
                                                              //     .getWrongAnswersForSubject(
                                                              //         snapshot
                                                              //             .data![
                                                              //                 index]!
                                                              //             .id!);
                                                              // await BackgroundDataSource
                                                              //     .instance
                                                              //     .getSubjectFavorites(
                                                              //         snapshot
                                                              //             .data![
                                                              //                 index]!
                                                              //             .id!);
                                                              snapshot
                                                                  .data![index]!
                                                                  .has_data = true;
                                                              contr.update();
                                                              Get.back();
                                                            },
                                                            icon: Icon(
                                                                Icons.download,
                                                                size: 17.w))
                                                    : Icon(Icons.lock,
                                                        color: Colors.white,
                                                        size: 17.w),
                                          );
                                        })),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    SizedBox(
                                      width: 20.w,
                                      height: 30.w,
                                      child: GetBuilder<SubSubjectController>(
                                          builder: (controller) {
                                        return SizedBox(
                                            width: 20.w,
                                            height: 30.w,
                                            child: RotatedBox(
                                              quarterTurns: snapshot
                                                      .data![index]!.expanded!
                                                  ? 1
                                                  : 2,
                                              child: Icon(
                                                Icons.arrow_back_ios,
                                                color: Get.theme.primaryColor,
                                                grade: 50,
                                                size: 25.sp,
                                                opticalSize: 6,
                                                weight: 500,
                                              ),
                                            ));
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                              children: !snapshot.data![index]!.isUnlocked!
                                  ? subjectController.subSubjects!
                                      .where((element) =>
                                          (element!.fatherId ==
                                              snapshot.data![index]!.id) &&
                                          element.isUnlocked!)
                                      .map((e) => SubSubjectWiget(
                                          lessonController: lessonController,
                                          subjectid: subjectid,
                                          e: e!,
                                          subjectController: subjectController))
                                      .toList()
                                  : subjectController.subSubjects!
                                      .where((element) =>
                                          element!.fatherId ==
                                          snapshot.data![index]!.id)
                                      .map((e) => SubSubjectWiget(
                                          lessonController: lessonController,
                                          subjectid: subjectid,
                                          e: e!,
                                          subjectController: subjectController))
                                      .toList(),
                            ),
                            Divider(
                              height: 5,
                              color: SeenColors.iconColor,
                              endIndent: 20.w,
                              indent: 9.w,
                            )
                          ],
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(
                      color: Get.theme.primaryColor,
                    )),
            ),
          ),
        );
      }),
    );
  }
}

class SubSubjectWiget extends StatelessWidget {
  SubSubjectWiget({
    super.key,
    required this.lessonController,
    required this.subjectid,
    required this.subjectController,
    required this.e,
  });

  final LessonController lessonController;
  final int subjectid;
  CustomOptionController customOptionController = Get.find();
  final SubSubjectController subjectController;
  final SubSubject e;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // print(await getQuestionWithAnswers(e.id!));
        // print(e.isUnlocked);
        if (e.isUnlocked!) {
          if (e.has_data ?? false) {
            print('####0####');
            lessonController.isShuffleAnswers.value = false;
            lessonController.loading.value = true;
            lessonController.resetSectionDivider();
            lessonController.lesson.value = e.subSubjectName ?? '';

            if (e!.isLatex!) {
              print('####1####');
              Get.toNamed(
                MathQuestionScreen.routeName,
                arguments: {"subjectID": subjectid, "subID": e!.id},
              );
            } else {
              print('####2####');
              Get.toNamed(
                Questionss.routeName,
                arguments: {"subjectID": subjectid, "subID": e!.id},
              );
            }

            await lessonController.setQuestionList(
                null, e!.id, false, false, false, e.isLatex ?? false);
          } else {
            print('####5####');
            InvokeWaitingDialog(context);
            await QuestionDataSource.instance
                .getAllUserQuestionsForSubSubject(e!.id, subjectid!, false);
            // await WrongAnswerDataSource
            //     .instace
            //     .getWrongAnswersForSubject(
            //         snapshot
            //             .data![
            //                 index]!
            //             .id!);
            // await BackgroundDataSource
            //     .instance
            //     .getSubjectFavorites(
            //         snapshot
            //             .data![
            //                 index]!
            //             .id!);
            e.has_data = true;
            customOptionController.update();
            subjectController.update();
            Get.back();
          }
        } else {
          print('object4');
          Get.nestedKey(1)!.currentState!.pushNamed(
                '/notAmember',
              );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 22.0.w),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                  flex: 3,
                  child: Text(
                    e!.subSubjectName ?? '',
                    style: ownStyle(SeenColors.iconColor, 18.sp),
                  )),
              // SizedBox(
              //     width: 32.w,
              //     height: 32.w,
              //     child: GetBuilder<CustomOptionController>(builder: (_) {
              //       return CircleAvatar(
              //         backgroundColor: SeenColors.iconColor,
              //         child:
              //             // openSubject!
              //             //     ? hasData!
              //             e.isUnlocked!
              //                 ? e!.has_data ?? false
              //                     ? IconButton(
              //                         color: Colors.white,
              //                         onPressed: () async {
              //                           InvokeWaitingDialog(context);
              //                           await QuestionDataSource.instance
              //                               .getAllUserQuestionsForSubSubject(
              //                                   e!.id, subjectid, false);
              //                           // await WrongAnswerDataSource
              //                           //     .instace
              //                           //     .getWrongAnswersForSubject(
              //                           //         snapshot
              //                           //             .data![
              //                           //                 index]!
              //                           //             .id!);
              //                           // await BackgroundDataSource
              //                           //     .instance
              //                           //     .getSubjectFavorites(
              //                           //         snapshot
              //                           //             .data![
              //                           //                 index]!
              //                           //             .id!);
              //                           e.has_data = true;
              //                           customOptionController.update();
              //                           subjectController.update();
              //                           Get.back();
              //                         },
              //                         icon: Icon(Icons.refresh, size: 16.w))
              //                     : IconButton(
              //                         color: Colors.white,
              //                         onPressed: () async {
              //                           InvokeWaitingDialog(context);
              //                           await QuestionDataSource.instance
              //                               .getAllUserQuestionsForSubSubject(
              //                                   e!.id, subjectid, false);
              //                           // await WrongAnswerDataSource
              //                           //     .instace
              //                           //     .getWrongAnswersForSubject(
              //                           //         snapshot
              //                           //             .data![
              //                           //                 index]!
              //                           //             .id!);
              //                           // await BackgroundDataSource
              //                           //     .instance
              //                           //     .getSubjectFavorites(
              //                           //         snapshot
              //                           //             .data![
              //                           //                 index]!
              //                           //             .id!);
              //                           customOptionController.update();
              //                           subjectController.update();
              //                           Get.back();
              //                         },
              //                         icon: Icon(Icons.download, size: 16.w))
              //                 : Icon(Icons.lock,
              //                     color: Colors.white, size: 20.w),
              //       );
              //     })),

              Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 18.sp,
                    weight: 1000,
                    color: SeenColors.iconColor,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
//  CustomOption(
//                 subtTtle: dummy_subject[index].subtitle,
//                 txt: dummy_subject[index].title,
//                 func: () {
//                   Get.to(() => ChooseSections(),
//                       arguments: dummy_subject[index]);
//                 },
//                 icon: Icon(Icons.arrow_back_ios_new)),