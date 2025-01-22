import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/constants/TextStyles.dart';

import '../../../shared/CustomizedButton.dart';
import '../controller/CodeManagingController.dart';

class AboutDialogCustom extends StatelessWidget {
  AboutDialogCustom({
    super.key,
    required this.msg,
    required this.controller,
    required this.send,
  });
  final String msg;
  final TextEditingController controller;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Function(int id) send;
  CodeManagingController codeManagingController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return codeManagingController.messege.value == ''
          ? codeManagingController.isLoading.value
              ? AlertDialog(
                  backgroundColor: Get.theme.cardColor,
                  surfaceTintColor: Get.theme.cardColor,
                  content: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'يُرجى عدم الخروج من التطبيق حتى انتهاء عملية الإضافة ',
                          textAlign: TextAlign.center,
                          style:
                              ownStyle(Theme.of(context).primaryColor, 12.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          '**قد تستغرق بعض الوقت على اتصالات الانترنت الضعيفة',
                          textAlign: TextAlign.center,
                          style: ownStyle(SeenColors.iconColor, 10.sp),
                        ),
                      ],
                    ),
                  ),
                )
              : AlertDialog(
                  backgroundColor: Get.theme.cardColor,
                  surfaceTintColor: Get.theme.cardColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r)),
                  content: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 5.0.w, vertical: 5.0.w),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            msg,
                            textAlign: TextAlign.center,
                            style:
                                ownStyle(Theme.of(context).primaryColor, 19.sp),
                          ),
                          SizedBox(
                            height: 14.h,
                          ),
                          SizedBox(
                            width: 300.w,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.length < 3) {
                                  return 'عدد الحروف اقصر من اللازم';
                                }
                                return null;
                              },
                              controller: controller,
                              obscureText: false,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              ],
                              style: ownStyle(
                                  Theme.of(context).primaryColor, 14.sp),
                              decoration: InputDecoration(
                                errorStyle:
                                    const TextStyle(fontFamily: 'Almarai'),
                                hintStyle: TextStyle(
                                    fontSize: 16.sp,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                                filled: true,
                                //   focusColor: AppColors.orange,

                                fillColor: Theme.of(context).cardColor,
                                //  iconColor: AppColors.orange,
                                //  labelStyle: TextStyle(color: AppColors.orange),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: Theme.of(context).primaryColor
                                      //   color: AppColors.orange,
                                      ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: Theme.of(context).colorScheme.error
                                      //   color: AppColors.orange,
                                      ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2,
                                  ),
                                ),

                                hintText: " ال${msg.split(' ')[1]}",
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CustomizedButton(
                                isCode: false,
                                codeBack: true,
                                color: Colors.grey,
                                txt: 'إلغاء',
                                fun: () {
                                  Get.back();
                                },
                                width: 100.w,
                              ),
                              CustomizedButton(
                                isCode: true,
                                codeBack: true,
                                color: Get.theme.primaryColor,
                                txt: 'موافق',
                                fun: () async {
                                  if (formKey.currentState!.validate()) {
                                    send(1);
                                  }
                                },
                                width: 100.w,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ))
          : AlertDialog(
              shadowColor: Theme.of(context).cardColor,
              backgroundColor: Get.theme.cardColor,
              surfaceTintColor: Get.theme.cardColor,
              content: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        codeManagingController.icon,
                        size: 40.w,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(
                        height: 40.w,
                      ),
                      Text(
                        codeManagingController.messege.value,
                        textAlign: TextAlign.center,
                        style: ownStyle(Theme.of(context).primaryColor, 18.sp),
                      )
                    ]),
              ),
            );
    });
  }
}
