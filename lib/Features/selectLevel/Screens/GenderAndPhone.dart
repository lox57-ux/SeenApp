import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/select_level_controller.dart';
import '../../../core/controller/text_controller.dart';
import '../../../core/constants/Colors.dart';
import '../../../core/constants/TextStyles.dart';
import '../../../shared/custom_text_field.dart';

class GenderAndPhone extends StatelessWidget {
  GenderAndPhone({super.key});

  SelectLevelController selectLevelController = Get.find();
  TextController textController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20.w,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            decoration: BoxDecoration(
              border: Border.all(color: SeenColors.iconColor),
              borderRadius: BorderRadius.circular(15.r),
              color: SeenColors.lightBackground,
            ),
            margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 10.w),
            child: GetBuilder<SelectLevelController>(builder: (_) {
              return DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: Text(
                    '  الجنس',
                    style: ownStyle(SeenColors.iconColor, 13.sp),
                  )
                  // underline: null,
                  ,

                  disabledHint: Text(
                    '  الجنس',
                    style: ownStyle(SeenColors.iconColor, 13.sp),
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down_sharp),
                  // underline: null,
                  items: selectLevelController.genders
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e,
                                style: ownStyle(SeenColors.mainColor, 12.sp)),
                          ))
                      .toList(),
                  onChanged: (val) {
                    selectLevelController.setGender(val);
                  },
                  value: selectLevelController.selectedGender,
                ),
              );
            }),
          ),
          // CustomTextField(
          //     hintText: 'رقم الهاتف',
          //     controller: textController.phonController,
          //     obscureText: false,
          //     keyboardType: TextInputType.number),
        ],
      ),
    );
  }
}
