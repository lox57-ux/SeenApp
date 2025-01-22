import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'package:seen/Features/Sections/controller/subjectController/SubjectController.dart';
import 'package:seen/core/constants/TextStyles.dart';

import 'package:seen/core/settings/widget/custom_option.dart';

import '../../../core/functions/ExamsLogFunction.dart';

import '../../questions/Controller/LessonController.dart';
import '../../questions/screens/questions.dart';

class ExamsLogList extends StatelessWidget {
  ExamsLogList({super.key, this.s_id, required this.tabController});
  // SubjectD s = Get.arguments;
  final int? s_id;
  final TabController tabController;
  LessonController lessonController = Get.find();

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
          child: SizedBox(
            width: double.infinity,
            child: FutureBuilder(
              future: getAllExamLogOfSubject(s_id!),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          snapshot.data![index]!.id;
                          return CustomOption(
                            txt: snapshot.data![index]!.previousName!,
                            func: () async {
                              lessonController.isShuffleAnswers.value = false;
                              lessonController.lesson.value =
                                  snapshot.data![index]!.previousName ?? '';

                              Get.toNamed(
                                Questionss.routeName,
                                arguments: {
                                  "subjectID": s_id,
                                  "subID": null,
                                  'prev_id': snapshot.data![index]!.id
                                },
                              );
                              lessonController.loading.value = true;
                              lessonController.resetSectionDivider();

                              await lessonController.setQuestionList(
                                  null,
                                  snapshot.data![index]!.id!,
                                  false,
                                  true,
                                  false,
                                  false);
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: Get.theme.primaryColor,
                            ),
                            subtTtle:
                                snapshot.data![index]!.previousNotes ?? '',
                          );
                        },
                      )
                    : Center(
                        child: Text(
                        'لا يوجد دورات ',
                        style: ownStyle(Get.theme.primaryColor, 18.sp),
                      ));
              },
            ),
          ),
        );
      }),
    );
  }
}
