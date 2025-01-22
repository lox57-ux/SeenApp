import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../core/constants/TextStyles.dart';
import '../controller/CodeManagingController.dart';

class AboutDialouCustomWithoutForm extends StatelessWidget {
  AboutDialouCustomWithoutForm({
    super.key,
  });

  CodeManagingController codeManagingController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return codeManagingController.messege.value == ''
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 200.0.h),
              child: AlertDialog(
                backgroundColor: Get.theme.cardColor,
                surfaceTintColor: Get.theme.cardColor,
                content: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0.h),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            )
          : AlertDialog(
              backgroundColor: Get.theme.cardColor,
              surfaceTintColor: Get.theme.cardColor,
              content: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.w),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        codeManagingController.icon,
                        size: 40.w,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(
                        height: 40.w,
                      ),
                      Text(
                        codeManagingController.messege.value,
                        style: ownStyle(Theme.of(context).primaryColor, 18.sp),
                      )
                    ]),
              ),
            );
    });
  }
}
