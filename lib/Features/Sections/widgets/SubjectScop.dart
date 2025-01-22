import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../CodeManaging/model/classes/ActiveCodesLocal.dart';
import '../../CodeManaging/model/classes/ActiveCouponsLocal.dart';
import '../../Splash/InitialNavigationController/RefreshController.dart';
import '../../questions/Controller/LessonController.dart';
import '../controller/subjectController/CustomOptionController.dart';

import '../../Randomize/controllers/RandomizeController.dart';

import '../controller/subjectController/SubjectController.dart';
import '../../../core/constants/Colors.dart';
import '../../../core/constants/TextStyles.dart';
import '../../../core/functions/ActiveCodeFunction.dart';
import '../../../core/functions/localDataFunctions/ActiveCoupon.dart';
import '../../../core/functions/localDataFunctions/CurrentSession.dart';
import '../../../core/functions/localDataFunctions/RandomizeQuestionsFunction.dart';
import '../../../core/functions/localDataFunctions/indexedSubjectsFunction.dart';

import '../model/classes/IndexedSubjects.dart';

import '../../Randomize/Screens/RandomizeScreen.dart';
import 'ChooseSubjectList.dart';

class SubjectsScope extends StatelessWidget {
  SubjectsScope({
    super.key,
  });
  SubjectController subjectController = Get.find();

