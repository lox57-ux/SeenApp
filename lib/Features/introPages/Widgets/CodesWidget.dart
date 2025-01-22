import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/constants/TextStyles.dart';

import '../../../core/settings/screens/settings.dart';
import '../../CodeManaging/controller/CodeManagingController.dart';
import '../../CodeManaging/model/classes/UserCodes.dart';

class CodesWidget extends StatelessWidget {
  CodesWidget({
    super.key,
    required this.userCode,
  });
  final UserCodes userCode;
  CodeManagingController codeManagingController = Get.find();
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        onExpansionChanged: (value) {
          userCode.expanded = value;
          codeManagingController.update();
        },
        childrenPadding: EdgeInsets.symmetric(vertical: 10.w),
        initiallyExpanded: userCode.expanded!,
        shape: const Border(bottom: BorderSide(color: SeenColors.iconColor)),
        collapsedShape:
            const Border(bottom: BorderSide(color: SeenColors.iconColor)),
        title: Text(userCode.codeName ?? userCode.codeContent.toString(),
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: ownStyle(Get.theme.primaryColor, 20.sp)),
        trailing: SizedBox(
          width: 30.w,
          height: 30.w,
          child: GetBuilder<CodeManagingController>(builder: (controller) {
            return SizedBox(
                width: 30.w,
                height: 30.w,
                child: RotatedBox(
                  quarterTurns: userCode.expanded! ? 1 : 2,
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
        expandedAlignment: Alignment.topRight,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Text(
                DateTime.parse(userCode.dateOfActivation!)
                            .add(Duration(days: userCode.expiryTime!))
                            .difference(DateTime.now())
                            .inDays >
                        0
                    ? '''${userCode.iscoupon! ? "كوبون" : "كود"} صالح لغاية ${DateTime.parse(userCode.dateOfActivation!).add(Duration(days: userCode.expiryTime!)).difference(DateTime.now()).inDays} يوم '''
                    : 'انتهت صلاحية ${userCode.iscoupon! ? "الكوبون" : "الكود"}',
                maxLines: 1,
                overflow: TextOverflow.fade,
                style: ownStyle(SeenColors.iconColor, 18.sp)),
          ),
        ]);
  }
}
