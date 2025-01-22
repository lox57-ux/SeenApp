import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:seen/Features/Sections/controller/subjectController/SubSubjectController.dart';
import 'package:seen/Features/Sections/controller/subjectController/SubjectController.dart';
import 'package:seen/core/constants/Colors.dart';
import 'package:seen/core/constants/TextStyles.dart';

import 'package:seen/core/settings/widget/custom_option.dart';

import '../../questions/Controller/LessonController.dart';
import '../../questions/screens/MathQuestionsScreen.dart';
import '../../questions/screens/questions.dart';

class FavoriteList extends StatelessWidget {
  FavoriteList(
      {super.key,
      required this.s_id,
      required this.subjectName,
      required this.tabController});
  final int s_id;
  final TabController tabController;
  final String? subjectName;
  LessonController _lessonController = Get.find();
  SubSubjectController subjectController = Get.put(SubSubjectController());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        tabController.animateTo(0);
        return false;
      },
      child: GetBuilder<SubjectController>(builder: (_) {
        return Card(
          shadowColor: Get.theme.cardColor,
          elevation: 0,
          margin: EdgeInsets.zero,
          surfaceTintColor: Get.theme.cardColor,
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                CustomOption(
                    txt: 'جميع الأسئلة المفضلة',
                    func: () async {
                      _lessonController.isShuffleAnswers.value = false;
                      _lessonController.loading.value = true;
                      _lessonController.lesson.value = 'جميع الأسئلة المفضلة';
                      if (subjectName == 'رياضيات') {
                        Get.toNamed(
                          MathQuestionScreen.routeName,
                          arguments: {"subjectID": s_id, "subID": null},
                        );
                      } else {
                        Get.toNamed(
                          Questionss.routeName,
                          arguments: {"subjectID": s_id, "subID": null},
                        );
                      }
                      // Get.toNamed(
                      //   Questionss.routeName,
                      //   arguments: {"subjectID": s_id, "subID": null},
                      // );
                      _lessonController.resetSectionDivider();

                      await _lessonController.setQuestionList(s_id, null, false,
                          false, true, subjectName == 'رياضيات');
                    },
                    subtTtle: subjectName ?? '',
                    icon: Padding(
                      padding: EdgeInsets.only(left: 7.0.w),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 25.sp,
                        color: Theme.of(context).primaryColor,
                      ),
                    )),
                SizedBox(
                  height: 490.h,
                  width: double.infinity,
                  child: FutureBuilder(
                    future:
                        subjectController.getFathersForFavoritesSubject(s_id),
                    builder: (context, snapshot) => snapshot.hasData
                        ? ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ExpansionTile(
                                    onExpansionChanged: (value) {
                                      subjectController.expand(
                                          value, snapshot.data![index]!);
                                    },
                                    childrenPadding:
                                        EdgeInsets.symmetric(vertical: 10.w),
                                    initiallyExpanded:
                                        snapshot.data![index]!.expanded!,
                                    shape: const Border(),
                                    collapsedShape: const Border(),
                                    title: Text(
                                        snapshot.data![index]!.subSubjectName!,
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                        style: ownStyle(
                                            Get.theme.primaryColor, 20.sp)),
                                    subtitle: Text(
                                        snapshot.data![index]!.subSubjectNotes!,
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                        style: ownStyle(
                                                SeenColors.iconColor, 15.sp)!
                                            .copyWith(
                                                fontWeight: FontWeight.w300)),
                                    trailing: SizedBox(
                                      width: 30.w,
                                      height: 30.w,
                                      child: GetBuilder<SubSubjectController>(
                                          builder: (controller) {
                                        return SizedBox(
                                            width: 30.w,
                                            height: 30.w,
                                            child: RotatedBox(
                                              quarterTurns: snapshot
                                                      .data![index]!.expanded!
                                                  ? 1
                                                  : 2,
                                              child: Icon(
                                                Icons.arrow_back_ios_new,
                                                color: Get.theme.primaryColor,
                                                grade: 50,
                                                size: 25.sp,
                                                opticalSize: 6,
                                                weight: 500,
                                              ),
                                            ));
                                      }),
                                    ),
                                    children: subjectController.subSubjects!
                                        .where((element) =>
                                            element!.fatherId ==
                                            snapshot.data![index]!.id)
                                        .map((e) => InkWell(
                                              onTap: () async {
                                                if (e!.isLatex ?? false) {
                                                  Get.toNamed(
                                                    MathQuestionScreen
                                                        .routeName,
                                                    arguments: {
                                                      "subjectID": s_id,
                                                      "subID": e!.id
                                                    },
                                                  );
                                                } else {
                                                  Get.toNamed(
                                                    Questionss.routeName,
                                                    arguments: {
                                                      "subjectID": s_id,
                                                      "subID": e!.id
                                                    },
                                                  );
                                                }
                                                // Get.toNamed(
                                                //   Questionss.routeName,
                                                //   arguments: {
                                                //     "subjectID": s_id,
                                                //     "subID": e!.id
                                                //   },
                                                // );
                                                _lessonController
                                                    .isShuffleAnswers
                                                    .value = false;
                                                _lessonController.lesson.value =
                                                    e.subSubjectName!;
                                                _lessonController
                                                    .loading.value = true;
                                                _lessonController
                                                    .resetSectionDivider();

                                                await _lessonController
                                                    .setQuestionList(
                                                        null,
                                                        e.id!,
                                                        false,
                                                        false,
                                                        true,
                                                        e.isLatex ?? false);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 22.0.w),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 25.w,
                                                      ),
                                                      Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            e!.subSubjectName!,
                                                            style: ownStyle(
                                                                SeenColors
                                                                    .iconColor,
                                                                18.sp),
                                                          )),
                                                      Expanded(
                                                          flex: 1,
                                                          child: Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            size: 18.sp,
                                                            weight: 1000,
                                                            color: SeenColors
                                                                .iconColor,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ))
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
              ],
            ),
          ),
        );
      }),
    );
  }
}
