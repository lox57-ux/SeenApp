import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'loadingEffict.dart';

class SkeletonList extends StatelessWidget {
  const SkeletonList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Skeleton.rectangular(width: 80.w, height: 35.w),
                  Skeleton.circular(width: 30.w, height: 40.w),
                  Skeleton.circular(width: 30.w, height: 40.w),
                  Skeleton.circular(width: 30.w, height: 40.w),
                  Skeleton.circular(width: 30.w, height: 40.w),
                  Skeleton.rectangular(width: 80.w, height: 35.w),
                ]),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.8,
            child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(3),
                itemCount: 4,
                itemExtent: 140.h,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Skeleton.rectangular(width: 25.w, height: 8.w),
                              Skeleton.rectangular(width: 230.w, height: 15.w),
                            ]),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 30.0.w, left: 15.w),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Skeleton.circular(width: 20.w, height: 20.w),
                              Skeleton.rectangular(width: 190.w, height: 15.w),
                            ]),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 30.0.w, left: 15.w),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Skeleton.circular(width: 20.w, height: 20.w),
                              Skeleton.rectangular(width: 190.w, height: 15.w),
                            ]),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 30.0.w, left: 15.w),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Skeleton.circular(width: 20.w, height: 20.w),
                              Skeleton.rectangular(width: 190.w, height: 15.w),
                            ]),
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
