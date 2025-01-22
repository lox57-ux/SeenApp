import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seen/core/constants/Colors.dart';

import '../core/constants/TextStyles.dart';

class CustomizedButton extends StatelessWidget {
  const CustomizedButton(
      {super.key,
      required this.txt,
      required this.color,
      required this.fun,
      required this.width,
      required this.codeBack,
      required this.isCode});
  final String txt;

  final double width;
  final bool codeBack;
  final bool isCode;

  final Color color;
  final Function() fun;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15.r),
      onTap: fun,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: codeBack
              ? isCode
                  ? Theme.of(context).primaryColor.withOpacity(0.9)
                  : SeenColors.iconColor.withOpacity(0.5)
              : Theme.of(context).primaryColor.withOpacity(0.7),
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 4, left: 2, right: 2, top: 2),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: codeBack
                ? Theme.of(context).cardColor
                : Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          height: media(context).width * 0.13,
          alignment: Alignment.center,
          width: width,
          child: Text(
            txt,
            style: introMsg()!.copyWith(
              fontSize: 15.sp,
              color: codeBack
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).cardColor,
            ),
          ),
        ),
      ),
    );
  }
}
