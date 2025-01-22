import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:seen/core/constants/Colors.dart';
import 'package:seen/core/constants/TextStyles.dart';

import 'package:seen/Features/introPages/Widgets/IntroPageButton.dart';

import '../../Sections/model/Data/SubjectDatatSource.dart';
import '../../Splash/InitialNavigationController/RefreshController.dart';
import '../../questions/model/data/QuestionsDataSource.dart';
import '../Widgets/AboutDialouCustomWithoutForm.dart';
import '../model/data/CodeManagingDataSource.dart';
import 'CodeManagingController.dart';

class QrCodeController extends GetxController {
  RefreshController refreshController = Get.find();
  CodeManagingController codeManagingController = Get.find();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  onQRViewCreated(QRViewController controller) async {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      result = scanData;
      print(
          '############################# ${result!.code!} #################################');

      if (result != null) {
        controller.pauseCamera();
        Get.back();

        Get.dialog(AboutDialouCustomWithoutForm());

        CodeManagingDataSource.instance
            .getCodeInfo(result!.code!)
            .then((value) {
          Get.dialog(AlertDialog(
              backgroundColor: Get.theme.cardColor,
              surfaceTintColor: Get.theme.cardColor,

              //  margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 230.h),
              content: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 5.0.w),
                child: value == null
                    ? Container(
                        clipBehavior: Clip.none,
                        color: Colors.transparent,
                        height: 145.h,
                        alignment: Alignment.center,
                        child: Text(
                          'الكود غير موجود',
                          textAlign: TextAlign.center,
                          style: ownStyle(Get.theme.primaryColor, 18.sp),
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            value!.codeName!,
                            textAlign: TextAlign.center,
                            style: ownStyle(Get.theme.primaryColor, 18.sp),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Text(
                            value == null
                                ? ''
                                : "صالح لغاية  ${value!.expiryTime ?? 'منتهي'}يوم"!,
                            textAlign: TextAlign.center,
                            style: ownStyle(Get.theme.primaryColor, 18.sp),
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
                                            : value.subjectCode!.length!);
                                    j++)
                                  TextSpan(
                                    text:
                                        '${value.subjectCode![j].subject!.subjectName} , ',
                                    style:
                                        ownStyle(SeenColors.answerText, 16.sp),
                                  ),
                              ]),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          value!.codeNotes != null
                              ? Text(
                                  "  ${value.codeNotes} "!,
                                  textAlign: TextAlign.center,
                                  style: ownStyle(SeenColors.iconColor, 16.sp),
                                )
                              : const SizedBox(),
                          SizedBox(
                            height: value!.codeNotes == null ? 0 : 15.h,
                          ),
                          Text(
                            'هل تريد تفعيله؟',
                            textAlign: TextAlign.center,
                            style: ownStyle(Get.theme.primaryColor, 18.sp),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                  child: IntroPageButton(
                                fun: () {
                                  Get.back();
                                  Get.back();
                                },
                                txt: 'الغاء',
                                color: SeenColors.iconColor,
                              )),
                              IntroPageButton(
                                fun: () async {
                                  Get.back();
                                  CodeManagingDataSource.instance
                                      .scanCode(result!.code!)
                                      .then((value) async {
                                    if (value != null) {
                                      if (value == 'done') {
                                        await CodeManagingDataSource.instance
                                            .getUserCode();
                                        refreshController.update();
                                        await SubjectDataSource.instance
                                            .get_All_Subjects();
                                        // await CodeManagingDataSource.instance
                                        //     .getActiveUserCode();
                                        await CodeManagingDataSource.instance
                                            .getActiveUserCoupon();

                                        await SubjectDataSource.instance
                                            .get_AllSub_Subjects();
                                        await QuestionDataSource.instance
                                            .getAllUserQuestions();
                                        codeManagingController
                                            .updateLoadingState();

                                        codeManagingController.messege.value =
                                            'تمت الإضافة بنجاح';
                                        refreshController.update();
                                      }
                                    }
                                  });
                                },
                                txt: 'موافق',
                                color: Get.theme.primaryColor,
                              )
                            ],
                          )
                        ],
                      ),
              )));
        });

        ;
      }
    });
  }

  @override
  void onClose() {
    // controller?.dispose();
    super.onClose();
  }
}
