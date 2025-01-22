import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:seen/core/controller/text_controller.dart';
import 'package:seen/core/controller/theme_controller.dart';
import 'package:seen/core/constants/Colors.dart';
import 'package:seen/core/constants/TextStyles.dart';
import 'package:seen/Features/questions/screens/MathQuestionsScreen.dart';
import 'package:seen/shared/custom_text_field.dart';

import '../../../shared/model/LocalDataSource.dart/LocalData.dart';
import '../../../shared/model/LocalDataSource.dart/LocalData.dart';
import '../../questions/Controller/LessonController.dart';
import '../controllers/RandomizeController.dart';
import '../../Sections/controller/subjectController/SubSubjectController.dart';
import '../../../core/functions/localDataFunctions/SubjectFunctions.dart';
import '../../questions/screens/questions.dart';

class RandomizeScreen extends StatelessWidget {
  RandomizeScreen({super.key});
  static const routeName = '/randomize';
  SubSubjectController subjectController = Get.find();
  ThemeController themeController = Get.find();
  TextController textController = Get.find();
  RandomizeController randomizeController = Get.find();
  LessonController _lessonController = Get.find();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    randomizeController.isLatex = false;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            if ((randomizeController.questionToSolveNumber >
                    randomizeController.numberOfQuestion.value) ||
                randomizeController.questionToSolveNumber == 0) {
              showDialog(
                context: context,
                builder: (context) => Card(
                  margin:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 230.w),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.w),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            Icons.warning_amber,
                            size: 40.w,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            height: 40.w,
                          ),
                          Text(
                            'الرجاء إدخال قيمة صحيحة',
                            style:
                                ownStyle(Theme.of(context).primaryColor, 18.sp),
                          )
                        ]),
                  ),
                ),
              );
            } else {
              _lessonController.loading.value = true;
              _lessonController.lesson.value = 'اختبار عشوائي';

              if (randomizeController.isLatex) {
                Get.toNamed(MathQuestionScreen.routeName,
                    arguments: {"subjectID": null, "subID": null});
                randomizeController.setQuestionList(true);
              } else {
                Get.toNamed(Questionss.routeName,
                    arguments: {"subjectID": null, "subID": null});
                randomizeController.setQuestionList(false);
              }
            }
          },
          child: RotatedBox(
            quarterTurns: 2,
            child: FaIcon(
              Icons.play_arrow_rounded,
              size: 40.sp,
              color: Theme.of(context).cardColor,
            ),
          )),
      // backgroundColor: SeenColors.codeManaginBackground,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(
          left: 12.0.w,
          right: 12.0.w,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30.w,
                  ),
                  themeController.isDarkMode.value
                      ? SvgPicture.asset(
                          'assets/Qustions/shuffleDark.svg',
                          width: 150.w,
                        )
                      : SvgPicture.asset(
                          'assets/Qustions/shuffleLight.svg',
                          width: 150.w,
                        ),
                  Padding(
                    padding: EdgeInsets.all(6.0.w),
                    child: Text(
                      'الاختبار العشوائي',
                      textAlign: TextAlign.center,
                      style: ownStyle(Theme.of(context).primaryColor, 32.sp),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.0.w, vertical: 4.w),
                    child: Text(
                      ' يقوم الاختبار العشوائي بتوليد مجموعة من الأسئلة بناءً على المواد التي تختارها',
                      style: ownStyle(SeenColors.iconColor, 12.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(right: 8.0.w, left: 20.0.w),
                            child: SizedBox(
                              width: 30.w,
                              height: 37.w,
                              child: Obx(() {
                                return Switch(
                                  activeColor: Theme.of(context).cardColor,
                                  activeTrackColor:
                                      Theme.of(context).primaryColor,
                                  value:
                                      _lessonController.isShuffleAnswers.value,
                                  onChanged: (value) async {
                                    _lessonController.isShuffleAnswers.value =
                                        value;
                                    await textController.pref!
                                        .setBool('isShuffle', value);
                                  },
                                );
                              }),
                            ),
                          ),
                          SizedBox(
                            width: 100.w,
                            child: Text(
                              'ترتيب الأجوبة عشوائياً',
                              maxLines: 2,
                              style: ownStyle(
                                  Theme.of(context).primaryColor, 12.sp),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                              constraints:
                                  BoxConstraints.loose(Size(75.w, 37.w)),
                              child: Form(
                                key: _formKey,
                                child: TextFormField(
                                  onChanged: (value) {
                                    randomizeController.questionToSolveNumber =
                                        0;
                                    randomizeController.questionToSolveNumber =
                                        int.parse(value);
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 5.w),
                                    hintStyle: ownStyle(
                                        Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.5),
                                        10.sp),
                                    label: Text(
                                      'أدخل العدد',
                                      style: ownStyle(
                                          Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.7),
                                          12.sp),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.horizontal(
                                          right: Radius.circular(10.r)),
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.horizontal(
                                          right: Radius.circular(10.r)),
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.horizontal(
                                          right: Radius.circular(10.r)),
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.horizontal(
                                          right: Radius.circular(10.r)),
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                    ),
                                    errorMaxLines: 1,
                                    errorStyle: TextStyle(
                                        fontSize: 12.sp, height: 50.w),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.horizontal(
                                          right: Radius.circular(10.r)),
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ),
                              )),
                          Container(
                            padding: EdgeInsets.all(10.w),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(10.r))),
                            child: Obx(() {
                              return randomizeController
                                      .numberOfQuestionLoading.value
                                  ? SizedBox(
                                      height: 18.h,
                                      width: 18.h,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      '    ${randomizeController.numberOfQuestion.value}   ',
                                      style: ownStyle(
                                          Theme.of(context).cardColor, 12.sp),
                                    );
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Card(
                margin: EdgeInsets.only(top: 10.w),
                surfaceTintColor: Colors.white,
                child: GetBuilder<RandomizeController>(builder: (_) {
                  return ListView.builder(
                    itemCount: randomizeController.subjects == null
                        ? 0
                        : randomizeController.subjects!.length,
                    itemBuilder: (context, index) {
                      return (textController.pref!.getInt('subjectYearID') ==
                                  null ||
                              textController.pref!.getString('section') ==
                                  'السنة السادسة')
                          ? ExpansionTile(
                              onExpansionChanged: (value) {
                                randomizeController.expandSubject(value,
                                    randomizeController.subjects![index]!);
                              },
                              childrenPadding:
                                  EdgeInsets.symmetric(vertical: 5.w),
                              shape: Border(
                                  bottom: BorderSide(
                                      color: SeenColors.iconColor
                                          .withOpacity(0.5))),
                              collapsedShape: Border(
                                  bottom: BorderSide(
                                      color: SeenColors.iconColor
                                          .withOpacity(0.5))),
                              leading: Checkbox(
                                visualDensity: VisualDensity.compact,
                                activeColor: Get.theme.primaryColor,
                                splashRadius: 10.r,
                                value: randomizeController.subjectID.contains(
                                    randomizeController.subjects![index]!.id),
                                onChanged: (value) {
                                  if (value!) {
                                    randomizeController.addId(
                                        randomizeController
                                            .subjects![index]!.id!,
                                        false,
                                        true,
                                        randomizeController
                                            .subjects![index]!.subjectName!,
                                        false);
                                    randomizeController.update();
                                  } else {
                                    randomizeController.removeId(
                                        randomizeController
                                            .subjects![index]!.id!,
                                        false,
                                        true,
                                        randomizeController
                                            .subjects![index]!.subjectName!,
                                        false);
                                    randomizeController.update();
                                  }
                                },
                              ),
                              title: SizedBox(
                                child: Text(
                                    randomizeController
                                        .subjects![index]!.subjectName!,
                                    style: ownStyle(
                                            Get.theme.primaryColor, 18.sp)!
                                        .copyWith(fontWeight: FontWeight.w800)),
                              ),
                              trailing: SizedBox(
                                width: 30.w,
                                height: 30.w,
                                child: GetBuilder<RandomizeController>(
                                    builder: (controller) {
                                  return SizedBox(
                                      width: 30.w,
                                      height: 30.w,
                                      child: RotatedBox(
                                        quarterTurns: randomizeController
                                                .subjects![index]!.expand!
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
                              children: randomizeController
                                  .getSubsubOfSubject(randomizeController
                                      .subjects![index]!.id!)!
                                  .where((element) => element!.fatherId == null)
                                  .map((e) => Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 10.w),
                                        child: ListTileTheme(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 30.w),
                                          dense: true,
                                          minLeadingWidth: 0,
                                          child: ExpansionTile(
                                            shape: const Border(),
                                            collapsedShape: const Border(),
                                            onExpansionChanged: (value) {
                                              randomizeController.expand(
                                                  value, e!);
                                            },
                                            childrenPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0.w),
                                            leading: Checkbox(
                                              visualDensity:
                                                  VisualDensity.compact,
                                              activeColor:
                                                  Get.theme.primaryColor,
                                              splashRadius: 10.r,
                                              value: randomizeController.baseId
                                                  .contains(e!.id),
                                              onChanged: (value) {
                                                if (value!) {
                                                  randomizeController.addId(
                                                      e!.id!,
                                                      true,
                                                      false,
                                                      randomizeController
                                                          .subjects![index]!
                                                          .subjectName!,
                                                      e.isLatex!);
                                                } else {
                                                  randomizeController.removeId(
                                                      e.id!,
                                                      true,
                                                      false,
                                                      randomizeController
                                                          .subjects![index]!
                                                          .subjectName!,
                                                      e.isLatex!);
                                                }
                                              },
                                            ),
                                            title: SizedBox(
                                              child: Text(e!.subSubjectName!,
                                                  style: ownStyle(
                                                          Get.theme
                                                              .primaryColor,
                                                          16.sp)!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w800)),
                                            ),
                                            trailing: SizedBox(
                                              width: 30.w,
                                              height: 30.w,
                                              child: GetBuilder<
                                                      RandomizeController>(
                                                  builder: (controller) {
                                                return SizedBox(
                                                    width: 30.w,
                                                    height: 30.w,
                                                    child: RotatedBox(
                                                      quarterTurns:
                                                          e!.expanded! ? 1 : 2,
                                                      child: Icon(
                                                        Icons.arrow_back_ios,
                                                        color: Get
                                                            .theme.primaryColor,
                                                        grade: 40,
                                                        size: 20.sp,
                                                        opticalSize: 6,
                                                        weight: 500,
                                                      ),
                                                    ));
                                              }),
                                            ),
                                            children: randomizeController
                                                .getSubsubOfSubject(
                                                    randomizeController
                                                        .subjects![index]!.id!)!
                                                .where((element) =>
                                                    element!.fatherId == e.id)
                                                .map((e) => Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 22.0.w),
                                                    child: ListTile(
                                                      visualDensity:
                                                          VisualDensity.compact,
                                                      minVerticalPadding: 0.0,
                                                      leading: Checkbox(
                                                        activeColor: Get
                                                            .theme.primaryColor,
                                                        value:
                                                            randomizeController
                                                                .subIds
                                                                .contains(
                                                                    e!.id),
                                                        onChanged: (value) {
                                                          if (value!) {
                                                            randomizeController.addId(
                                                                e.id!,
                                                                false,
                                                                false,
                                                                randomizeController
                                                                    .subjects![
                                                                        index]!
                                                                    .subjectName!,
                                                                e.isLatex!);
                                                          } else {
                                                            randomizeController.removeId(
                                                                e.id!,
                                                                false,
                                                                false,
                                                                randomizeController
                                                                    .subjects![
                                                                        index]!
                                                                    .subjectName!,
                                                                e.isLatex!);
                                                          }
                                                        },
                                                      ),
                                                      horizontalTitleGap: 1.w,
                                                      title: Text(
                                                        e!.subSubjectName!,
                                                        style: ownStyle(
                                                            SeenColors
                                                                .iconColor,
                                                            16.sp),
                                                      ),
                                                    )))
                                                .toList(),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            )
                          : textController.pref!.getString('chapter') ==
                                  randomizeController.subjects![index]!.term
                              ? ListTileTheme(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 30.w),
                                  dense: true,
                                  minLeadingWidth: 0,
                                  child: ExpansionTile(
                                    onExpansionChanged: (value) {
                                      randomizeController.expandSubject(
                                          value,
                                          randomizeController
                                              .subjects![index]!);
                                    },
                                    childrenPadding:
                                        EdgeInsets.symmetric(vertical: 5.w),
                                    shape: Border(
                                        bottom: BorderSide(
                                            color: SeenColors.iconColor
                                                .withOpacity(0.5))),
                                    collapsedShape: Border(
                                        bottom: BorderSide(
                                            color: SeenColors.iconColor
                                                .withOpacity(0.5))),
                                    leading: Checkbox(
                                      visualDensity: VisualDensity.compact,
                                      activeColor: Get.theme.primaryColor,
                                      splashRadius: 10.r,
                                      value: randomizeController.subjectID
                                          .contains(randomizeController
                                              .subjects![index]!.id),
                                      onChanged: (value) {
                                        if (value!) {
                                          randomizeController.addId(
                                              randomizeController
                                                  .subjects![index]!.id!,
                                              false,
                                              true,
                                              randomizeController
                                                  .subjects![index]!
                                                  .subjectName!,
                                              false);
                                          randomizeController.update();
                                        } else {
                                          randomizeController.removeId(
                                              randomizeController
                                                  .subjects![index]!.id!,
                                              false,
                                              true,
                                              randomizeController
                                                  .subjects![index]!
                                                  .subjectName!,
                                              false);
                                          randomizeController.update();
                                        }
                                      },
                                    ),
                                    title: SizedBox(
                                      child: Text(
                                          randomizeController
                                              .subjects![index]!.subjectName!,
                                          style: ownStyle(
                                                  Get.theme.primaryColor,
                                                  18.sp)!
                                              .copyWith(
                                                  fontWeight: FontWeight.w800)),
                                    ),
                                    trailing: SizedBox(
                                      width: 30.w,
                                      height: 30.w,
                                      child: GetBuilder<RandomizeController>(
                                          builder: (controller) {
                                        return SizedBox(
                                            width: 30.w,
                                            height: 30.w,
                                            child: RotatedBox(
                                              quarterTurns: randomizeController
                                                      .subjects![index]!.expand!
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
                                    children: randomizeController
                                        .getSubsubOfSubject(randomizeController
                                            .subjects![index]!.id!)!
                                        .where((element) =>
                                            element!.fatherId == null)
                                        .map((e) => Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w),
                                              child: ListTileTheme(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 0,
                                                        horizontal: 30.w),
                                                dense: true,
                                                minLeadingWidth: 0,
                                                child: ExpansionTile(
                                                  shape: Border(),
                                                  collapsedShape: Border(),
                                                  onExpansionChanged: (value) {
                                                    randomizeController.expand(
                                                        value, e!);
                                                  },
                                                  childrenPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 3.w),
                                                  leading: Checkbox(
                                                    visualDensity:
                                                        VisualDensity.compact,
                                                    activeColor:
                                                        Get.theme.primaryColor,
                                                    splashRadius: 10.r,
                                                    value: randomizeController
                                                        .baseId
                                                        .contains(e!.id),
                                                    onChanged: (value) {
                                                      if (value!) {
                                                        randomizeController.addId(
                                                            e!.id!,
                                                            true,
                                                            false,
                                                            randomizeController
                                                                .subjects![
                                                                    index]!
                                                                .subjectName!,
                                                            e.isLatex!);
                                                      } else {
                                                        randomizeController.removeId(
                                                            e.id!,
                                                            true,
                                                            false,
                                                            randomizeController
                                                                .subjects![
                                                                    index]!
                                                                .subjectName!,
                                                            e.isLatex!);
                                                      }
                                                    },
                                                  ),
                                                  title: SizedBox(
                                                    child: Text(
                                                        e!.subSubjectName!,
                                                        style: ownStyle(
                                                                Get.theme
                                                                    .primaryColor,
                                                                16.sp)!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800)),
                                                  ),
                                                  trailing: SizedBox(
                                                    width: 30.w,
                                                    height: 30.w,
                                                    child: GetBuilder<
                                                            RandomizeController>(
                                                        builder: (controller) {
                                                      return SizedBox(
                                                          width: 30.w,
                                                          height: 30.w,
                                                          child: RotatedBox(
                                                            quarterTurns:
                                                                e!.expanded!
                                                                    ? 1
                                                                    : 2,
                                                            child: Icon(
                                                              Icons
                                                                  .arrow_back_ios,
                                                              color: Get.theme
                                                                  .primaryColor,
                                                              grade: 40,
                                                              size: 20.sp,
                                                              opticalSize: 6,
                                                              weight: 500,
                                                            ),
                                                          ));
                                                    }),
                                                  ),
                                                  children: randomizeController
                                                      .getSubsubOfSubject(
                                                          randomizeController
                                                              .subjects![index]!
                                                              .id!)!
                                                      .where((element) =>
                                                          element!.fatherId ==
                                                          e.id)
                                                      .map((e) => Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      22.0.w),
                                                          child: ListTile(
                                                            visualDensity:
                                                                VisualDensity
                                                                    .compact,
                                                            leading: Checkbox(
                                                              visualDensity:
                                                                  VisualDensity
                                                                      .compact,
                                                              activeColor: Get
                                                                  .theme
                                                                  .primaryColor,
                                                              value:
                                                                  randomizeController
                                                                      .subIds
                                                                      .contains(
                                                                          e!.id),
                                                              onChanged:
                                                                  (value) {
                                                                if (value!) {
                                                                  randomizeController.addId(
                                                                      e.id!,
                                                                      false,
                                                                      false,
                                                                      randomizeController
                                                                          .subjects![
                                                                              index]!
                                                                          .subjectName!,
                                                                      e.isLatex!);
                                                                } else {
                                                                  randomizeController.removeId(
                                                                      e.id!,
                                                                      false,
                                                                      false,
                                                                      randomizeController
                                                                          .subjects![
                                                                              index]!
                                                                          .subjectName!,
                                                                      e.isLatex!);
                                                                }
                                                              },
                                                            ),
                                                            horizontalTitleGap:
                                                                1.w,
                                                            title: Text(
                                                              e!.subSubjectName!,
                                                              style: ownStyle(
                                                                  SeenColors
                                                                      .iconColor,
                                                                  16.sp),
                                                            ),
                                                          )))
                                                      .toList(),
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                )
                              : const SizedBox();
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
