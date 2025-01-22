import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../controller/select_level_controller.dart';
import '../../../core/constants/Colors.dart';
import '../../../core/constants/TextStyles.dart';

class UniversityDropDown extends StatelessWidget {
  const UniversityDropDown({
    super.key,
    required this.selectLevelController,
  });

  final SelectLevelController selectLevelController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        border: Border.all(color: SeenColors.iconColor),
        borderRadius: BorderRadius.circular(15.r),
        color: SeenColors.lightBackground,
      ),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
      child: GetBuilder<SelectLevelController>(builder: (_) {
        return DropdownButtonHideUnderline(
          child: InkWell(
            onTap: () async {
              await selectLevelController.setUniversities();
            },
            child: DropdownButton(
              iconDisabledColor: SeenColors.iconColor,
              iconEnabledColor: selectLevelController.universityId == null
                  ? SeenColors.iconColor
                  : SeenColors.mainColor,
              dropdownColor: Colors.white,
              hint: Text(
                'الجامعة',
                style: ownStyle(SeenColors.iconColor, 14.sp),
              ),
              icon: const Icon(Icons.keyboard_arrow_down_sharp),
              // underline: null,
              items: selectLevelController.universities
                  .map((e) => DropdownMenuItem(
                        value: e.id,
                        child: Text(e.universityName!,
                            style: ownStyle(SeenColors.mainColor, 12.sp)),
                      ))
                  .toList(),
              onChanged: (val) async {
                selectLevelController.setUniversity(val);
                selectLevelController.setCollageForUniversity(val!);
              },
              value: selectLevelController.universityId,
            ),
          ),
        );
      }),
    );
  }
}
