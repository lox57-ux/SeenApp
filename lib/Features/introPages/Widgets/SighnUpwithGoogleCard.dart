import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:seen/core/controller/text_controller.dart';
import 'package:seen/core/constants/Colors.dart';
import 'package:seen/Features/introPages/Widgets/IntroPageButton.dart';
import 'package:seen/Features/selectLevel/Screens/GenderAndPhone.dart';
import 'package:seen/core/settings/widget/custon_text_field_with_labe.dart';
import 'package:seen/shared/custom_text_field.dart';

import '../controller/Auth/SignUpwithGoogle.dart';
import '../../selectLevel/controller/select_level_controller.dart';
import '../../../core/constants/TextStyles.dart';
import '../model/data/UsersDataSource.dart';
import '../../CodeManaging/Screens/CodeManagingScreen.dart';
import '../../selectLevel/Screens/select_level.dart';
import '../../../shared/KeyboardVisibilty.dart';

class SighnUpwithGoogleCard extends StatefulWidget {
  SighnUpwithGoogleCard({
    super.key,
  });

  @override
  State<SighnUpwithGoogleCard> createState() => _SighnUpwithGoogleCardState();
}

class _SighnUpwithGoogleCardState extends State<SighnUpwithGoogleCard> {
  GoogleSignUpController _googleSignUpController = Get.find();

  TextController textController = Get.find();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  SelectLevelController selectLevelController = Get.find();

  double keyHieght = 0;
  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, child, isKeyboardVisible) {
        if (isKeyboardVisible) {
          // keyHieght = 250.h;
          return CoustomChild(
              keyHieght: keyHieght,
              formKey: formKey,
              googleSignUpController: _googleSignUpController,
              textController: textController,
              selectLevelController: selectLevelController);
        } else {
          keyHieght = 10.h;
          return CoustomChild(
              keyHieght: keyHieght,
              formKey: formKey,
              googleSignUpController: _googleSignUpController,
              textController: textController,
              selectLevelController: selectLevelController);
        }
      },
      child: CoustomChild(
          keyHieght: keyHieght,
          formKey: formKey,
          googleSignUpController: _googleSignUpController,
          textController: textController,
          selectLevelController: selectLevelController),
    );
  }
}

class CoustomChild extends StatelessWidget {
  const CoustomChild({
    super.key,
    required this.keyHieght,
    required this.formKey,
    required GoogleSignUpController googleSignUpController,
    required this.textController,
    required this.selectLevelController,
  }) : _googleSignUpController = googleSignUpController;

  final double keyHieght;
  final GlobalKey<FormState> formKey;
  final GoogleSignUpController _googleSignUpController;
  final TextController textController;
  final SelectLevelController selectLevelController;

