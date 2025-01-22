import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:seen/Features/Sections/controller/subjectController/SubjectController.dart';
import 'package:seen/core/controller/theme_controller.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../shared/model/entites/Links.dart';
import '../../Sections/model/Data/SubjectDatatSource.dart';
import '../../Splash/InitialNavigationController/RefreshController.dart';
import '../controller/CodeManagingController.dart';
import '../controller/QrCodeController.dart';
import '../../../core/controller/text_controller.dart';
import '../../../core/constants/Colors.dart';
import '../../../core/constants/TextStyles.dart';

import '../../../core/functions/LinksFunction.dart';
import '../../../core/functions/localDataFunctions/UserCodefunction.dart';

import '../../introPages/Widgets/CodesWidget.dart';

import '../../introPages/Widgets/IntroPageButton.dart';
import '../Widgets/AboutDialogCustom.dart';
import '../model/data/CodeManagingDataSource.dart';

class CodeManagingScreen extends StatelessWidget {
  CodeManagingScreen({super.key});
  static const routeName = '/codeManaging';
  int? routeArgs = Get.arguments;
  QrCodeController qrCodeController = Get.find();
  CodeManagingController codeManagingController = Get.find();
  RefreshController refreshController = Get.find();
  TextController textController = Get.find();
  ThemeController themeController = Get.find();
  SubjectController subjectController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0.1.h,
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0.w),
        child: SpeedDial(
          icon: FontAwesomeIcons.add,
          activeIcon: FontAwesomeIcons.close,
          iconTheme: IconThemeData(color: Theme.of(context).cardColor),
          overlayOpacity: 0.0,
          backgroundColor: Theme.of(context).primaryColor,
          shape: const CircleBorder(),
          children: [
            speedDialCustom(
                context: context,
                data: FontAwesomeIcons.qrcode,
                function: () {
                  codeManagingController.messege.value != ''
                      ? codeManagingController.resetMessege()
                      : null;
                  showDialog(
                      context: context,
                      builder: (context) => QRView(
                            overlay: QrScannerOverlayShape(
                                borderLength: 30.w,
                                borderWidth: 10,
                                borderColor: Theme.of(context).primaryColor,
                                borderRadius: 10.r),
                            key: qrCodeController.qrKey,
                            onQRViewCreated: (controller) {
                              qrCodeController.onQRViewCreated(controller);
                            },
                          ),
                      barrierColor: Theme.of(context).cardColor);
                },
                lable: 'مسح كود'),
            speedDialCustom(
                context: context,
                img: 'assets/CodeManaging/cod.svg',
                lable: 'إضافة كود',
                data: null,
                function: () {
                  codeManagingController.isLoading.value
                      ? codeManagingController.updateLoadingState()
                      : null;
                  codeManagingController.messege.value != ''
                      ? codeManagingController.resetMessege()
                      : null;
                  // await Future.delayed(Duration(seconds: 1));
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => AboutDialogCustom(
                      send: (id) {
                        CodeManagingDataSource.instance
                            .getCodeInfo(
                                textController.codeController.text.trim())
                            .then((value) {
                          if (value == null) {
                            Get.back();
                          }
                          Get.dialog(
                              barrierDismissible: false,
                              AlertDialog(
                                  elevation: 0,
                                  backgroundColor: Theme.of(context).cardColor,
                                  surfaceTintColor: Get.theme.cardColor,
                                  shadowColor: Theme.of(context).cardColor,
                                  content: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.0.w, vertical: 5.0.w),
                                    child: value == null
                                        ? Container(
                                            clipBehavior: Clip.none,
                                            color: Colors.transparent,
                                            height: 140.h,
                                            alignment: Alignment.center,
                                            child: Text(
                                              'الكود غير موجود',
                                              textAlign: TextAlign.center,
                                              style: ownStyle(
                                                  Get.theme.primaryColor,
                                                  18.sp),
                                            ),
                                          )
                                        : Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                value == null
                                                    ? 'الكود غير موجود'
                                                    : value!.codeName!,
                                                textAlign: TextAlign.center,
                                                style: ownStyle(
                                                    Get.theme.primaryColor,
                                                    18.sp),
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                              Text(
                                                value == null
                                                    ? ''
                                                    : "صالح لغاية  ${value!.expiryTime ?? 'منتهي'} يوم "!,
                                                textAlign: TextAlign.center,
                                                style: ownStyle(
                                                    Get.theme.primaryColor,
                                                    18.sp),
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                              SizedBox(
                                                width: 200.w,
                                                child: RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(children: [
                                                    for (int j = 0;
                                                        j <
                                                            (value == null
                                                                ? 0
                                                                : value
                                                                    .subjectCode!
                                                                    .length!);
                                                        j++)
                                                      TextSpan(
                                                        text: '${value!.subjectCode![j].subject!.subjectName}' +
                                                            (j <
                                                                    value
                                                                        .subjectCode!
                                                                        .length
                                                                ? ' ، '
                                                                : ''),
                                                        style: ownStyle(
                                                            SeenColors
                                                                .answerText,
                                                            16.sp),
                                                      ),
                                                  ]),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                              (value!.codeNotes != null) &&
                                                      (value!.codeNotes!
                                                          .isNotEmpty)
                                                  ? Text(
                                                      "  ${value!.codeNotes ?? ''} "!,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: ownStyle(
                                                          SeenColors.iconColor,
                                                          16.sp),
                                                    )
                                                  : const SizedBox(),
                                              SizedBox(
                                                height: (value!.codeNotes ==
                                                            null) ||
                                                        (value!
                                                            .codeNotes!.isEmpty)
                                                    ? 0
                                                    : 15.h,
                                              ),
                                              Text(
                                                value == null
                                                    ? ""
                                                    : 'هل تريد تفعيله؟',
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
                                                      child: IntroPageButton(
                                                    fun: () {
                                                      Get.back();
                                                      Get.back();
                                                    },
                                                    txt: 'إلغاء',
                                                    color: SeenColors.iconColor,
                                                  )),
                                                  IntroPageButton(
                                                    fun: value == null
                                                        ? () {
                                                            Get.back();
                                                            Get.back();
                                                          }
                                                        : () async {
                                                            Get.back();
                                                            CodeManagingDataSource
                                                                .instance
                                                                .scanCode(
                                                                    textController
                                                                        .codeController
                                                                        .text
                                                                        .trim())
                                                                .then(
                                                                    (value2) async {
                                                              if (value2 !=
                                                                  null) {
                                                                if (value2 ==
                                                                    'done') {
                                                                  await CodeManagingDataSource
                                                                      .instance
                                                                      .getUserCode();
                                                                  await SubjectDataSource
                                                                      .instance
                                                                      .get_All_Subjects();
                                                                  await CodeManagingDataSource
                                                                      .instance
                                                                      .getActiveUserCoupon();

                                                                  subjectController
                                                                      .update();
                                                                  refreshController
                                                                      .update();
                                                                  // await CodeManagingDataSource
                                                                  //     .instance
                                                                  //     .getActiveUserCode();

                                                                  await SubjectDataSource
                                                                      .instance
                                                                      .get_AllSub_Subjects();
                                                                  // await QuestionDataSource
                                                                  //     .instance
                                                                  //     .getAllUserQuestions();
                                                                  codeManagingController
                                                                      .updateLoadingState();
                                                                  codeManagingController
                                                                          .messege
                                                                          .value =
                                                                      'تمت الإضافة بنجاح';
                                                                  refreshController
                                                                      .update();
                                                                }
                                                              }
                                                            });
                                                          },
                                                    txt: 'موافق',
                                                    color:
                                                        Get.theme.primaryColor,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                  )));

                          if (value != null && value!.id == 000) {
                            Get.back();
                          }
                        });
                      },
                      msg: "إضافة كود",
                      controller: textController.codeController,
                    ),
                  );
                }),
            speedDialCustom(
              context: context,
              lable: 'إضافة كوبون',
              data: FontAwesomeIcons.creditCard,
              function: () {
                codeManagingController.isLoading.value
                    ? codeManagingController.updateLoadingState()
                    : null;
                codeManagingController.messege.value != ''
                    ? codeManagingController.resetMessege()
                    : null;
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => AboutDialogCustom(
                          controller: textController.couponController,
                          msg: 'إضافة كوبون',
                          send: (id) {
                            CodeManagingDataSource.instance
                                .getCouponInfo(
                                    textController.couponController.text.trim())
                                .then((value) {
                              if (value == null) {
                                Get.back();
                              }

                              Get.dialog(
                                  barrierDismissible: false,
                                  AlertDialog(
                                      shadowColor: Theme.of(context).cardColor,
                                      backgroundColor:
                                          Theme.of(context).cardColor,
                                      surfaceTintColor: Get.theme.cardColor,
                                      content: value == null
                                          ? Container(
                                              clipBehavior: Clip.none,
                                              color: Colors.transparent,
                                              height: 140.h,
                                              alignment: Alignment.center,
                                              child: Text(
                                                'الكوبون غير موجود',
                                                textAlign: TextAlign.center,
                                                style: ownStyle(
                                                    Get.theme.primaryColor,
                                                    18.sp),
                                              ),
                                            )
                                          : Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  value!.couponContent!,
                                                  textAlign: TextAlign.center,
                                                  style: ownStyle(
                                                      Get.theme.primaryColor,
                                                      18.sp),
                                                ),
                                                SizedBox(
                                                  height: 15.h,
                                                ),
                                                Text(
                                                  "صالح لغاية  ${value!.expiryTime ?? 'منتهي'} يوم "!,
                                                  textAlign: TextAlign.center,
                                                  style: ownStyle(
                                                      Get.theme.primaryColor,
                                                      18.sp),
                                                ),
                                                SizedBox(
                                                  height: 15.h,
                                                ),
                                                SizedBox(
                                                  width: 200.w,
                                                  child: RichText(
                                                    textAlign: TextAlign.center,
                                                    text: TextSpan(children: [
                                                      for (int j = 0;
                                                          j <
                                                              (value == null
                                                                  ? 0
                                                                  : value
                                                                      .subjectCoupon!
                                                                      .length!);
                                                          j++)
                                                        TextSpan(
                                                          text: ' ${value.subjectCoupon![j].subject!.subjectName}' +
                                                              (j <
                                                                      value
                                                                          .subjectCoupon!
                                                                          .length
                                                                  ? ' ، '
                                                                  : ''),
                                                          style: ownStyle(
                                                              SeenColors
                                                                  .answerText,
                                                              16.sp),
                                                        ),
                                                    ]),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15.h,
                                                ),
                                                (value!.couponNotes != null) &&
                                                        (value!.couponNotes!
                                                            .isNotEmpty)
                                                    ? Text(
                                                        "  ${value!.couponNotes ?? ''} "!,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: ownStyle(
                                                            SeenColors
                                                                .iconColor,
                                                            16.sp),
                                                      )
                                                    : Divider(
                                                        height: 0.0,
                                                        color:
                                                            Colors.transparent),
                                                SizedBox(
                                                  height: (value!.couponNotes ==
                                                              null) ||
                                                          (value!.couponNotes!
                                                                  .length ==
                                                              0)
                                                      ? 0
                                                      : 15.h,
                                                ),
                                                Text(
                                                  value.couponContent == null
                                                      ? ''
                                                      : 'هل تريد تفعيله؟',
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
                                                        child: IntroPageButton(
                                                      fun: () {
                                                        Get.back();
                                                        Get.back();
                                                      },
                                                      txt: 'إلغاء',
                                                      color:
                                                          SeenColors.iconColor,
                                                    )),
                                                    IntroPageButton(
                                                      fun:
                                                          value.couponContent ==
                                                                  null
                                                              ? () {
                                                                  Get.back();
                                                                  Get.back();
                                                                }
                                                              : () async {
                                                                  Get.back();
                                                                  await CodeManagingDataSource
                                                                      .instance
                                                                      .addCoupon(
                                                                          value
                                                                              .id!)
                                                                      .then(
                                                                          (values) async {
                                                                    if (values ==
                                                                        'Done!') {
                                                                      await CodeManagingDataSource
                                                                          .instance
                                                                          .getUserCode();
                                                                      // await CodeManagingDataSource
                                                                      //     .instance
                                                                      //     .getActiveUserCode();
                                                                      await CodeManagingDataSource
                                                                          .instance
                                                                          .getActiveUserCoupon();
                                                                      await SubjectDataSource
                                                                          .instance
                                                                          .get_All_Subjects();
                                                                      refreshController
                                                                          .update();
                                                                      subjectController
                                                                          .update();
                                                                      await SubjectDataSource
                                                                          .instance
                                                                          .get_AllSub_Subjects();

                                                                      // await QuestionDataSource
                                                                      //     .instance
                                                                      //     .getAllUserQuestions();
                                                                      codeManagingController
                                                                          .updateLoadingState();
                                                                      codeManagingController
                                                                          .messege
                                                                          .value = 'تمت الإضافة بنجاح';
                                                                      refreshController
                                                                          .update();
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
                                            )));
                            });
                          },
                        ));
              },
            ),
            speedDialCustom(
                context: context,
                lable: "شراء كود عبر واتساب",
                data: FontAwesomeIcons.whatsapp,
                function: () async {
                  Links? link = await getLink('whatsapp');
                  if (link != null) {
                    final Uri _url = Uri.parse(link.url!);
                    if (!await launchUrl(_url)) {
                      throw Exception('Could not launch $_url');
                    }
                  }
                })
          ],
        ),
      ),
      // backgroundColor: SeenColors.codeManaginBackground,
      body: WillPopScope(
        onWillPop: () async {
          if (routeArgs != null) {
            Get.back();
            Get.nestedKey(1)!.currentState!.pushNamedAndRemoveUntil(
                  '/subject',
                  (route) => false,
                );
          } else {
            Get.back();
          }
          return true;
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 25.0.w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 25.0.w),
                          child: SvgPicture.asset(
                            themeController.isDarkMode.value
                                ? 'assets/CodeManaging/codeDark.svg'
                                : 'assets/CodeManaging/codeLight.svg',
                            fit: BoxFit.fitWidth,
                            width: 160.w,
                          ),
                        ),
                        Text(
                          'إدارة الأكواد',
                          textAlign: TextAlign.center,
                          style:
                              ownStyle(Theme.of(context).primaryColor, 33.sp),
                        ),
                        Text(
                          'تشمل هذه القائمة جميع الأكواد والكوبونات التي أضفتَها سابقاً',
                          textAlign: TextAlign.center,
                          style: ownStyle(Get.theme.primaryColor, 12.sp),
                        ),
                      ],
                    )),
                Card(
                  margin: EdgeInsets.only(top: 10.0.w),
                  clipBehavior: Clip.hardEdge,
                  elevation: 0,
                  child: GetBuilder<RefreshController>(builder: (_) {
                    return SizedBox(
                      height: 380.h,
                      child: FutureBuilder(
                          initialData: [],
                          future: getAllCodes(),
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      return CodesWidget(
                                        userCode: snapshot.data![index]!,
                                      );
                                    })
                                : Center(
                                    child: CircularProgressIndicator(
                                        color: Theme.of(context).primaryColor),
                                  );
                          }),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SpeedDialChild speedDialCustom(
      {required BuildContext context,
      required String lable,
      String? img,
      required IconData? data,
      required Function function}) {
    return SpeedDialChild(
        backgroundColor: Theme.of(context).primaryColor,
        child: Center(
            child: data == null
                ? SvgPicture.asset(
                    img!,
                    color: Theme.of(context).cardColor,
                  )
                : FaIcon(data, color: Theme.of(context).cardColor)),
        shape: const CircleBorder(),
        labelWidget: InkWell(
          onTap: () {
            function();
          },
          child: Container(
            margin: EdgeInsets.only(left: 15.w),
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                color: Theme.of(context).cardColor,
                boxShadow: const <BoxShadow>[
                  BoxShadow(color: SeenColors.iconColor, blurRadius: 3)
                ]),
            child: Text(lable,
                style: ownStyle(Theme.of(context).primaryColor, 15.sp)),
          ),
        ),
        onTap: () {
          function();
        });
  }
}
