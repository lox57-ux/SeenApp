import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/TextStyles.dart';
import '../../functions/QuestionFunction.dart';

class ExamsLogController extends GetxController {
  int length = 0;
  Future getExams(int qID, List<Widget?>? pre, Color c, int? len) async {
    List<String?>? prev = await getAllexamsForQuestion(qID);
    if (prev!.length > 2) {
      len = 2;
    } else {
      len = prev.length;
    }

    pre!.clear();
    prev.fold([], (previousValue, element) {
      pre.add(
        Container(
          decoration: BoxDecoration(
              color: c, borderRadius: BorderRadius.circular(15.r)),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 3.w, horizontal: 8.w),
          child: Text(
            element == null ? '' : element.toString(),
            style: ownStyle(Colors.white, 12.sp),
          ),
        ),
      );

      return pre;
    });
    return pre;
  }
}
