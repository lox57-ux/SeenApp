import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:seen/core/constants/TextStyles.dart';

import 'package:seen/core/settings/widget/custom_option.dart';

import '../../../shared/model/DataSource/BackgroundDataSource.dart';
import '../../Splash/InitialNavigationController/RefreshController.dart';
import '../../questions/model/data/QuestionsDataSource.dart';
import '../../questions/model/data/WrongAnswerDataSource.dart';
import '../controller/subjectController/SubjectController.dart';
import '../../../core/controller/text_controller.dart';
import '../../../core/functions/ActiveCodeFunction.dart';
import '../../../core/functions/localDataFunctions/ActiveCoupon.dart';
import '../../../core/functions/localDataFunctions/SubjectFunctions.dart';
import '../../../core/functions/localDataFunctions/indexedSubjectsFunction.dart';

import '../model/classes/IndexedSubjects.dart';
import '../../../shared/InvokeWaitingDialog.dart';

class ChooseSubjectList extends StatelessWidget {
  ChooseSubjectList({super.key});
  RefreshController refreshController = Get.find();
  SubjectController subjectController = Get.find();
  TextController textController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubjectController>(builder: (_) {
      return Card(
        shadowColor: Get.theme.cardColor,
        elevation: 0,
        margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 5.h, bottom: 0.h),
        surfaceTintColor: Colors.white,
        child: SizedBox(
          width: double.infinity,
          child: FutureBuilder(
              future: getSubjects(),
              builder: (context, snapShot) {
                if (snapShot.hasData) {
                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: 10.h),
                    itemCount: snapShot.data!.length,
                    itemBuilder: (context, index) => (textController.pref!
                                    .getInt('subjectYearID') ==
                                null ||
                            textController.pref!.getString('section') ==
                                'السنة السادسة')
                        ? (snapShot.data![index]!.yearId == null ||
                                textController.pref!.getString('section') ==
                                    'السنة السادسة')
                            ? CustomOption(
                                has_unloacked:
                                    snapShot.data![index]!.hasUnloackedSub!,
                                openSubject:
                                    snapShot.data![index]!.open_subject,
                                hasData: snapShot.data![index]!.has_data,
                                id: snapShot.data![index]!.id,
                                subtTtle: snapShot.data![index]!.subjectNotes,
                                txt: snapShot.data![index]!.subjectName!,
                                func: () async {
                                  subjectController.questionsLanguage!.value =
                                      snapShot.data![index]!.language!;
                                  if (snapShot.data![index]!.open_subject!) {
                                    if (snapShot.data![index]!.has_data!) {
                                      await subjectController.checkSubscription(
                                          snapShot.data![index]!);
                                    } else {
                                      InvokeWaitingDialog(context);
                                      await QuestionDataSource.instance
                                          .getAllUserQuestionsForSubject(
                                              snapShot.data![index]!.id);
                                      await WrongAnswerDataSource.instace
                                          .getWrongAnswersForSubject(
                                              snapShot.data![index]!.id!);
                                      await BackgroundDataSource.instance
                                          .getSubjectFavorites(
                                              snapShot.data![index]!.id!);
                                      snapShot.data![index]!.has_data = true;
                                      subjectController.update();

                                      Get.back();
                                    }
                                  } else if (snapShot
                                      .data![index]!.hasUnloackedSub!) {
                                    Get.nestedKey(1)!
                                        .currentState!
                                        .pushNamed('/SubSubjects', arguments: {
                                      'id': snapShot.data![index]!.id!,
                                      'subject_name':
                                          snapShot.data![index]!.subjectName!,
                                      'isLocked':
                                          !snapShot.data![index]!.open_subject!
                                    });
                                    List<IndexedSubject?>? a =
                                        await getIndexedSubject(
                                            snapShot.data![index]!.id!);
                                    if (a != null) {
                                      updateIndex(IndexedSubject(
                                          open_subject: snapShot
                                              .data![index]!.open_subject,
                                          has_data:
                                              snapShot.data![index]!.has_data,
                                          hasUnloackedSub: snapShot
                                              .data![index]!.hasUnloackedSub,
                                          subject_coupon: snapShot
                                              .data![index]!.subject_coupon,
                                          id: snapShot.data![index]!.id,
                                          language:
                                              snapShot.data![index]!.language,
                                          subjectName: snapShot
                                              .data![index]!.subjectName,
                                          subject_code: snapShot
                                              .data![index]!.subject_code));
                                    } else {
                                      var indexedLentgh =
                                          await getIndexedSubjects();
                                      insertIndexed(
                                          snapShot.data![index]!,
                                          indexedLentgh == null
                                              ? 0
                                              : indexedLentgh!.length);
                                      updateIndex(IndexedSubject(
                                          open_subject: snapShot
                                              .data![index]!.open_subject,
                                          has_data:
                                              snapShot.data![index]!.has_data,
                                          hasUnloackedSub: snapShot
                                              .data![index]!.hasUnloackedSub,
                                          id: snapShot.data![index]!.id,
                                          language:
                                              snapShot.data![index]!.language,
                                          subjectName: snapShot
                                              .data![index]!.subjectName,
                                          subject_coupon: snapShot.data![index]!
                                                  .subject_coupon ??
                                              0,
                                          subject_code: snapShot
                                                  .data![index]!.subject_code ??
                                              0));
                                    }
                                  } else {
                                    Get.nestedKey(1)!.currentState!.pushNamed(
                                          '/notAmember',
                                        );
                                  }
                                },
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Get.theme.primaryColor,
                                ))
                            : const SizedBox()
                        : textController.pref!.getInt('subjectYearID') ==
                                (snapShot.data![index]!.yearId)
                            ? textController.pref!.getString('chapter') ==
                                    snapShot.data![index]!.term!
                                ? CustomOption(
                                    has_unloacked:
                                        snapShot.data![index]!.hasUnloackedSub,
                                    openSubject:
                                        snapShot.data![index]!.open_subject,
                                    hasData: snapShot.data![index]!.has_data,
                                    id: snapShot.data![index]!.id,
                                    subtTtle:
                                        snapShot.data![index]!.subjectNotes ??
                                            '',
                                    txt: snapShot.data![index]!.subjectName ??
                                        '',
                                    func: () async {
                                      subjectController
                                              .questionsLanguage!.value =
                                          snapShot.data![index]!.language ??
                                              'عربي';
                                      if (snapShot
                                          .data![index]!.open_subject!) {
                                        if (snapShot.data![index]!.has_data!) {
                                          await subjectController
                                              .checkSubscription(
                                                  snapShot.data![index]!);
                                        } else {
                                          InvokeWaitingDialog(context);
                                          await QuestionDataSource.instance
                                              .getAllUserQuestionsForSubject(
                                                  snapShot.data![index]!.id);
                                          await WrongAnswerDataSource.instace
                                              .getWrongAnswersForSubject(
                                                  snapShot.data![index]!.id!);
                                          await BackgroundDataSource.instance
                                              .getSubjectFavorites(
                                                  snapShot.data![index]!.id!);
                                          snapShot.data![index]!.has_data =
                                              true;
                                          subjectController.update();
                                          Get.back();
                                        }
                                      } else if (snapShot
                                          .data![index]!.hasUnloackedSub!) {
                                        Get.nestedKey(1)!
                                            .currentState!
                                            .pushNamed('/SubSubjects',
                                                arguments: {
                                              'id': snapShot.data![index]!.id!,
                                              'subject_name': snapShot
                                                  .data![index]!.subjectName!,
                                              'isLocked': !snapShot
                                                  .data![index]!.open_subject!
                                            });
                                        List<IndexedSubject?>? a =
                                            await getIndexedSubject(
                                                snapShot.data![index]!.id!);
                                        if (a != null) {
                                          updateIndex(IndexedSubject(
                                              open_subject: snapShot
                                                  .data![index]!.open_subject,
                                              has_data: snapShot
                                                  .data![index]!.has_data,
                                              hasUnloackedSub: snapShot
                                                  .data![index]!
                                                  .hasUnloackedSub,
                                              subject_coupon: snapShot
                                                  .data![index]!.subject_coupon,
                                              id: snapShot.data![index]!.id,
                                              language: snapShot
                                                  .data![index]!.language,
                                              subjectName: snapShot
                                                  .data![index]!.subjectName,
                                              subject_code: snapShot
                                                  .data![index]!.subject_code));
                                        } else {
                                          var indexedLentgh =
                                              await getIndexedSubjects();
                                          insertIndexed(
                                              snapShot.data![index]!,
                                              indexedLentgh == null
                                                  ? 0
                                                  : indexedLentgh!.length);
                                          updateIndex(IndexedSubject(
                                              open_subject: snapShot
                                                  .data![index]!.open_subject,
                                              has_data: snapShot
                                                  .data![index]!.has_data,
                                              hasUnloackedSub: snapShot
                                                  .data![index]!
                                                  .hasUnloackedSub,
                                              id: snapShot.data![index]!.id,
                                              language: snapShot
                                                  .data![index]!.language,
                                              subjectName: snapShot
                                                  .data![index]!.subjectName,
                                              subject_coupon: snapShot
                                                      .data![index]!
                                                      .subject_coupon ??
                                                  0,
                                              subject_code: snapShot
                                                      .data![index]!
                                                      .subject_code ??
                                                  0));
                                        }
                                      } else {
                                        Get.nestedKey(1)!
                                            .currentState!
                                            .pushNamed(
                                              '/notAmember',
                                            );
                                      }

                                      // int numOFDisabeledcodes = 0;

                                      // List<ActiveCodesLocal>? a =
                                      //     await getActiveCodeForSubject(
                                      //         snapShot.data![index]!.id!);

                                      // if (a != null) {
                                      //   for (var valid in a) {
                                      //     List<ActiveCodesLocal>? b =
                                      //         await isValidCode(valid.id!);

                                      //     if (b != null) {
                                      //     } else {
                                      //       numOFDisabeledcodes++;
                                      //     }
                                      //   }
                                      // }
                                      // int numOFDisabeledcoupons = 0;
                                      // List<ActiveCouponsLocal>? acCoupon =
                                      //     await getActiveCouponForSubject(
                                      //         snapShot.data![index]!.id!);

                                      // if (acCoupon != null) {
                                      //   for (var validc in acCoupon) {
                                      //     List<ActiveCouponsLocal>? bcoupoun =
                                      //         await isValidCoupon(validc.id!);

                                      //     if (bcoupoun != null) {
                                      //     } else {
                                      //       numOFDisabeledcoupons++;
                                      //     }
                                      //   }
                                      //   print(
                                      //       'DDDDDDDDDDD$numOFDisabeledcoupons DDDDDDDDDDDDDDDDDDD');
                                      // }

                                      // if (snapShot.data![index]!.subject_code !=
                                      //         null &&
                                      //     snapShot.data![index]!
                                      //             .subject_coupon ==
                                      //         null) {
                                      //   if (numOFDisabeledcodes >=
                                      //       snapShot
                                      //           .data![index]!.subject_code!) {
                                      //     subjectController
                                      //         .stopAstartAnimation();
                                      //     refreshController.update();
                                      //     await Future.delayed(const Duration(
                                      //         milliseconds: 100));
                                      //     subjectController
                                      //         .stopAstartAnimation();

                                      //     Get.nestedKey(1)!
                                      //         .currentState!
                                      //         .pushNamed(
                                      //           '/notAmember',
                                      //         );
                                      //   } else {
                                      //     var indexedLentgh =
                                      //         await getIndexedSubjects();
                                      //     List<IndexedSubject?>? a =
                                      //         await getIndexedSubject(
                                      //             snapShot.data![index]!.id!);

                                      //     if (a != null) {
                                      //       updateIndex(IndexedSubject(
                                      //           id: snapShot.data![index]!.id,
                                      //           language: snapShot
                                      //               .data![index]!.language,
                                      //           subject_coupon: snapShot
                                      //               .data![index]!
                                      //               .subject_coupon,
                                      //           subjectName: snapShot
                                      //               .data![index]!.subjectName,
                                      //           subject_code: snapShot
                                      //               .data![index]!
                                      //               .subject_code));
                                      //     } else {
                                      //       insertIndexed(
                                      //           snapShot.data![index]!,
                                      //           indexedLentgh == null
                                      //               ? 0
                                      //               : indexedLentgh!.length);
                                      //       updateIndex(IndexedSubject(
                                      //           id: snapShot.data![index]!.id,
                                      //           language: snapShot
                                      //               .data![index]!.language,
                                      //           subject_coupon: snapShot
                                      //               .data![index]!
                                      //               .subject_coupon,
                                      //           subjectName: snapShot
                                      //               .data![index]!.subjectName,
                                      //           subject_code: snapShot
                                      //               .data![index]!
                                      //               .subject_code));
                                      //     }

                                      //     Get.nestedKey(1)!
                                      //         .currentState!
                                      //         .pushNamed('/SubSubjects',
                                      //             arguments: {
                                      //           'id':
                                      //               snapShot.data![index]!.id!,
                                      //           'subject_name': snapShot
                                      //               .data![index]!.subjectName!
                                      //         });
                                      //   }
                                      // } else if (snapShot
                                      //             .data![index]!.subject_code ==
                                      //         null &&
                                      //     snapShot.data![index]!
                                      //             .subject_coupon !=
                                      //         null) {
                                      //   if (numOFDisabeledcoupons >=
                                      //       snapShot.data![index]!
                                      //           .subject_coupon!) {
                                      //     subjectController
                                      //         .stopAstartAnimation();
                                      //     refreshController.update();
                                      //     await Future.delayed(const Duration(
                                      //         milliseconds: 100));
                                      //     subjectController
                                      //         .stopAstartAnimation();

                                      //     Get.nestedKey(1)!
                                      //         .currentState!
                                      //         .pushNamed(
                                      //           '/notAmember',
                                      //         );
                                      //   } else {
                                      //     var indexedLentgh =
                                      //         await getIndexedSubjects();
                                      //     List<IndexedSubject?>? a =
                                      //         await getIndexedSubject(
                                      //             snapShot.data![index]!.id!);

                                      //     if (a != null) {
                                      //       updateIndex(IndexedSubject(
                                      //           id: snapShot.data![index]!.id,
                                      //           language: snapShot
                                      //               .data![index]!.language,
                                      //           subject_coupon: snapShot
                                      //               .data![index]!
                                      //               .subject_coupon,
                                      //           subjectName: snapShot
                                      //               .data![index]!.subjectName,
                                      //           subject_code: snapShot
                                      //               .data![index]!
                                      //               .subject_code));
                                      //     } else {
                                      //       insertIndexed(
                                      //           snapShot.data![index]!,
                                      //           indexedLentgh == null
                                      //               ? 0
                                      //               : indexedLentgh!.length);
                                      //       updateIndex(IndexedSubject(
                                      //           id: snapShot.data![index]!.id,
                                      //           language: snapShot
                                      //               .data![index]!.language,
                                      //           subject_coupon: snapShot
                                      //               .data![index]!
                                      //               .subject_coupon,
                                      //           subjectName: snapShot
                                      //               .data![index]!.subjectName,
                                      //           subject_code: snapShot
                                      //               .data![index]!
                                      //               .subject_code));
                                      //     }

                                      //     Get.nestedKey(1)!
                                      //         .currentState!
                                      //         .pushNamed('/SubSubjects',
                                      //             arguments: {
                                      //           'id':
                                      //               snapShot.data![index]!.id!,
                                      //           'subject_name': snapShot
                                      //               .data![index]!.subjectName!
                                      //         });
                                      //   }
                                      // } else if (snapShot
                                      //             .data![index]!.subject_code !=
                                      //         null &&
                                      //     snapShot.data![index]!
                                      //             .subject_coupon !=
                                      //         null) {
                                      //   if (numOFDisabeledcodes >=
                                      //           snapShot.data![index]!
                                      //               .subject_code! ||
                                      //       numOFDisabeledcoupons >=
                                      //           snapShot.data![index]!
                                      //               .subject_coupon! ||
                                      //       (numOFDisabeledcodes >=
                                      //               snapShot.data![index]!
                                      //                   .subject_code! &&
                                      //           numOFDisabeledcoupons >=
                                      //               snapShot.data![index]!
                                      //                   .subject_coupon!)) {
                                      //     subjectController
                                      //         .stopAstartAnimation();
                                      //     refreshController.update();
                                      //     await Future.delayed(const Duration(
                                      //         milliseconds: 100));
                                      //     subjectController
                                      //         .stopAstartAnimation();

                                      //     Get.nestedKey(1)!
                                      //         .currentState!
                                      //         .pushNamed(
                                      //           '/notAmember',
                                      //         );
                                      //   } else {
                                      //     var indexedLentgh =
                                      //         await getIndexedSubjects();
                                      //     List<IndexedSubject?>? a =
                                      //         await getIndexedSubject(
                                      //             snapShot.data![index]!.id!);

                                      //     if (a != null) {
                                      //       updateIndex(IndexedSubject(
                                      //           id: snapShot.data![index]!.id,
                                      //           language: snapShot
                                      //               .data![index]!.language,
                                      //           subject_coupon: snapShot
                                      //               .data![index]!
                                      //               .subject_coupon,
                                      //           subjectName: snapShot
                                      //               .data![index]!.subjectName,
                                      //           subject_code: snapShot
                                      //               .data![index]!
                                      //               .subject_code));
                                      //     } else {
                                      //       insertIndexed(
                                      //           snapShot.data![index]!,
                                      //           indexedLentgh == null
                                      //               ? 0
                                      //               : indexedLentgh!.length);
                                      //       updateIndex(IndexedSubject(
                                      //           id: snapShot.data![index]!.id,
                                      //           language: snapShot
                                      //               .data![index]!.language,
                                      //           subject_coupon: snapShot
                                      //               .data![index]!
                                      //               .subject_coupon,
                                      //           subjectName: snapShot
                                      //               .data![index]!.subjectName,
                                      //           subject_code: snapShot
                                      //               .data![index]!
                                      //               .subject_code));
                                      //     }

                                      //     Get.nestedKey(1)!
                                      //         .currentState!
                                      //         .pushNamed('/SubSubjects',
                                      //             arguments: {
                                      //           'id':
                                      //               snapShot.data![index]!.id!,
                                      //           'subject_name': snapShot
                                      //               .data![index]!.subjectName!
                                      //         });
                                      //   }
                                      // } else {
                                      //   subjectController.stopAstartAnimation();
                                      //   refreshController.update();
                                      //   await Future.delayed(
                                      //       const Duration(milliseconds: 100));
                                      //   subjectController.stopAstartAnimation();

                                      //   Get.nestedKey(1)!
                                      //       .currentState!
                                      //       .pushNamed(
                                      //         '/notAmember',
                                      //       );
                                      // }
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Get.theme.primaryColor,
                                    ))
                                : const SizedBox()
                            : const SizedBox(),
                  );
                } else {
                  return Center(
                    child: Text(
                      'لا يوجد مواد',
                      style: ownStyle(Theme.of(context).primaryColor, 18.sp),
                    ),
                  );
                }
              }),
        ),
      );
    });
  }
}
