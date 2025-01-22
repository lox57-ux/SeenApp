import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:seen/core/constants/Colors.dart';
import 'package:seen/core/constants/TextStyles.dart';

class CustomTextFieldWithlabel extends StatelessWidget {
  TextEditingController controller;
  String label;
  TextInputType keyboardType;
  bool obscureText;
  IconData? data;
  Widget? icon;
  bool? isUser;
  Function()? onPresed;
  CustomTextFieldWithlabel(
      {super.key,
      this.icon,
      this.onPresed,
      this.isUser,
      this.data,
      required this.controller,
      required this.label,
      required this.keyboardType,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // readOnly: true,
      inputFormatters: isUser == null
          ? null
          : <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
            ],
      validator: (value) {
        if (keyboardType == TextInputType.phone) {
          if (value!.length < 10) {
            return 'الرجاء ادخال رقم صالح ';
          }
        }
        if (keyboardType == TextInputType.visiblePassword) {
          if (value!.length < 4) {
            return 'الرجاء ادخال كلمة مرور  صالحة ';
          }
        } else {
          if (value!.length < 3) {
            return 'الرجاء ادخال اسم صالح ';
          }
        }
        return null;
      },
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: ownStyle(Theme.of(context).primaryColor, 15.sp),
      decoration: InputDecoration(
          errorStyle: const TextStyle(fontFamily: 'Almarai'),
          suffixIcon: icon ?? Icon(
                  data,
                  color: Get.theme.primaryColor,
                ),
          filled: true,
          //   focusColor: AppColors.orange,
          fillColor: Get.theme.cardColor,
          //  iconColor: AppColors.orange,
          //  labelStyle: TextStyle(color: AppColors.orange),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: BorderSide(color: Theme.of(context).primaryColor
                //   color: AppColors.orange,
                ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(17.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17.r),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          ),
          label: Text(
            label,
            style: ownStyle(Get.theme.primaryColor.withOpacity(0.4), 12.sp),
          )),
    );
  }
}
