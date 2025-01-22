import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:seen/Features/Sections/controller/subjectController/SubjectController.dart';
import 'package:seen/core/constants/Colors.dart';
import 'package:seen/core/constants/TextStyles.dart';

import '../../../shared/model/DataSource/BackgroundDataSource.dart';
import '../../../Features/Sections/controller/subjectController/CustomOptionController.dart';
import '../../../Features/questions/model/data/QuestionsDataSource.dart';
import '../../../Features/questions/model/data/WrongAnswerDataSource.dart';
import '../../functions/QuestionFunction.dart';
import '../../../shared/InvokeWaitingDialog.dart';

class CustomOption extends StatelessWidget {
  CustomOption({
    super.key,
    required this.txt,
    this.id,
    this.hasData,
    this.has_unloacked,
    this.openSubject,
    this.subtTtle,
    required this.func,
    required this.icon,
  });
  int? id;
  bool? hasData;
  bool? openSubject;
  bool? has_unloacked;
  String txt;

  String? subtTtle;
  Function() func;

  Widget icon;

  CustomOptionController customOptionController = Get.find();
  SubjectController subjectController = Get.find();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        func();
        customOptionController.update();
      },
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.w),
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: SeenColors.iconColor))),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              txt,
              style: ownStyle(Theme.of(context).primaryColor, 19.sp),
            ),
            subtitle: subtTtle != null
                ? Text(
                    subtTtle!,
                    textAlign: TextAlign.start,
                    style: ownStyle(SeenColors.iconColor, 12.sp)!
                        .copyWith(fontWeight: FontWeight.w300),
                  )
                : null,
            trailing: id == null
                ? icon
                : SizedBox(
                    width: 150.w,
                    height: 50.w,
                    child: Row(
                      textDirection: TextDirection.ltr,
                      children: [
                        icon,
                        SizedBox(
                          width: 15.w,
                        ),
                        GetBuilder<CustomOptionController>(builder: (_) {
                          return CircleAvatar(
                            backgroundColor: (has_unloacked! ||
                                    openSubject! ||
                                    (has_unloacked! && openSubject!))
                                ? SeenColors.mainColor
                                : SeenColors.iconColor,
                            child: (has_unloacked! ||
                                    openSubject! ||
                                    (has_unloacked! && openSubject!))
                                ? hasData!
                                    ? IconButton(
                                        color: Colors.white,
                                        onPressed: () async {
                                          InvokeWaitingDialog(context);
                                          await QuestionDataSource.instance
                                              .getAllUserQuestionsForSubject(
                                                  id);
                                          await WrongAnswerDataSource.instace
                                              .getWrongAnswersForSubject(id!);
                                          await BackgroundDataSource.instance
                                              .getSubjectFavorites(id!);
                                          subjectController.update();
                                          Get.back();
                                        },
                                        icon: const Icon(Icons.refresh))
                                    : IconButton(
                                        color: Colors.white,
                                        onPressed: () async {
                                          InvokeWaitingDialog(context);
                                          await QuestionDataSource.instance
                                              .getAllUserQuestionsForSubject(
                                                  id);
                                          await WrongAnswerDataSource.instace
                                              .getWrongAnswersForSubject(id!);
                                          await BackgroundDataSource.instance
                                              .getSubjectFavorites(id!);

                                          subjectController.update();
                                          Get.back();
                                        },
                                        icon: const Icon(Icons.download))
                                : const Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                  ),
                          );
                        })
                      ],
                    ),
                  ),
          )),
    );
  }
}
