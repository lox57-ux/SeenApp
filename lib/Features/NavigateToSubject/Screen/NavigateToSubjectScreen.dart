import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../core/functions/ActiveCodeFunction.dart';
import '../../../core/functions/localDataFunctions/ActiveCoupon.dart';
import '../../../core/functions/localDataFunctions/SubjectFunctions.dart';
import '../../CodeManaging/controller/CodeManagingController.dart';

import '../../CodeManaging/model/classes/ActiveCodesLocal.dart';
import '../../CodeManaging/model/classes/ActiveCouponsLocal.dart';
import '../../CodeManaging/model/data/CodeManagingDataSource.dart';
import '../../Sections/model/Data/SubjectDatatSource.dart';
import '../../Sections/model/classes/SubSubjects.dart';
import '../../Sections/model/classes/SubjectModule.dart';
import '../../questions/model/data/QuestionsDataSource.dart';
import '../controller/NavigateToSubjectController.dart';
import '../../CodeManaging/controller/QrCodeController.dart';
import '../../selectLevel/controller/select_level_controller.dart';
import '../../../core/controller/text_controller.dart';
import '../../../core/constants/Colors.dart';
import '../../../core/constants/TextStyles.dart';

import '../../CodeManaging/Widgets/AboutDialogCustom.dart';
import '../../Sections/Screens/ChooseSubject.dart';
import '../../introPages/Widgets/IntroPageButton.dart';
import 'SubsubjectsForNavigateToLanding.dart';

class NavigateToSubject extends StatelessWidget {
  NavigateToSubject({super.key});
  TextController textController = Get.find();
  NavigateToSubjectController navigateToSubjectController =
      Get.put(NavigateToSubjectController());
  QrCodeController qrCodeController = Get.find();
  CodeManagingController codeManagingController = Get.find();
  static const routeName = '/NavigateToSubject';
  SelectLevelController selectLevelController = Get.find();
  Subject? subject;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    selectLevelController.years = [];
    return Scaffold(
        body: Container(
            padding: EdgeInsets.zero,
            decoration: const BoxDecoration(
                color: SeenColors.mainColor,
                image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage(
                      'assets/selectLevel/seenBackground.png',
                    ))),
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 35.w, vertical: 160.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Theme.of(context).cardColor),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 10.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        var id = textController.pref!.getInt('collageId');