  LessonController _lessonController = Get.put(LessonController());
  RandomizeController randomizeController = Get.put(RandomizeController());
  RefreshController _ = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () async {
            // await deleteRandomSession();

            var session = await checkRandomizeSessionsIfEmpty();
            if (session == null || session == 0) {
              randomizeController.numberOfQuestionLoading.value = false;
              await randomizeController.setSubjects();

              randomizeController.resetValues();

              Get.toNamed(RandomizeScreen.routeName);
              clearRandomizeTable();
            } else {
              await randomizeController.restoreRandomizeSession();
            }

            // Get.toNamed(RandomizeScreen.routeName);
          },
          child: RotatedBox(
            quarterTurns: 2,
            child: FaIcon(
              FontAwesomeIcons.random,
              color: Theme.of(context).cardColor,
            ),
          )),
      body: GetBuilder<RefreshController>(builder: (refreshController) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.6.w),
              child: SizedBox(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.0.w, horizontal: 8.w),
                        child: Text(
                          'الانتقال السريع ',
                          style: ownStyle(SeenColors.iconColor, 15.sp)!
                              .copyWith(fontWeight: FontWeight.w300),
                        ),
                      ),
                      SizedBox(
                          width: double.infinity,
                          height: 80.h,
                          child: FutureBuilder(
                              future: getIndexedSubjects(),
                              builder: (context, snapshots) {
                                return snapshots.hasData
                                    ? ListView.builder(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 0.w, vertical: 3.w),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshots.data!.length < 6
                                            ? snapshots.data!.length
                                            : 6,
                                        itemBuilder: (context, index) =>
                                            GetBuilder<SubjectController>(
                                                builder: (_) {
                                          return InkWell(
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            onTap: () async {
                                              subjectController
                                                  .questionsLanguage!
                                                  .value = snapshots
                                                      .data![index]!.language ??
                                                  'عربي';
                                              int numOFDisabeledcodes = 0;
                                              if (snapshots.data![index]!
                                                  .hasUnloackedSub!) {
                                                var indexedLentgh =
                                                    await getIndexedSubjects();
                                                List<IndexedSubject?>? a =
                                                    await getIndexedSubject(
                                                        snapshots
                                                            .data![index]!.id!);

                                                if (a != null) {
                                                  updateIndex(IndexedSubject(
                                                      id: snapshots
                                                          .data![index]!.id,
                                                      language: snapshots
                                                          .data![index]!
                                                          .language,
                                                      hasUnloackedSub: snapshots
                                                          .data![index]!
                                                          .hasUnloackedSub,
                                                      has_data: snapshots
                                                          .data![index]!
                                                          .has_data,
                                                      open_subject: snapshots
                                                          .data![index]!
                                                          .open_subject,
                                                      subject_coupon: snapshots
                                                          .data![index]!
                                                          .subject_coupon,
                                                      subjectName: snapshots
                                                          .data![index]!
                                                          .subjectName,
                                                      subject_code: snapshots
                                                          .data![index]!
                                                          .subject_code));
                                                } else {
                                                  updateIndex(IndexedSubject(
                                                      id: snapshots
                                                          .data![index]!.id,
                                                      language: snapshots
                                                          .data![index]!
                                                          .language,
                                                      hasUnloackedSub: snapshots
                                                          .data![index]!
                                                          .hasUnloackedSub,
                                                      has_data: snapshots
                                                          .data![index]!
                                                          .has_data,
                                                      open_subject: snapshots
                                                          .data![index]!
                                                          .open_subject,
                                                      subject_coupon: snapshots
                                                          .data![index]!
                                                          .subject_coupon,
                                                      subjectName: snapshots
                                                          .data![index]!
                                                          .subjectName,
                                                      subject_code: snapshots
                                                          .data![index]!
                                                          .subject_code));
                                                }

                                                Get.nestedKey(1)!
                                                    .currentState!
                                                    .pushNamed('/SubSubjects',
                                                        arguments: {
                                                      'id': snapshots
                                                          .data![index]!.id!,
                                                      'subject_name': snapshots
                                                          .data![index]!
                                                          .subjectName!,
                                                      'isLocked': !snapshots
                                                          .data![index]!
                                                          .open_subject!
                                                    });
                                              } else {
                                                List<ActiveCodesLocal>? a =
                                                    await getActiveCodeForSubject(
                                                        snapshots
                                                            .data![index]!.id!);

                                                if (a != null) {
                                                  for (var valid in a) {
                                                    List<ActiveCodesLocal>? b =
                                                        await isValidCode(
                                                            valid.id!);

                                                    if (b != null) {
                                                    } else {
                                                      numOFDisabeledcodes++;
                                                    }
                                                  }
                                                }
                                                int numOFDisabeledcoupons = 0;
                                                List<ActiveCouponsLocal>?
                                                    acCoupon =
                                                    await getActiveCouponForSubject(
                                                        snapshots
                                                            .data![index]!.id!);

                                                if (acCoupon != null) {
                                                  for (var validc in acCoupon) {
                                                    List<ActiveCouponsLocal>?
                                                        bcoupoun =
                                                        await isValidCoupon(
                                                            validc.id!);

                                                    if (bcoupoun != null) {
                                                    } else {
                                                      numOFDisabeledcoupons++;
                                                    }
                                                  }
                                                }

                                                if (snapshots.data![index]!
                                                            .subject_code !=
                                                        null &&
                                                    snapshots.data![index]!
                                                            .subject_coupon ==
                                                        null) {
                                                  if (numOFDisabeledcodes >=
                                                      snapshots.data![index]!
                                                          .subject_code!) {
                                                    subjectController
                                                        .stopAstartAnimation();
                                                    refreshController.update();
                                                    await Future.delayed(
                                                        const Duration(
                                                            milliseconds: 100));
                                                    subjectController
                                                        .stopAstartAnimation();

                                                    Get.nestedKey(1)!
                                                        .currentState!
                                                        .pushNamed(
                                                          '/notAmember',
                                                        );
                                                  } else {
                                                    var indexedLentgh =
                                                        await getIndexedSubjects();
                                                    List<IndexedSubject?>? a =
                                                        await getIndexedSubject(
                                                            snapshots
                                                                .data![index]!
                                                                .id!);

                                                    if (a != null) {
                                                      updateIndex(IndexedSubject(
                                                          id: snapshots
                                                              .data![index]!.id,
                                                          hasUnloackedSub:
                                                              snapshots
                                                                  .data![index]!
                                                                  .hasUnloackedSub,
                                                          has_data: snapshots
                                                              .data![index]!
                                                              .has_data,
                                                          open_subject:
                                                              snapshots
                                                                  .data![index]!
                                                                  .open_subject,
                                                          language: snapshots
                                                              .data![index]!
                                                              .language,
                                                          subject_coupon:
                                                              snapshots
                                                                  .data![index]!
                                                                  .subject_coupon,
                                                          subjectName: snapshots
                                                              .data![index]!
                                                              .subjectName,
                                                          subject_code: snapshots
                                                              .data![index]!
                                                              .subject_code));
                                                    } else {
                                                      updateIndex(IndexedSubject(
                                                          id: snapshots
                                                              .data![index]!.id,
                                                          hasUnloackedSub:
                                                              snapshots
                                                                  .data![index]!
                                                                  .hasUnloackedSub,
                                                          has_data: snapshots
                                                              .data![index]!
                                                              .has_data,
                                                          open_subject:
                                                              snapshots
                                                                  .data![index]!
                                                                  .open_subject,
                                                          language: snapshots
                                                              .data![index]!
                                                              .language,
                                                          subject_coupon:
                                                              snapshots
                                                                  .data![index]!
                                                                  .subject_coupon,
                                                          subjectName: snapshots
                                                              .data![index]!
                                                              .subjectName,
                                                          subject_code: snapshots
                                                              .data![index]!
                                                              .subject_code));
                                                    }

                                                    Get.nestedKey(1)!
                                                        .currentState!
                                                        .pushNamed(
                                                            '/SubSubjects',
                                                            arguments: {
                                                          'id': snapshots
                                                              .data![index]!
                                                              .id!,
                                                          'subject_name':
                                                              snapshots
                                                                  .data![index]!
                                                                  .subjectName!
                                                        });
                                                  }
                                                } else if (snapshots
                                                            .data![index]!
                                                            .subject_code ==
                                                        null &&
                                                    snapshots.data![index]!
                                                            .subject_coupon !=
                                                        null) {
                                                  if (numOFDisabeledcoupons >=
                                                      snapshots.data![index]!
                                                          .subject_coupon!) {
                                                    subjectController
                                                        .stopAstartAnimation();
                                                    refreshController.update();
                                                    await Future.delayed(
                                                        const Duration(
                                                            milliseconds: 100));
                                                    subjectController
                                                        .stopAstartAnimation();

                                                    Get.nestedKey(1)!
                                                        .currentState!
                                                        .pushNamed(
                                                          '/notAmember',
                                                        );
                                                  } else {
                                                    var indexedLentgh =
                                                        await getIndexedSubjects();
                                                    List<IndexedSubject?>? a =
                                                        await getIndexedSubject(
                                                            snapshots
                                                                .data![index]!
                                                                .id!);

                                                    if (a != null) {
                                                      updateIndex(IndexedSubject(
                                                          id: snapshots
                                                              .data![index]!.id,
                                                          language: snapshots
                                                              .data![index]!
                                                              .language,
                                                          hasUnloackedSub:
                                                              snapshots
                                                                  .data![index]!
                                                                  .hasUnloackedSub,
                                                          has_data: snapshots
                                                              .data![index]!
                                                              .has_data,
                                                          open_subject:
                                                              snapshots
                                                                  .data![index]!
                                                                  .open_subject,
                                                          subjectName: snapshots
                                                              .data![index]!
                                                              .subjectName,
                                                          subject_coupon:
                                                              snapshots
                                                                  .data![index]!
                                                                  .subject_coupon,
                                                          subject_code: snapshots
                                                              .data![index]!
                                                              .subject_code));
                                                    } else {
                                                      updateIndex(IndexedSubject(
                                                          id: snapshots
                                                              .data![index]!.id,
                                                          subject_coupon:
                                                              snapshots
                                                                  .data![index]!
                                                                  .subject_coupon,
                                                          language: snapshots
                                                              .data![index]!
                                                              .language,
                                                          subjectName: snapshots
                                                              .data![index]!
                                                              .subjectName,
                                                          subject_code: snapshots
                                                              .data![index]!
                                                              .subject_code));
                                                    }

                                                    Get.nestedKey(1)!
                                                        .currentState!
                                                        .pushNamed(
                                                            '/SubSubjects',
                                                            arguments: {
                                                          'id': snapshots
                                                              .data![index]!
                                                              .id!,
                                                          'subject_name':
                                                              snapshots
                                                                  .data![index]!
                                                                  .subjectName!,
                                                          'isLocked': !snapshots
                                                              .data![index]!
                                                              .open_subject!
                                                        });
                                                  }
                                                } else if (snapshots
                                                            .data![index]!
                                                            .subject_code !=
                                                        null &&
                                                    snapshots.data![index]!
                                                            .subject_coupon !=
                                                        null) {
                                                  if (numOFDisabeledcodes >=
                                                          snapshots
                                                              .data![index]!
                                                              .subject_code! ||
                                                      numOFDisabeledcoupons >=
                                                          snapshots
                                                              .data![index]!
                                                              .subject_coupon! ||
                                                      (numOFDisabeledcodes >=
                                                              snapshots
                                                                  .data![index]!
                                                                  .subject_code! &&
                                                          numOFDisabeledcoupons >=
                                                              snapshots
                                                                  .data![index]!
                                                                  .subject_coupon!)) {
                                                    subjectController
                                                        .stopAstartAnimation();
                                                    refreshController.update();
                                                    await Future.delayed(
                                                        const Duration(
                                                            milliseconds: 100));
                                                    subjectController
                                                        .stopAstartAnimation();

                                                    Get.nestedKey(1)!
                                                        .currentState!
                                                        .pushNamed(
                                                          '/notAmember',
                                                        );
                                                  } else {
                                                    var indexedLentgh =
                                                        await getIndexedSubjects();
                                                    List<IndexedSubject?>? a =
                                                        await getIndexedSubject(
                                                            snapshots
                                                                .data![index]!
                                                                .id!);

                                                    if (a != null) {
                                                      updateIndex(IndexedSubject(
                                                          id: snapshots
                                                              .data![index]!.id,
                                                          hasUnloackedSub:
                                                              snapshots
                                                                  .data![index]!
                                                                  .hasUnloackedSub,
                                                          has_data: snapshots
                                                              .data![index]!
                                                              .has_data,
                                                          open_subject:
                                                              snapshots
                                                                  .data![index]!
                                                                  .open_subject,
                                                          language: snapshots
                                                              .data![index]!
                                                              .language,
                                                          subject_coupon:
                                                              snapshots
                                                                  .data![index]!
                                                                  .subject_coupon,
                                                          subjectName: snapshots
                                                              .data![index]!
                                                              .subjectName,
                                                          subject_code: snapshots
                                                              .data![index]!
                                                              .subject_code));
                                                    } else {
                                                      updateIndex(IndexedSubject(
                                                          id: snapshots
                                                              .data![index]!.id,
                                                          hasUnloackedSub:
                                                              snapshots
                                                                  .data![index]!
                                                                  .hasUnloackedSub,
                                                          has_data: snapshots
                                                              .data![index]!
                                                              .has_data,
                                                          open_subject:
                                                              snapshots
                                                                  .data![index]!
                                                                  .open_subject,
                                                          language: snapshots
                                                              .data![index]!
                                                              .language,
                                                          subjectName: snapshots
                                                              .data![index]!
                                                              .subjectName,
                                                          subject_coupon:
                                                              snapshots
                                                                  .data![index]!
                                                                  .subject_coupon,
                                                          subject_code: snapshots
                                                              .data![index]!
                                                              .subject_code));
                                                    }

                                                    Get.nestedKey(1)!
                                                        .currentState!
                                                        .pushNamed(
                                                            '/SubSubjects',
                                                            arguments: {
                                                          'id': snapshots
                                                              .data![index]!
                                                              .id!,
                                                          'subject_name':
                                                              snapshots
                                                                  .data![index]!
                                                                  .subjectName!,
                                                          'isLocked': !snapshots
                                                              .data![index]!
                                                              .open_subject!
                                                        });
                                                  }
                                                } else {
                                                  subjectController
                                                      .stopAstartAnimation();
                                                  refreshController.update();
                                                  await Future.delayed(
                                                      const Duration(
                                                          milliseconds: 100));
                                                  subjectController
                                                      .stopAstartAnimation();

                                                  Get.nestedKey(1)!
                                                      .currentState!
                                                      .pushNamed(
                                                        '/notAmember',
                                                      );
                                                }
                                              }
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                horizontal: 5.w,
                                              ),
                                              clipBehavior: Clip.hardEdge,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(15.r),
                                              ),
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.linear,
                                                margin: const EdgeInsets.only(
                                                    bottom: 6,
                                                    left: 3,
                                                    right: 3,
                                                    top: 3),
                                                clipBehavior: Clip.hardEdge,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                height:
                                                    subjectController.animateIt
                                                        ? 105.h
                                                        : 100.h,
                                                alignment: Alignment.center,
                                                width:
                                                    subjectController.animateIt
                                                        ? 113.w
                                                        : 110.w,
                                                child: RichText(
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  text: TextSpan(children: [
                                                    TextSpan(
                                                      text: snapshots
                                                          .data![index]!
                                                          .subjectName!,
                                                      style: introMsg()!
                                                          .copyWith(
                                                              fontSize: 18.sp,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                    )
                                                  ]),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      )
                                    : Center(
                                        child: Text(
                                          "يُرجى الدخول إلى مادة أولاً",
                                          style: ownStyle(
                                                  Theme.of(context)!
                                                      .primaryColor!,
                                                  16.sp)!
                                              .copyWith(
                                                  fontWeight: FontWeight.w200),
                                        ),
                                      );
                              }))
                    ]),
              ),
            ),
            Expanded(flex: 3, child: ChooseSubjectList())
          ],
        );
      }),
    );
  }
}
