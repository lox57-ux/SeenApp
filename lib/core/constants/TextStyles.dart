import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextStyle? introMsg() {
  return TextStyle(
      color: Color.fromRGBO(251, 251, 251, 1),
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Cairo');
}

TextStyle? ownStyle(Color? color, double? size) {
  return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w700,
      fontFamily: 'Cairo');
}

Size media(context) => MediaQuery.of(context).size;
