import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:seen/core/constants/TextStyles.dart';
import 'package:seen/Features/CodeManaging/Screens/CodeManagingScreen.dart';
import 'package:seen/Features/Sections/Screens/ChooseSubject.dart';
import 'package:seen/Features/selectLevel/Screens/bachelor.dart';
import 'package:seen/Features/selectLevel/Screens/preparator_year.dart';
import 'package:seen/Features/selectLevel/Screens/sixth_year.dart';
import 'package:seen/Features/selectLevel/Screens/transition_years.dart';

import '../../introPages/controller/Auth/SignUpwithGoogle.dart';
import '../controller/select_level_controller.dart';
import '../../../core/controller/text_controller.dart';
import '../../../core/constants/Colors.dart';
import '../../introPages/model/data/UsersDataSource.dart';
import '../Widgets/background.dart';
import '../../../shared/custom_text_field.dart';
import 'GenderAndPhone.dart';

class SelectLevel extends StatelessWidget {
  SelectLevel({
    super.key,
  });
  bool? isUpdate = Get.arguments;
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  static const routeName = '/selectLevel';
  TextController textController = Get.find();
  SelectLevelController selectLevelController = Get.find();

  List items = [
    'بكالوريا',
    'السنة التحضيرية',
    'السنوات الانتقالية',
    'السنة السادسة'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        onPopInvoked: (context) async {},
        child: Container(
          padding: EdgeInsets.zero,
          decoration: const BoxDecoration(
              color: SeenColors.mainColor,
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage(
                    'assets/selectLevel/seenBackground.png',
                  ))),
          child: Center(
              child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            margin: EdgeInsets.symmetric(horizontal: 35.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r), color: Colors.white),
            child: SingleChildScrollView(
              child: Form(
                key: _key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        margin: EdgeInsets.symmetric(horizontal: 35.w),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.w),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromRGBO(217, 217, 217, 1)),
                            borderRadius: BorderRadius.circular(20.r),
                            color: SeenColors.lightBackground),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircleAvatar(
                              radius: 25.r,
                              onBackgroundImageError: (exception, stackTrace) =>
                                  const Center(
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              ),
                              backgroundImage: NetworkImage(
                                textController.pref!.getString('imageUrl') ??
                                    '',
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            SizedBox(
                              width: 110.w,
                              child: Column(
                                children: [
                                  Text(
                                    "${textController.pref!.getString('Name')}" ??
                                        '',
                                    style:
                                        ownStyle(SeenColors.mainColor, 14.sp),
                                  ),
                                  GetBuilder<SelectLevelController>(
                                      builder: (context) {
                                    return Text(
                                        selectLevelController.selectType ?? '',
                                        style: ownStyle(
                                            SeenColors.iconColor, 12.sp));
                                  })
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25.w,
                    ),
                    GetBuilder<SelectLevelController>(builder: (controller) {
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: SeenColors.iconColor),
                          borderRadius: BorderRadius.circular(15.r),
                          color: SeenColors.lightBackground,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            iconDisabledColor: SeenColors.iconColor,
                            iconEnabledColor:
                                selectLevelController.selectType == null
                                    ? SeenColors.iconColor
                                    : SeenColors.mainColor,
                            dropdownColor: Colors.white,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: SeenColors.mainColor,
                            ),
                            hint: Text(
                              'المستوى التعليمي',
                              style: ownStyle(SeenColors.iconColor, 13.sp),
                            )
                            // underline: null,
                            ,
                            disabledHint: Text(
                              'المستوى التعليمي',
                              style: ownStyle(SeenColors.iconColor, 13.sp),
                            ),
                            items: items
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e,
                                          style: ownStyle(
                                              SeenColors.mainColor, 13.sp)),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              selectLevelController.setSelect(val);
                              selectLevelController.showWidget(val);
                            },
                            value: selectLevelController.selectType,
                          ),
                        ),
                      );
                    }),
                    SizedBox(
                      height: 10.w,
                    ),
                    isUpdate != null
                        ? const SizedBox()
                        : Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.w),
                            child: CustomTextField(
                              controller: textController.username,
                              hintText: 'اسم المستخدم',
                              obscureText: false,
                              isUser: true,
                              keyboardType: TextInputType.name,
                            ),
                          ),
                    GetBuilder<SelectLevelController>(builder: (controller) {
                      return selectLevelController.selectType == null
                          ? const SizedBox()
                          : Obx(() =>
                              selectLevelController.show.value == 'bachelor'
                                  ? Bachelor()
                                  : selectLevelController.show.value == 'pre'
                                      ? PreparatoryYear()
                                      : selectLevelController.show.value ==
                                              'TransitionYears'
                                          ? TransitionYears()
                                          : SixthYear());
                    }),
                    const SizedBox(
                      height: 15,
                    ),
                    Obx(() {
                      return selectLevelController.isloading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: SeenColors.mainColor),
                            )
                          : InkWell(
                              onTap: () async {
                                selectLevelController.isloading.value = true;
                                var id = textController.pref!.getInt('u_id');
                                if (isUpdate != null) {
                                  if (selectLevelController.selectType ==
                                      null) {
                                  } else {
                                    if (selectLevelController.show.value ==
                                        'bachelor') {
                                      if (selectLevelController
                                                  .selectedBachelorSection ==
                                              null ||
                                          selectLevelController
                                                  .selectedCounty ==
                                              null) {
                                        Get.snackbar('', '',
                                            backgroundColor: Colors.white,
                                            colorText: SeenColors.rightAnswer,
                                            titleText: Text(
                                              ' مهلاً.. ',
                                              style:
                                                  ownStyle(Colors.red, 18.sp),
                                            ),
                                            messageText: Text(
                                              'الرجاء إتمام البيانات',
                                              style:
                                                  ownStyle(Colors.red, 15.sp),
                                            ),
                                            duration: const Duration(
                                                milliseconds: 1300));
                                        selectLevelController.isloading.value =
                                            false;
                                      } else {
                                        await selectLevelController.saveInfo(
                                            name: textController.username.text,
                                            isUpdate: true);
                                      }
                                    } else if (selectLevelController
                                            .show.value ==
                                        'TransitionYears') {
                                      if (selectLevelController.selectedYear == null ||
                                          selectLevelController.universityId ==
                                              null ||
                                          selectLevelController.collageId ==
                                              null) {
                                        Get.snackbar('', '',
                                            backgroundColor: Colors.white,
                                            colorText: SeenColors.rightAnswer,
                                            titleText: Text(
                                              ' مهلاً.. ',
                                              style:
                                                  ownStyle(Colors.red, 18.sp),
                                            ),
                                            messageText: Text(
                                              'الرجاء إتمام البيانات',
                                              style:
                                                  ownStyle(Colors.red, 15.sp),
                                            ),
                                            duration: const Duration(
                                                milliseconds: 1300));
                                        selectLevelController.isloading.value =
                                            false;
                                      } else {
                                        await selectLevelController.saveInfo(
                                            name: textController.username.text,
                                            isUpdate: true);
                                      }
                                    } else {
                                      if (selectLevelController
                                                  .selectedGender ==
                                              null ||
                                          selectLevelController.universityId ==
                                              null) {
                                        Get.snackbar('', '',
                                            backgroundColor: Colors.white,
                                            colorText: SeenColors.rightAnswer,
                                            titleText: Text(
                                              ' مهلاً.. ',
                                              style:
                                                  ownStyle(Colors.red, 18.sp),
                                            ),
                                            messageText: Text(
                                              'الرجاء إتمام البيانات',
                                              style:
                                                  ownStyle(Colors.red, 15.sp),
                                            ),
                                            duration: const Duration(
                                                milliseconds: 1300));
                                        selectLevelController.isloading.value =
                                            false;
                                      } else {
                                        await selectLevelController.saveInfo(
                                            name: textController.username.text,
                                            isUpdate: true);
                                      }
                                    }
                                  }
                                  textController.pref!.setString(
                                      'gender',
                                      selectLevelController.selectedGender ??
                                          'male');
                                  textController.pref!.setString('phoneNumber',
                                      textController.phonController.text);
                                  selectLevelController.isloading.value = false;
                                } else {
                                  if (_key.currentState!.validate()) {
                                    if (selectLevelController.selectType ==
                                        null) {
                                      Get.snackbar('', '',
                                          backgroundColor: Colors.white,
                                          titleText: Text(
                                            ' مهلاً.. ',
                                            style: ownStyle(Colors.red, 18.sp),
                                          ),
                                          messageText: Text(
                                            ' الرجاء اختيار المستوى التعليمي',
                                            style: ownStyle(Colors.red, 15.sp),
                                          ),
                                          duration: const Duration(
                                              milliseconds: 1300));
                                      selectLevelController.isloading.value =
                                          false;
                                    } else {
                                      if (selectLevelController.show.value ==
                                          'bachelor') {
                                        if (selectLevelController
                                                    .selectedBachelorSection ==
                                                null ||
                                            selectLevelController
                                                    .selectedCounty ==
                                                null) {
                                          Get.snackbar('', '',
                                              backgroundColor: Colors.white,
                                              colorText: SeenColors.rightAnswer,
                                              titleText: Text(
                                                ' مهلاً.. ',
                                                style:
                                                    ownStyle(Colors.red, 18.sp),
                                              ),
                                              messageText: Text(
                                                'الرجاء إتمام البيانات',
                                                style:
                                                    ownStyle(Colors.red, 15.sp),
                                              ),
                                              duration: const Duration(
                                                  milliseconds: 1300));
                                          selectLevelController
                                              .isloading.value = false;
                                        } else {
                                          await selectLevelController.saveInfo(
                                            name: textController.username.text,
                                          );
                                        }
                                      } else if (selectLevelController
                                              .show.value ==
                                          'TransitionYears') {
                                        if (selectLevelController.selectedYear == null ||
                                            selectLevelController
                                                    .universityId ==
                                                null ||
                                            selectLevelController.collageId ==
                                                null) {
                                          Get.snackbar('', '',
                                              backgroundColor: Colors.white,
                                              colorText: SeenColors.rightAnswer,
                                              titleText: Text(
                                                ' مهلاً.. ',
                                                style:
                                                    ownStyle(Colors.red, 18.sp),
                                              ),
                                              messageText: Text(
                                                'الرجاء إتمام البيانات',
                                                style:
                                                    ownStyle(Colors.red, 15.sp),
                                              ),
                                              duration: const Duration(
                                                  milliseconds: 1300));
                                          selectLevelController
                                              .isloading.value = false;
                                        } else {
                                          await selectLevelController.saveInfo(
                                            name: textController.username.text,
                                          );
                                        }
                                      } else {
                                        if (selectLevelController
                                                .universityId ==
                                            null) {
                                          Get.snackbar('', '',
                                              backgroundColor: Colors.white,
                                              colorText: SeenColors.rightAnswer,
                                              titleText: Text(
                                                ' مهلاً.. ',
                                                style:
                                                    ownStyle(Colors.red, 18.sp),
                                              ),
                                              messageText: Text(
                                                'الرجاء إتمام البيانات',
                                                style:
                                                    ownStyle(Colors.red, 15.sp),
                                              ),
                                              duration: const Duration(
                                                  milliseconds: 1300));
                                          selectLevelController
                                              .isloading.value = false;
                                        } else {
                                          await selectLevelController.saveInfo(
                                            name: textController.username.text,
                                          );
                                        }
                                      }
                                    }
                                  } else {
                                    selectLevelController.isloading.value =
                                        false;
                                  }
                                }
                              },
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Image.asset(
                                    'assets/selectLevel/continue_button.png',
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                  )),
                            );
                    }),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            ),
          )),
        ),
      ),
    );
  }
}
