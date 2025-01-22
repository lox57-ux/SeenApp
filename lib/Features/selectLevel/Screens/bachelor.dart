import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/select_level_controller.dart';
import '../../../core/controller/text_controller.dart';
import '../../../core/constants/Colors.dart';
import '../../../core/constants/TextStyles.dart';

import 'degree.dart';

class Bachelor extends Degree {
  Bachelor({super.key});

  SelectLevelController selectLevelController = Get.find();
  TextController textController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.w),
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
            child: GetBuilder<SelectLevelController>(builder: (controller) {
              return DropdownButtonHideUnderline(
                child: InkWell(
                  onTap: () async {},
                  child: DropdownButton(
                    dropdownColor: Colors.white,
                    iconDisabledColor: SeenColors.iconColor,
                    iconEnabledColor:
                        selectLevelController.selectedBachelorSection == null
                            ? SeenColors.iconColor
                            : SeenColors.mainColor,
                    icon: const Icon(Icons.keyboard_arrow_down_sharp),
                    // underline: null,
                    hint: Text(
                      'الفرع ',
                      style: ownStyle(SeenColors.iconColor, 13.sp),
                    )
                    // underline: null,
                    ,
                    disabledHint: Text(
                      'الفرع ',
                      style: ownStyle(SeenColors.iconColor, 13.sp),
                    ),
                    items: selectLevelController.bachelorSection
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e,
                                  style: ownStyle(SeenColors.mainColor, 12.sp)),
                            ))
                        .toList(),
                    onChanged: (val) {
                      selectLevelController.setBachelorSection(val);
                    },
                    value: selectLevelController.selectedBachelorSection,
                  ),
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
            margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 10.w),
            child: GetBuilder<SelectLevelController>(builder: (controller) {
              return DropdownButtonHideUnderline(
                child: DropdownButton(
                  iconDisabledColor: SeenColors.iconColor,
                  iconEnabledColor: selectLevelController.selectedCounty == null
                      ? SeenColors.iconColor
                      : SeenColors.mainColor,
                  dropdownColor: Colors.white,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_sharp,
                  ),
                  // underline: null,
                  hint: Text(
                    'المحافظة',
                    style: ownStyle(SeenColors.iconColor, 13.sp),
                  )
                  // underline: null,
                  ,
                  disabledHint: Text(
                    'المحافظة ',
                    style: ownStyle(SeenColors.iconColor, 13.sp),
                  ),
                  items: selectLevelController.county
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e!,
                                style: ownStyle(SeenColors.mainColor, 12.sp)),
                          ))
                      .toList(),
                  onChanged: (val) {
                    selectLevelController.setCounty(val);
                  },
                  value: selectLevelController.selectedCounty,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
