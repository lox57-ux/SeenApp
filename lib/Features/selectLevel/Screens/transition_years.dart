import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:seen/Features/selectLevel/Screens/degree.dart';

import '../controller/select_level_controller.dart';
import '../../../core/controller/text_controller.dart';
import '../../../core/constants/Colors.dart';
import '../../../core/constants/TextStyles.dart';
import '../../../shared/custom_text_field.dart';
import '../Widgets/UniversityDropDown.dart';

class TransitionYears extends Degree {
  TransitionYears({super.key});
  SelectLevelController selectLevelController = Get.find();
  TextController textController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 5.w,
        ),
        UniversityDropDown(selectLevelController: selectLevelController),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: BoxDecoration(
            border: Border.all(color: SeenColors.iconColor),
            borderRadius: BorderRadius.circular(15.r),
            color: SeenColors.lightBackground,
          ),
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.w),
          child: GetBuilder<SelectLevelController>(builder: (_) {
            return DropdownButtonHideUnderline(
              child: DropdownButton(
                iconDisabledColor: SeenColors.iconColor,
                iconEnabledColor: selectLevelController.collageId == null
                    ? SeenColors.iconColor
                    : SeenColors.mainColor,
                dropdownColor: Colors.white,
                hint: Text(
                  'الكلية',
                  style: ownStyle(SeenColors.iconColor, 14.sp),
                ),
                icon: const Icon(Icons.keyboard_arrow_down_sharp),
                // underline: null,
                items: selectLevelController.collages
                    .map((e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(e.collageName!,
                              style: ownStyle(SeenColors.mainColor, 12.sp)),
                        ))
                    .toList(),
                onChanged: (val) {
                  selectLevelController.setYeasrForCollage(val!);
                  selectLevelController.setCollage(val);
                },
                value: selectLevelController.collageId,
              ),
            );
          }),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: BoxDecoration(
            border: Border.all(color: SeenColors.iconColor),
            borderRadius: BorderRadius.circular(15.r),
            color: SeenColors.lightBackground,
          ),
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.w),
          child: GetBuilder<SelectLevelController>(builder: (_) {
            return DropdownButtonHideUnderline(
              child: DropdownButton(
                iconDisabledColor: SeenColors.iconColor,
                iconEnabledColor: selectLevelController.selectedYear == null
                    ? SeenColors.iconColor
                    : SeenColors.mainColor,
                dropdownColor: Colors.white,
                hint: Text(
                  'السنة',
                  style: ownStyle(SeenColors.iconColor, 14.sp),
                ),
                icon: const Icon(Icons.keyboard_arrow_down_sharp),
                // underline: null,
                items: selectLevelController.years
                    .map((e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(e.yearName ?? '',
                              style: ownStyle(SeenColors.mainColor, 12.sp)),
                        ))
                    .toList(),
                onChanged: (val) {
                  selectLevelController.setYear(val);
                },
                value: selectLevelController.selectedYear,
              ),
            );
          }),
        ),
      ],
    );
  }
}
