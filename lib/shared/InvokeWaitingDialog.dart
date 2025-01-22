import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:seen/core/constants/Colors.dart';

import '../core/constants/TextStyles.dart';

Future<dynamic> InvokeWaitingDialog(BuildContext context) {
  return Get.dialog(
      Padding(
        padding: EdgeInsets.symmetric(vertical: 200.0.h),
        child: AlertDialog(
          backgroundColor: Get.theme.cardColor,
          surfaceTintColor: Get.theme.cardColor,
          content: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'يُرجى عدم الخروج من التطبيق حتى انتهاء عملية التحميل',
                  textAlign: TextAlign.center,
                  style: ownStyle(Theme.of(context).primaryColor, 12.sp),
                ),
                Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  '**قد تستغرق بعض الوقت على اتصالات الانترنت الضعيفة',
                  textAlign: TextAlign.center,
                  style: ownStyle(SeenColors.iconColor, 10.sp),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false);
}
