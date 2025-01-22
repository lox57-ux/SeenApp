import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/constants/TextStyles.dart';
import '../../../core/settings/widget/custom_option.dart';
import '../../questions/Controller/LessonController.dart';
import '../../questions/Controller/SelectAnswerController/WrongAnswersController.dart';
import '../../questions/screens/MathQuestionsScreen.dart';
import '../../questions/screens/questions.dart';
import '../controller/subjectController/SubSubjectController.dart';
import '../controller/subjectController/SubjectController.dart';

class WrongAnswersList extends StatelessWidget {
  WrongAnswersList(
      {super.key,
      required this.s_id,
      required this.subjectName,
      required this.tabController});
  final int s_id;
  final TabController tabController;
  final String? subjectName;
  WrongAnswersCotroller _wrongAnswersController = Get.find();
  LessonController lessonController = Get.find();
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
                    txt: 'جميع الأسئلة الخاطئة',
                    func: () async {
                      lessonController.isShuffleAnswers.value = false;
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
                      lessonController.lesson.value = 'جميع الأسئلة الخاطئة';
                      lessonController.loading.value = true;
                      await lessonController.resetSectionDivider();
                      lessonController.isAllWrong = true;
                      print('##$s_id#');
                      await lessonController.setQuestionList(s_id, null, true,
                          false, false, subjectName == 'رياضيات');
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
                    future: subjectController.getFathersForWrongSubject(s_id),
                    builder: (context, snapshot) => snapshot.hasData
                        ? snapshot.data!.isEmpty
                            ? Center(
                                child: Image.asset('assets/Qustions/rpeat.png'),
                              )
                            : ListView.builder(
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
                                        childrenPadding: EdgeInsets.symmetric(
                                            vertical: 10.w),
                                        initiallyExpanded:
                                            snapshot.data![index]!.expanded!,
                                        shape: const Border(),
                                        collapsedShape: const Border(),
                                        title: Text(
                                            snapshot
                                                .data![index]!.subSubjectName!,
                                            style: ownStyle(
                                                Get.theme.primaryColor, 20.sp)),
                                        subtitle: Text(
                                            snapshot
                                                .data![index]!.subSubjectNotes!,
                                            maxLines: 1,
                                            overflow: TextOverflow.fade,
                                            style: ownStyle(
                                                    SeenColors.iconColor,
                                                    15.sp)!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w300)),
                                        trailing: SizedBox(
                                          width: 30.w,
                                          height: 30.w,
                                          child:
                                              GetBuilder<SubSubjectController>(
                                                  builder: (controller) {
                                            return SizedBox(
                                                width: 30.w,
                                                height: 30.w,
                                                child: RotatedBox(
                                                  quarterTurns: snapshot
                                                          .data![index]!
                                                          .expanded!
                                                      ? 1
                                                      : 2,
                                                  child: Icon(
                                                    Icons.arrow_back_ios_new,
                                                    color:
                                                        Get.theme.primaryColor,
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
                                                    lessonController
                                                        .isShuffleAnswers
                                                        .value = false;
                                                    lessonController
                                                        .loading.value = true;
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
                                                    lessonController
                                                            .lesson.value =
                                                        e.subSubjectName!;
                                                    await lessonController
                                                        .resetSectionDivider();
                                                    lessonController.isWrong =
                                                        true;
                                                    await lessonController
                                                        .setQuestionList(
                                                            null,
                                                            e.id!,
                                                            true,
                                                            false,
                                                            false,
                                                            e.isLatex ?? false);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
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
//  CustomOption(
//                 subtTtle: dummy_subject[index].subtitle,
//                 txt: dummy_subject[index].title,
//                 func: () {
//                   Get.to(() => ChooseSections(),
//                       arguments: dummy_subject[index]);
//                 },
//                 icon: Icon(Icons.arrow_back_ios_new)),