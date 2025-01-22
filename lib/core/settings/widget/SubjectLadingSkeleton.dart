import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:seen/core/constants/TextStyles.dart';

import '../../controller/text_controller.dart';
import 'loadingEffict.dart';

class SubjectLoadingSkeleton extends StatelessWidget {
  SubjectLoadingSkeleton({
    super.key,
  });
  TextController textController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0.h),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Skeleton.circular(width: 60.w, height: 55.w),
                        Skeleton.rectangular(width: 110.w, height: 40.w),
                        Skeleton.circular(width: 30.w, height: 40.w),
                        Skeleton.circular(width: 30.w, height: 40.w),
                        Skeleton.circular(width: 30.w, height: 40.w),
                      ]),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Center(
                    child: SizedBox(
                      width: 280.w,
                      child: Text(
                        "الرجاء الانتظار لحين الانتهاء من تحميل بياناتك",
                        textAlign: TextAlign.center,
                        style: ownStyle(Theme.of(context).primaryColor, 16.sp),
                      ),
                    ),
                  )),
              Expanded(
                flex: 15,
                // height: MediaQuery.sizeOf(context).height * 0.7,
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(3),
                    itemCount: 8,
                    itemExtent: 80.h,
                    itemBuilder: (context, index) {
                      return Directionality(
                        textDirection: TextDirection.ltr,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Skeleton.circular(
                                        width: 30.w, height: 30.w),
                                    Column(
                                      children: [
                                        Skeleton.rectangular(
                                            width: 230.w, height: 15.w),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Skeleton.rectangular(
                                            width: 230.w, height: 8.w),
                                      ],
                                    ),
                                  ]),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.only(right: 30.0.w, left: 15.w),
                            //   child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //       children: [
                            //         Skeleton.circular(width: 20.w, height: 20.w),
                            //         Skeleton.rectangular(
                            //             width: 190.w, height: 15.w),
                            //       ]),
                            // ),
                            // Padding(
                            //   padding: EdgeInsets.only(right: 30.0.w, left: 15.w),
                            //   child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //       children: [
                            //         Skeleton.circular(width: 20.w, height: 20.w),
                            //         Skeleton.rectangular(
                            //             width: 190.w, height: 15.w),
                            //       ]),
                            // ),
                            // Padding(
                            //   padding: EdgeInsets.only(right: 30.0.w, left: 15.w),
                            //   child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //       children: [
                            //         Skeleton.circular(width: 20.w, height: 20.w),
                            //         Skeleton.rectangular(
                            //             width: 190.w, height: 15.w),
                            //       ]),
                            // ),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
