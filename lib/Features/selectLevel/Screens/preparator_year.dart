import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/select_level_controller.dart';
import '../../../core/controller/text_controller.dart';
import '../../../core/constants/Colors.dart';
import '../../../core/constants/TextStyles.dart';
import '../../../shared/custom_text_field.dart';
import '../Widgets/UniversityDropDown.dart';
import 'degree.dart';

class PreparatoryYear extends Degree {
  PreparatoryYear({super.key});

  TextController textController = Get.find();
  SelectLevelController selectLevelController = Get.find();
  @override
  Widget build(BuildContext context) {
    return UniversityDropDown(
      selectLevelController: selectLevelController,
    );
  }
}
