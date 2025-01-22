import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:latext/latext.dart';
import 'package:seen/core/constants/url.dart';

import '../../../core/controller/theme_controller.dart';
import '../../../core/constants/Colors.dart';
import '../../../core/constants/TextStyles.dart';

class QuestionAddition extends StatelessWidget {
  QuestionAddition({
    super.key,
    required this.questionAddition,
    required this.leading,
    required this.image,
    this.isMcq,
    this.url,
    this.isMath,
  });
  bool reloadingImage = false;

  final String? questionAddition;
  final String leading;
  final String image;
  final bool? isMcq;
  final bool? isMath;
  final String? url;
  ThemeController _themeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.w),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.w),
      width: 300.w,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
                blurRadius: 4,
                blurStyle: BlurStyle.outer,
                spreadRadius: 2,
                color: SeenColors.iconColor.withOpacity(0.5)),
          ],
          borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        children: [
          url == null
              ? const SizedBox()
              : Container(
                  margin: EdgeInsets.all(2.w),
                  clipBehavior: Clip.hardEdge,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15.r)),
                  child: StatefulBuilder(builder: (context, setstate) {
                    return reloadingImage
                        ? SizedBox()
                        : InkWell(
                            onDoubleTap: () async {
                              setstate(() {
                                reloadingImage = true;
                              });
                              await FastCachedImageConfig.deleteCachedImage(
                                  imageUrl: baseUrlForImage! + url!);
                              await Future.delayed(Duration(milliseconds: 500));

                              setstate(() {
                                reloadingImage = false;
                              });
                            },
                            child: FastCachedImage(
                                fit: BoxFit.fill,
                                width: 90.w,
                                height: 60.h,
                                url: baseUrlForImage! + url!,
                                loadingBuilder: (context, downloadProgress) =>
                                    Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress
                                              .progressPercentage.value,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                errorBuilder: (context, url, error) => Icon(
                                      Icons.error,
                                      color: Colors.grey,
                                    )),
                          );
                  }),
                ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 6.w, top: 10.h),
                child: SvgPicture.asset('assets/Qustions/$image',
                    colorFilter: ColorFilter.mode(
                        _themeController.isDarkMode.value
                            ? SeenColors.iconColor
                            : SeenColors.answerText,
                        BlendMode.srcIn)),
              ),
              Scrollbar(
                controller: ScrollController(),
                interactive: true,
                thumbVisibility: true,
                trackVisibility: true,
                thickness: 2,
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: SizedBox(
                    width: 260.w,
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: LaTexT(
                        laTeXCode: Text(
                          " ${questionAddition ?? 'لايوجد  ' + (leading == '' ? ' ' : leading.split("ال")[1])}"
                          // _lessonController
                          //     .ans![_lessonController
                          //         .mathIndex
                          //         .value]!
                          //     .tex![t]
                          ,
                          textDirection: TextDirection.rtl,
                          textAlign: isMath != null
                              ? TextAlign.center
                              : TextAlign.start,
                          style: ownStyle(
                                  _themeController.isDarkMode.value
                                      ? SeenColors.iconColor
                                      : SeenColors.answerText,
                                  15.sp)!
                              .copyWith(
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