                        selectLevelController.setYeasrForCollage(id!);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(15.r),
                          color: Theme.of(context).cardColor,
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 5.w),
                        child: GetBuilder<SelectLevelController>(builder: (_) {
                          return DropdownButtonHideUnderline(
                            child: DropdownButton(
                              dropdownColor: Theme.of(context).cardColor,
                              hint: Text(
                                'السنة',
                                style: ownStyle(SeenColors.iconColor, 14.sp),
                              ),
                              icon: const Icon(Icons.keyboard_arrow_down_sharp),
                              // underline: null,
                              items: selectLevelController.years
                                  .map((e) => DropdownMenuItem(
                                        value: e.id,
                                        child: Text(e.yearName ?? '',
                                            style: ownStyle(
                                                Theme.of(context).primaryColor,
                                                12.sp)),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                selectLevelController.setYear(val);

                                navigateToSubjectController
                                    .setSubjectForyear(val!);
                              },
                              value: selectLevelController.selectedYear,
                            ),
                          );
                        }),
                      ),
                    ),
                    InkWell(
                      // onTap: () async {
                      //   var id = textController.pref!.getInt('collageId');
                      // },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(15.r),
                          color: Theme.of(context).cardColor,
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 5.w),
                        child: GetBuilder<NavigateToSubjectController>(
                            builder: (_) {
                          return DropdownButtonHideUnderline(
                            child: DropdownButton(
                              dropdownColor: Theme.of(context).cardColor,
                              hint: Text(
                                'المواد',
                                style: ownStyle(SeenColors.iconColor, 14.sp),
                              ),
                              icon: const Icon(Icons.keyboard_arrow_down_sharp),
                              // underline: null,
                              items: navigateToSubjectController
                                  .subjectsForYear!
                                  .map((e) => DropdownMenuItem(
                                        value: e.id,
                                        child: Text(e.subjectName ?? '',
                                            style: ownStyle(
                                                Theme.of(context).primaryColor,
                                                12.sp)),
                                      ))
                                  .toList(),
                              onChanged: (val) async {
                                navigateToSubjectController.setSubject(val);
                              },
                              value:
                                  navigateToSubjectController.selectedSubject,
                            ),
                          );
                        }),
                      ),
                    ),
                    StatefulBuilder(builder: (context, setstate) {
                      return Padding(
                        padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: SeenColors.mainColor,
                              )
                            : InkWell(
                                onTap: () async {
                                  setstate(() {
                                    isLoading = true;
                                  });
                                  if (navigateToSubjectController
                                          .selectedSubject ==
                                      null) {
                                  } else {
                                    Subject? localSub = await getSubject(
                                        navigateToSubjectController
                                            .selectedSubject!);
                                    List<ActiveCodesLocal>? a =
                                        await getActiveCodeForSubject(
                                            navigateToSubjectController
                                                .selectedSubject!);
                                    List<ActiveCouponsLocal>? acCoupon =
                                        await getActiveCouponForSubject(
                                            navigateToSubjectController
                                                .selectedSubject!);
                                    int numOFDisabeledcoupons = 0;
                                    int numOFDisabeledcodes = 0;

                                    if (localSub == null) {
                                      subject = await SubjectDataSource.instance
                                          .get_Subject(
                                              navigateToSubjectController
                                                  .selectedSubject!);
                                      await insert(subject!);
                                      List<SubSubject> sublist =
                                          await SubjectDataSource.instance
                                              .get_Sub_Subjects_of_subjects(
                                                  navigateToSubjectController
                                                      .selectedSubject!);

                                      if (a != null) {
                                        for (var valid in a) {
                                          List<ActiveCodesLocal>? b =
                                              await isValidCode(valid.id!);

                                          if (b != null) {
                                          } else {
                                            numOFDisabeledcodes++;
                                          }
                                        }
                                      }
                                      if (acCoupon != null) {
                                        for (var validc in acCoupon) {
                                          List<ActiveCouponsLocal>? bcoupoun =
                                              await isValidCoupon(validc.id!);

                                          if (bcoupoun != null) {
                                          } else {
                                            numOFDisabeledcoupons++;
                                          }
                                        }
                                      }

                                      if (subject!.subject_code != null &&
                                          subject!.subject_coupon == null) {
                                        if (numOFDisabeledcodes >=
                                            subject!.subject_code!) {
                                          Get.toNamed(
                                              SubsubjectsForNavigateToLanding
                                                  .routeName,
                                              arguments: {
                                                'id': subject!.id!,
                                                'subject_name':
                                                    subject!.subjectName,
                                                'isValid': false
                                              });
                                        } else {
                                          if (sublist.isEmpty) {
                                          } else {
                                            for (var i in sublist) {
                                              QuestionDataSource.instance
                                                  .getQuestions(i.id!);
                                            }
                                          }

                                          Get.toNamed(
                                              SubsubjectsForNavigateToLanding
                                                  .routeName,
                                              arguments: {
                                                'id': subject!.id!,
                                                'subject_name':
                                                    subject!.subjectName,
                                                'isValid': true
                                              });
                                        }
                                      } else if (subject!.subject_code ==
                                              null &&
                                          subject!.subject_coupon != null) {
                                        if (numOFDisabeledcoupons >=
                                            subject!.subject_coupon!) {
                                          Get.toNamed(
                                              SubsubjectsForNavigateToLanding
                                                  .routeName,
                                              arguments: {
                                                'id': subject!.id!,
                                                'subject_name':
                                                    subject!.subjectName,
                                                'isValid': false
                                              });
                                        } else {
                                          if (sublist.isEmpty) {
                                          } else {
                                            for (var i in sublist) {
                                              QuestionDataSource.instance
                                                  .getQuestions(i.id!);
                                            }
                                          }

                                          Get.toNamed(
                                              SubsubjectsForNavigateToLanding
                                                  .routeName,
                                              arguments: {
                                                'id': subject!.id!,
                                                'subject_name':
                                                    subject!.subjectName,
                                                'isValid': true
                                              });
                                        }
                                      } else if (subject!.subject_code !=
                                              null &&
                                          subject!.subject_coupon != null) {
                                        if (numOFDisabeledcodes >=
                                                subject!.subject_code! ||
                                            numOFDisabeledcoupons >=
                                                subject!.subject_coupon! ||
                                            (numOFDisabeledcodes >=
                                                    subject!.subject_code! &&
                                                numOFDisabeledcoupons >=
                                                    subject!.subject_coupon!)) {
                                          Get.toNamed(
                                              SubsubjectsForNavigateToLanding
                                                  .routeName,
                                              arguments: {
                                                'id': subject!.id!,
                                                'subject_name':
                                                    subject!.subjectName,
                                                'isValid': false
                                              });
                                        } else {
                                          if (sublist.isEmpty) {
                                          } else {
                                            for (var i in sublist) {
                                              QuestionDataSource.instance
                                                  .getQuestions(i.id!);
                                            }
                                          }

                                          Get.toNamed(
                                              SubsubjectsForNavigateToLanding
                                                  .routeName,
                                              arguments: {
                                                'id': subject!.id!,
                                                'subject_name':
                                                    subject!.subjectName,
                                                'isValid': true
                                              });
                                        }
                                      } else {
                                        Get.toNamed(
                                            SubsubjectsForNavigateToLanding
                                                .routeName,
                                            arguments: {
                                              'id': subject!.id!,
                                              'subject_name':
                                                  subject!.subjectName,
                                              'isValid': false
                                            });
                                      }

                                      //         if (subject!.subject_code !=
                                      //     null) {

                                      // } else {
                                      //   Get.toNamed(
                                      //       SubsubjectsForNavigateToLanding
                                      //           .routeName,
                                      //       arguments: {
                                      //         'id': subject!.id!,
                                      //         'subject_name':
                                      //             subject!.subjectName,
                                      //         'isValid': false
                                      //       });
                                      // }
                                    } else {
                                      int numOFDisabeledcodes = 0;
                                      if (a != null) {
                                        for (var valid in a) {
                                          List<ActiveCodesLocal>? b =
                                              await isValidCode(valid.id!);

                                          if (b != null) {
                                          } else {
                                            numOFDisabeledcodes++;
                                          }
                                        }
                                      }

                                      if (acCoupon != null) {
                                        for (var validc in acCoupon) {
                                          List<ActiveCouponsLocal>? bcoupoun =
                                              await isValidCoupon(validc.id!);

                                          if (bcoupoun != null) {
                                          } else {
                                            numOFDisabeledcoupons++;
                                          }
                                        }
                                      }

                                      if (localSub!.subject_code != null &&
                                          localSub!.subject_coupon == null) {
                                        if (numOFDisabeledcodes >=
                                            localSub!.subject_code!) {
                                          Get.toNamed(
                                              SubsubjectsForNavigateToLanding
                                                  .routeName,
                                              arguments: {
                                                'id': localSub!.id!,
                                                'subject_name':
                                                    localSub!.subjectName,
                                                'isValid': false
                                              });
                                        } else {
                                          Get.toNamed(
                                              SubsubjectsForNavigateToLanding
                                                  .routeName,
                                              arguments: {
                                                'id': localSub!.id!,
                                                'subject_name':
                                                    localSub.subjectName,
                                                'isValid': true
                                              });
                                        }
                                      } else if (localSub!.subject_code ==
                                              null &&
                                          localSub!.subject_coupon != null) {
                                        if (numOFDisabeledcoupons >=
                                            localSub!.subject_coupon!) {
                                          Get.toNamed(
                                              SubsubjectsForNavigateToLanding
                                                  .routeName,
                                              arguments: {
                                                'id': localSub!.id!,
                                                'subject_name':
                                                    localSub!.subjectName,
                                                'isValid': false
                                              });
                                        } else {
                                          Get.toNamed(
                                              SubsubjectsForNavigateToLanding
                                                  .routeName,
                                              arguments: {
                                                'id': localSub!.id!,
                                                'subject_name':
                                                    localSub.subjectName,
                                                'isValid': true
                                              });
                                        }
                                      } else if (localSub!.subject_code !=
                                              null &&
                                          localSub!.subject_coupon != null) {
                                        if (numOFDisabeledcodes >=
                                                localSub!.subject_code! ||
                                            numOFDisabeledcoupons >=
                                                localSub!.subject_coupon! ||
                                            (numOFDisabeledcodes >=
                                                    localSub!.subject_code! &&
                                                numOFDisabeledcoupons >=
                                                    localSub!
                                                        .subject_coupon!)) {
                                          Get.toNamed(
                                              SubsubjectsForNavigateToLanding
                                                  .routeName,
                                              arguments: {
                                                'id': localSub!.id!,
                                                'subject_name':
                                                    localSub!.subjectName,
                                                'isValid': false
                                              });
                                        } else {
                                          Get.toNamed(
                                              SubsubjectsForNavigateToLanding
                                                  .routeName,
                                              arguments: {
                                                'id': localSub!.id!,
                                                'subject_name':
                                                    localSub.subjectName,
                                                'isValid': true
                                              });
                                        }
                                      } else {
                                        Get.toNamed(
                                            SubsubjectsForNavigateToLanding
                                                .routeName,
                                            arguments: {
                                              'id': localSub!.id!,
                                              'subject_name':
                                                  localSub!.subjectName,
                                              'isValid': false
                                            });
                                      }
                                    }
                                  }

                                  setstate(() {
                                    isLoading = false;
                                  });
                                  //   );
                                },
                                child: Text(
                                  'انتقل مباشرةً',
                                  style: ownStyle(
                                      Theme.of(context).primaryColor, 16.sp),
                                ),
                              ),
                      );
                    }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 60.w,
                          child: const Divider(
                            color: SeenColors.iconColor,
                          ),
                        ),
                        Text(
                          '  أو ',
                          style: ownStyle(SeenColors.iconColor, 16.sp),
                        ),
                        SizedBox(
                          width: 60.w,
                          child: const Divider(
                            color: SeenColors.iconColor,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Text(
                        'اضافة عن طريق',
                        style: ownStyle(Theme.of(context).primaryColor, 18.sp),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 50.h, vertical: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AddSubjectOption(
                            data: FontAwesomeIcons.qrcode,
                            function: () {
                              codeManagingController.messege.value != ''
                                  ? codeManagingController.resetMessege()
                                  : null;
                              showDialog(
                                  context: context,
                                  builder: (context) => SizedBox()
                                  //  QRView(
                                  //       overlay: QrScannerOverlayShape(
                                  //           borderLength: 30.w,
                                  //           borderWidth: 10,
                                  //           borderColor:
                                  //               Theme.of(context).primaryColor,
                                  //           borderRadius: 10.r),
                                  //       key: qrCodeController.qrKey,
                                  //       onQRViewCreated: (controller) {
                                  //         qrCodeController
                                  //             .onQRViewCreated(controller);
                                  // },
                                  // ),
                                  ,
                                  barrierColor: Theme.of(context).cardColor);
                            },
                          ),
                          AddSubjectOption(
                            function: () {
                              codeManagingController.isLoading.value
                                  ? codeManagingController.updateLoadingState()
                                  : null;
                              codeManagingController.messege.value != ''
                                  ? codeManagingController.resetMessege()
                                  : null;
                              showDialog(
                                context: context,
                                builder: (context) => AboutDialogCustom(
                                  send: (id) {
                                    // baseUrl = textController.couponController.text;
                                    // CodeManagingDataSource.instance
                                    //     .addCoupon(textController
                                    //         .couponController.text)
                                    //     .then((value) async {
                                    //   await CodeManagingDataSource.instance
                                    //       .getUserCode();
                                    //   //  refreshController.update();
                                    //   await SubjectDataSource.instance
                                    //       .get_AllSub_Subjects();
                                    //   await SubjectDataSource.instance
                                    //       .get_All_Subjects();
                                    //   await QuestionDataSource.instance
                                    //       .getAllUserQuestions();
                                    //   //   refreshController.update();
                                    // });
                                  },
                                  msg: " ادخال كوبون",
                                  controller: textController.couponController,
                                ),
                              );
                            },
                            data: FontAwesomeIcons.creditCard,
                          ),
                          AddSubjectOption(
                              img: 'cod.svg',
                              function: () {
                                codeManagingController.isLoading.value
                                    ? codeManagingController
                                        .updateLoadingState()
                                    : null;
                                codeManagingController.messege.value != ''
                                    ? codeManagingController.resetMessege()
                                    : null;
                                // await Future.delayed(Duration(seconds: 1));
                                showDialog(
                                  context: context,
                                  builder: (context) => AboutDialogCustom(
                                    send: (id) {
                                      CodeManagingDataSource.instance
                                          .getCodeInfo(textController
                                              .codeController.text
                                              .trim())
                                          .then((value) {
                                        Get.dialog(Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.r)),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 30.w,
                                                vertical: 230.h),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.0.w,
                                                  vertical: 5.0.w),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    value!.codeName!,
                                                    textAlign: TextAlign.center,
                                                    style: ownStyle(
                                                        Get.theme.primaryColor,
                                                        18.sp),
                                                  ),
                                                  SizedBox(
                                                    height: 15.h,
                                                  ),
                                                  Text(
                                                    'هل تريد تفعيله؟',
                                                    textAlign: TextAlign.center,
                                                    style: ownStyle(
                                                        Get.theme.primaryColor,
                                                        18.sp),
                                                  ),
                                                  SizedBox(
                                                    height: 15.h,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      InkWell(
                                                          child:
                                                              IntroPageButton(
                                                        fun: () {
                                                          Get.back();
                                                        },
                                                        txt: 'الغاء',
                                                        color: SeenColors
                                                            .iconColor,
                                                      )),
                                                      IntroPageButton(
                                                        fun: () async {
                                                          Get.back();
                                                          CodeManagingDataSource
                                                              .instance
                                                              .scanCode(
                                                                  textController
                                                                      .codeController
                                                                      .text
                                                                      .trim())
                                                              .then(
                                                                  (value) async {
                                                            if (value != null) {
                                                              if (value ==
                                                                  'done') {
                                                                // await CodeManagingDataSource
                                                                //     .instance
                                                                //     .getUserCode();
                                                                //     refreshController.update();
                                                                await SubjectDataSource
                                                                    .instance
                                                                    .get_All_Subjects();
                                                                await SubjectDataSource
                                                                    .instance
                                                                    .get_AllSub_Subjects();
                                                                await QuestionDataSource
                                                                    .instance
                                                                    .getAllUserQuestions();
                                                                //  refreshController.update();
                                                              }
                                                            }
                                                          });
                                                        },
                                                        txt: 'موافق',
                                                        color: Get
                                                            .theme.primaryColor,
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )));
                                      });
                                    },
                                    msg: " ادخال كود",
                                    controller: textController.codeController,
                                  ),
                                );
                              }),
                        ],
                      ),
                    )
                  ],
                ))));
  }
}

class AddSubjectOption extends StatelessWidget {
  const AddSubjectOption({
    super.key,
    required this.function,
    this.data,
    this.img,
  });
  final IconData? data;
  final String? img;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        function();
      },
      child: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Center(
            child: data != null
                ? FaIcon(data, color: Theme.of(context).cardColor)
                : SvgPicture.asset("assets/CodeManaging/$img",
                    color: Theme.of(context).cardColor)),
      ),
    );
  }
}
