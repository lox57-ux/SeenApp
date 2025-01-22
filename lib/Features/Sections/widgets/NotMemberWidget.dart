import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:seen/Features/CodeManaging/Screens/CodeManagingScreen.dart';
import 'package:seen/Features/Sections/widgets/MainHeader.dart';
import 'package:seen/Features/introPages/Widgets/IntroPageButton.dart';
import 'package:seen/shared/CustomizedButton.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/constants/TextStyles.dart';
import '../../../core/functions/LinksFunction.dart';
import '../../../shared/model/entites/Links.dart';

class NotMemberScreen extends StatelessWidget {
  NotMemberScreen({super.key, this.arg, this.isLock, this.tabController});
  static const routeName = '/NotAmember';
  var arg;
  final TabController? tabController;
  final bool? isLock;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Card(
              shadowColor: Get.theme.cardColor,
              elevation: 0,
              margin: EdgeInsets.symmetric(
                horizontal: 10.w,
              ),
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: isLock != null ? 40.w : 50.w,
                          child: IconButton(
                              onPressed: arg == null
                                  ? isLock != null
                                      ? () {
                                          if (tabController != null) {
                                            tabController!.index = 0;
                                          }
                                        }
                                      : () {
                                          Get.nestedKey(1)!
                                              .currentState!
                                              .maybePop();
                                        }
                                  : () {
                                      Get.back();
                                    },
                              icon: Icon(
                                Icons.arrow_back,
                                color: Theme.of(context).primaryColor,
                                size: 23.sp,
                                weight: 800,
                              )),
                        ),
                        SizedBox(
                          width: 240.w,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                            child: Text(
                              'المحتوى غير متاح',
                              textAlign: TextAlign.center,
                              style: ownStyle(Get.theme.primaryColor,
                                  isLock != null ? 19.sp : 23.sp),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: isLock != null ? 80.h : 100.0.h, bottom: 10.h),
                      child: SvgPicture.asset(
                        'assets/CodeManaging/lock.svg',
                        width: 120.w,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'عذراً،أنت غير مُشترك في هذا المحتوى',
                            textAlign: TextAlign.center,
                            style: ownStyle(Get.theme.primaryColor, 18.sp),
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          Text(
                            "ينبغي شراء كود وإضافته ضمن إدارة الأكواد",
                            textAlign: TextAlign.center,
                            style: ownStyle(SeenColors.iconColor, 12.sp),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0.w),
                            child: SizedBox(
                              width: 300.w,
                              height: 60.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CustomizedButton(
                                      isCode: false,
                                      codeBack: true,
                                      width: 80.w,
                                      fun: arg == null
                                          ? isLock != null
                                              ? () {
                                                  if (tabController != null) {
                                                    tabController!.index = 0;
                                                  }
                                                }
                                              : () {
                                                  Get.nestedKey(1)!
                                                      .currentState!
                                                      .maybePop();
                                                }
                                          : () => Get.back(),
                                      txt: 'رجوع',
                                      color: Theme.of(context).cardColor),
                                  CustomizedButton(
                                      isCode: false,
                                      codeBack: false,
                                      txt: 'إدارة الأكواد',
                                      color: Theme.of(context).cardColor,
                                      fun: () {
                                        Get.toNamed(
                                            CodeManagingScreen.routeName,
                                            arguments: 0);
                                        ;
                                      },
                                      width: 130.w)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 280.w,
                            height: 50.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: FaIcon(
                                    FontAwesomeIcons.whatsapp,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                TextButton(
                                  child: Text(
                                    'اضغط هنا لشراء كود عبر الواتساب',
                                    style: ownStyle(
                                            Theme.of(context).primaryColor,
                                            11.sp)!
                                        .copyWith(
                                            decoration:
                                                TextDecoration.underline),
                                  ),
                                  onPressed: () async {
                                    Links? link = await getLink('whatsapp');
                                    if (link != null) {
                                      final Uri _url = Uri.parse(link.url!);
                                      if (!await launchUrl(_url)) {
                                        throw Exception(
                                            'Could not launch $_url');
                                      }
                                    }
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