  @override
  Widget build(BuildContext context) {
    // textController.username.text = 'test';

    // textController.passWordController.text = 'test';
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 10.h),
      scrollDirection: Axis.vertical,
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Form(
            key: formKey,
            child: SizedBox(
              width: 360.w,
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 0.w, horizontal: 20.w),
                child: Obx(() {
                  return _googleSignUpController.isopeningSign.value
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15.h, horizontal: 17.w),
                          child: SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    ' تسجيل الدخول أو إنشاء حساب ',
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: introMsg()!.copyWith(
                                        fontSize: 19.sp,
                                        color: SeenColors.mainColor,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0.w, vertical: 13.h),
                                    child: Text(
                                      'يمكنك إنشاء حساب جديد أو تسجيل الدخول إلى حساب مسبق',
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: introMsg()!.copyWith(
                                          fontSize: 12.sp,
                                          color: SeenColors.iconColor),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _googleSignUpController
                                          .isopeningSign.value = false;
                                      _googleSignUpController
                                          .isGoogleSign.value = false;
                                    },
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2,
                                              color: const Color.fromARGB(
                                                      255, 89, 41, 166)
                                                  .withOpacity(0.5)),
                                          color: SeenColors.mainColor,
                                          borderRadius:
                                              BorderRadius.circular(15.r)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'إنشاء حساب جديد',
                                        textAlign: TextAlign.center,
                                        style: ownStyle(Colors.white, 17.sp),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _googleSignUpController
                                          .isopeningSign.value = false;
                                      _googleSignUpController
                                          .isGoogleSign.value = true;
                                    },
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2,
                                              color: SeenColors.iconColor),
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15.r)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'تسجيل الدخول إلى حساب مسبق',
                                        textAlign: TextAlign.center,
                                        style: ownStyle(
                                            SeenColors.iconColor, 14.sp),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                        )
                      : _googleSignUpController.isGoogleSign.value
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.h, horizontal: 17.w),
                              child: SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'واجهة تسجيل الدخول إلى حساب قديم',
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: introMsg()!.copyWith(
                                            fontSize: 19.sp,
                                            color: SeenColors.mainColor,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      // TextButton(
                                      //   style: ButtonStyle(
                                      //       visualDensity:
                                      //           VisualDensity.compact,
                                      //       padding: MaterialStateProperty.all(
                                      //           EdgeInsets.zero)),
                                      //   onPressed: () {
                                      //     _googleSignUpController
                                      //         .phoneAndpassAdded.value = false;
                                      //     _googleSignUpController
                                      //         .isGoogleSign.value = false;
                                      //   },
                                      //   child: Text(
                                      //     'اضغط هنا لإنشاء حساب جديد بدلاً من ذلك',
                                      //     maxLines: 2,
                                      //     textAlign: TextAlign.center,
                                      //     style: introMsg()!.copyWith(
                                      //         fontSize: 12.sp,
                                      //         color: SeenColors.mainColor),
                                      //   ),
                                      // ),
                                      SizedBox(
                                        height: 55.h,
                                        child: CustomTextFieldWithlabel(
                                          isUser: true,
                                          controller: textController.username,
                                          label: 'اسم المستخدم',
                                          data: Icons.person,
                                          keyboardType: TextInputType.name,
                                          obscureText: false,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      SizedBox(
                                        height: 55.h,
                                        child: Obx(() {
                                          return CustomTextFieldWithlabel(
                                            icon: IconButton(
                                                onPressed: () {
                                                  _googleSignUpController
                                                          .isObsecur.value =
                                                      !_googleSignUpController
                                                          .isObsecur.value;
                                                },
                                                icon: Icon(
                                                  _googleSignUpController
                                                          .isObsecur.value
                                                      ? FontAwesomeIcons
                                                          .eyeSlash
                                                      : Icons
                                                          .remove_red_eye_outlined,
                                                  color: Get.theme.primaryColor,
                                                )),
                                            controller: textController
                                                .passWordController,
                                            label: 'كلمة المرور',
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            obscureText: _googleSignUpController
                                                .isObsecur.value,
                                          );
                                        }),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      SizedBox(
                                        width: 150.w,
                                        height: 50.h,
                                        child: _googleSignUpController
                                                .isLoading.value
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        color: SeenColors
                                                            .mainColor),
                                              )
                                            : IntroPageButton(
                                                fun: () async {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    _googleSignUpController
                                                        .isLoading.value = true;
                                                    await _googleSignUpController
                                                        .sighnIn(
                                                            textController
                                                                .username.text
                                                                .trim()
                                                                .toLowerCase(),
                                                            textController
                                                                .passWordController
                                                                .text);
                                                    // textController.pref!.setString(
                                                    //     'gender',
                                                    //     selectLevelController
                                                    //             .selectedGender ??
                                                    //         'male');
                                                    textController.pref!
                                                        .setString(
                                                            'Name',
                                                            textController
                                                                .username.text
                                                                .trim()
                                                                .toLowerCase());
                                                  }
                                                },
                                                txt: 'تسجيل الدخول',
                                                color: SeenColors.mainColor),
                                      ),
                                    ]),
                              ),
                            )
                          : _googleSignUpController.phoneAndpassAdded.value
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15.h, horizontal: 17.w),
                                  child: SingleChildScrollView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(
                                            height: 60.h,
                                            child: CustomTextFieldWithlabel(
                                              controller:
                                                  textController.phonController,
                                              label: 'رقم الهاتف',
                                              data: Icons.phone,
                                              keyboardType: TextInputType.phone,
                                              obscureText: false,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          GenderAndPhone(),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          SizedBox(
                                            width: 150.w,
                                            height: 50.h,
                                            child:
                                                _googleSignUpController
                                                        .isLoading.value
                                                    ? const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                                color: SeenColors
                                                                    .mainColor),
                                                      )
                                                    : IntroPageButton(
                                                        fun: () async {
                                                          if (formKey
                                                                  .currentState!
                                                                  .validate() &&
                                                              selectLevelController
                                                                      .selectedGender !=
                                                                  null) {
                                                            _googleSignUpController
                                                                .isLoading
                                                                .value = true;
                                                            if (textController
                                                                    .phonController
                                                                    .text
                                                                    .startsWith(
                                                                        '09') &&
                                                                textController
                                                                        .phonController
                                                                        .text
                                                                        .length ==
                                                                    10) {
                                                              await UserDataSource
                                                                  .instance
                                                                  .updateUser(
                                                                      {
                                                                    "user_fullname":
                                                                        textController
                                                                            .username
                                                                            .text,
                                                                    "user_username":
                                                                        textController
                                                                            .username
                                                                            .text,
                                                                    "user_phonenumber":
                                                                        textController
                                                                            .phonController
                                                                            .text,
                                                                    "sex": selectLevelController.selectedGender ==
                                                                            'ذكر'
                                                                        ? 'male'
                                                                        : 'female',
                                                                    "token": textController
                                                                        .pref!
                                                                        .getString(
                                                                            'token')
                                                                  },
                                                                      textController
                                                                          .pref!
                                                                          .getInt(
                                                                              'u_id')!).then(
                                                                      (value) {
                                                                if (value !=
                                                                    null) {
                                                                  if (value ==
                                                                      'done') {
                                                                    Get.offAndToNamed(
                                                                        SelectLevel
                                                                            .routeName);
                                                                    textController
                                                                        .pref!
                                                                        .setString(
                                                                            'gender',
                                                                            selectLevelController.selectedGender ??
                                                                                'male');
                                                                    textController.pref!.setString(
                                                                        'phoneNumber',
                                                                        textController
                                                                            .phonController
                                                                            .text);
                                                                  }
                                                                } else {
                                                                  Get.snackbar(
                                                                      ' ', '',
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      titleText:
                                                                          Text(
                                                                        ' حدث خطأ',
                                                                        style: ownStyle(
                                                                            const Color.fromARGB(
                                                                                207,
                                                                                218,
                                                                                71,
                                                                                71),
                                                                            18.sp),
                                                                      ),
                                                                      messageText:
                                                                          Text(
                                                                        'الرجاء التأكد من المعلومات ',
                                                                        style: ownStyle(
                                                                            Color.fromARGB(
                                                                                207,
                                                                                218,
                                                                                71,
                                                                                71),
                                                                            18.sp),
                                                                      ),
                                                                      colorText:
                                                                          SeenColors
                                                                              .rightAnswer,
                                                                      duration: const Duration(
                                                                          milliseconds:
                                                                              3000));
                                                                }
                                                                _googleSignUpController
                                                                        .isLoading
                                                                        .value =
                                                                    false;
                                                              });
                                                            } else {
                                                              _googleSignUpController
                                                                      .isLoading
                                                                      .value =
                                                                  false;

                                                              Get.snackbar(
                                                                  'حاول مجدداً ',
                                                                  'الرجاء التأكد من صحة رقم الهاتف ',
                                                                  colorText: Colors
                                                                      .white,
                                                                  backgroundColor: Colors
                                                                      .redAccent
                                                                      .shade200,
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          1500));
                                                            }
                                                          }
                                                        },
                                                        txt: 'إنشاء حساب جديد',
                                                        color: SeenColors
                                                            .mainColor),
                                          ),
                                          TextButton(
                                            style: ButtonStyle(
                                                visualDensity:
                                                    VisualDensity.compact,
                                                padding:
                                                    MaterialStateProperty.all(
                                                        EdgeInsets.zero)),
                                            onPressed: () {
                                              _googleSignUpController
                                                  .phoneAndpassAdded
                                                  .value = false;
                                              _googleSignUpController
                                                  .isGoogleSign.value = true;
                                            },
                                            child: Text(
                                              'اضغط هنا لتسجيل الدخول بدلاً من ذلك',
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              style: introMsg()!.copyWith(
                                                  fontSize: 12.sp,
                                                  color: SeenColors.mainColor),
                                            ),
                                          )
                                        ]),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15.h, horizontal: 17.w),
                                  child: SingleChildScrollView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'واجهة إنشاء حساب جديد',
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: introMsg()!.copyWith(
                                                fontSize: 20.sp,
                                                color: SeenColors.mainColor,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          // TextButton(
                                          //   style: ButtonStyle(
                                          //       visualDensity:
                                          //           VisualDensity.compact,
                                          //       padding:
                                          //           MaterialStateProperty.all(
                                          //               EdgeInsets.zero)),
                                          //   onPressed: () {
                                          //     _googleSignUpController
                                          //         .phoneAndpassAdded
                                          //         .value = false;
                                          //     _googleSignUpController
                                          //         .isGoogleSign.value = true;
                                          //   },
                                          //   child: Text(
                                          //     'اضغط هنا لتسجيل الدخول بدلاً من ذلك',
                                          //     maxLines: 2,
                                          //     textAlign: TextAlign.center,
                                          //     style: introMsg()!.copyWith(
                                          //         fontSize: 12.sp,
                                          //         color: SeenColors.mainColor),
                                          //   ),
                                          // ),

                                          SizedBox(
                                            height: 60.h,
                                            child: CustomTextFieldWithlabel(
                                              isUser: true,
                                              data: Icons.person_2_outlined,
                                              controller:
                                                  textController.username,
                                              label: 'اسم المستخدم',
                                              keyboardType: TextInputType.text,
                                              obscureText: false,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          SizedBox(
                                            height: 60.h,
                                            child: Obx(() {
                                              return CustomTextFieldWithlabel(
                                                icon: IconButton(
                                                    onPressed: () {
                                                      _googleSignUpController
                                                              .isObsecur.value =
                                                          !_googleSignUpController
                                                              .isObsecur.value;
                                                    },
                                                    icon: Icon(
                                                      _googleSignUpController
                                                              .isObsecur.value
                                                          ? FontAwesomeIcons
                                                              .eyeSlash
                                                          : Icons
                                                              .remove_red_eye_outlined,
                                                      color: Get
                                                          .theme.primaryColor,
                                                    )),
                                                controller: textController
                                                    .passWordController,
                                                label: 'كلمة المرور',
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                obscureText:
                                                    _googleSignUpController
                                                        .isObsecur.value,
                                              );
                                            }),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Text(
                                              '*الرجاء الاحتفاظ باسم المستخدم وكلمة المرور حتى تستطيع الوصول إلى حسابك عند تغيير جهازك',
                                              textAlign: TextAlign.center,
                                              style: ownStyle(
                                                  SeenColors.iconColor, 10.sp)),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          SizedBox(
                                            width: 150.w,
                                            height: 50.h,
                                            child: _googleSignUpController
                                                    .isLoading.value
                                                ? const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                            color: SeenColors
                                                                .mainColor),
                                                  )
                                                : IntroPageButton(
                                                    fun: () async {
                                                      if (formKey.currentState!
                                                          .validate()) {
                                                        _googleSignUpController
                                                            .isLoading
                                                            .value = true;
                                                        await _googleSignUpController
                                                            .sighnUp(
                                                                textController
                                                                    .username
                                                                    .text
                                                                    .trim()
                                                                    .toLowerCase(),
                                                                '',
                                                                null,
                                                                textController
                                                                    .passWordController
                                                                    .text);
                                                        //            _googleSignUpController
                                                        // .phoneAndpassAdded
                                                        // .value = true;
                                                      }
                                                    },
                                                    txt: 'إنشاء حساب جديد',
                                                    color:
                                                        SeenColors.mainColor),
                                          ),
                                        ]),
                                  ),
                                );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
