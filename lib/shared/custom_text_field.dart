import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seen/core/constants/Colors.dart';
import 'package:seen/core/constants/TextStyles.dart';

class CustomTextField extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  TextInputType keyboardType;
  bool obscureText;
  bool? isUser;
  CustomTextField(
      {super.key,
      this.isUser,
      required this.controller,
      required this.hintText,
      required this.keyboardType,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (hintText == 'رقم الهاتف') {
          if (value!.length < 10) {
            return 'الرجاء ادخال رقم صحيح';
          }
          return null;
        } else {
          if (value!.length < 3) {
            return 'الرجاء ادخال اسم مستخدم صحيح';
          }
          return null;
        }
      },
      inputFormatters: isUser == null
          ? null
          : <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]"))
            ],
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: ownStyle(SeenColors.iconColor, 15.sp),
      decoration: InputDecoration(
        errorStyle: const TextStyle(fontFamily: 'Almarai'),
        contentPadding: EdgeInsets.symmetric(vertical: 3.w, horizontal: 10.w),

        constraints: BoxConstraints(maxHeight: 60.w, maxWidth: 340.w),

        filled: true,
        //   focusColor: AppColors.orange,

        fillColor: SeenColors.lightBackground,
        //  iconColor: AppColors.orange,
        //  labelStyle: TextStyle(color: AppColors.orange),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(
            color: SeenColors.iconColor,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: SeenColors.iconColor,
          ),
          borderRadius: BorderRadius.circular(15.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(
            color: SeenColors.iconColor,
          ),
        ),

        hintText: hintText,
      ),
    );
  }
}
