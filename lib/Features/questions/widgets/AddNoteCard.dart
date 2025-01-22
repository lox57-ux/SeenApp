import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/constants/TextStyles.dart';
import '../../introPages/Widgets/IntroPageButton.dart';

class AddNoteCard extends StatelessWidget {
  AddNoteCard(
      {super.key,
      required this.msg,
      required this.controller,
      required this.send});
  final String msg;
  final TextEditingController controller;

  final Function() send;
  @override
  Widget build(BuildContext context) {
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 220.h),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 10.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                msg,
                textAlign: TextAlign.center,
                style: ownStyle(Theme.of(context).primaryColor, 18.sp),
              ),
              SizedBox(
                height: 25.h,
              ),
              SizedBox(
                width: 250.w,
                child: TextFormField(
                  validator: (value) {
                    if (value!.length < 3) {
                      return 'عدد الحروف اقصر من اللازم';
                    }
                    return null;
                  },
                  controller: controller,
                  obscureText: false,
                  style: ownStyle(Theme.of(context).primaryColor, 10.sp),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
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
                          width: 2, color: Theme.of(context).primaryColor
                          //   color: AppColors.orange,
                          ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      borderSide: BorderSide(
                          width: 2, color: Theme.of(context).colorScheme.error
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

                    hintText: 'الملاحظة',
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                      child: IntroPageButton(
                    fun: () {
                      Get.back();
                    },
                    txt: 'إلغاء',
                    color: SeenColors.iconColor,
                  )),
                  IntroPageButton(
                    fun: () async {
                      send();
                    },
                    txt: 'موافق',
                    color: Theme.of(context).primaryColor,
                  )
                ],
              )
            ],
          ),
        ));
  }
}
