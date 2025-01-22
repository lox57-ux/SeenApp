import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/constants/TextStyles.dart';
import 'IntroPageButton.dart';
import 'SighnUpwithGoogleCard.dart';

class PageDesighn extends StatelessWidget {
  const PageDesighn({
    super.key,
    required PageController pageController,
    required this.img,
    required this.background,
    required this.msg,
    required this.arrow,
  }) : _pageController = pageController;
  PageDesighn.continueWithGoogle({
    super.key,
    required PageController pageController,
    required this.img,
    required this.background,
    this.msg,
    this.arrow,
  }) : _pageController = pageController;
  final PageController _pageController;
  final String img;
  final String background;
  final String? msg;
  final bool? arrow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: media(context).height,
          padding:
              msg == null ? EdgeInsets.only(bottom: 3.8.h) : EdgeInsets.zero,
          decoration: const BoxDecoration(
            color: SeenColors.mainColor,
          ),
          child: Stack(
            fit: StackFit.loose,
            alignment: AlignmentDirectional.center,
            children: [
              Positioned.fill(
                  child: SvgPicture.asset(
                'assets/Splash&intro/$background',
                fit: BoxFit.fitWidth,
              )),
              Positioned(
                top: 165.h,
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/Splash&intro/$img',
                      fit: BoxFit.fitWidth,
                      width: 145.w,
                    ),

                    // msg == null
                    //     ? const SizedBox()
                    //     : Padding(
                    //         padding: EdgeInsets.only(
                    //             // left: 24,
                    //             // right: 24,
                    //             bottom: 30.h,
                    //             top: media(context).height * 0.1),
                    //         child: SizedBox(
                    //             // color: Colors.red.withOpacity(.4),
                    //             child: SmoothPageIndicator(
                    //           controller: _pageController,
                    //           count: 3,
                    //           effect: CustomizableEffect(
                    //             activeDotDecoration: DotDecoration(
                    //               width: 10.w,
                    //               height: 10.w,
                    //               color: Colors.white,
                    //               borderRadius: BorderRadius.circular(24.r),
                    //               dotBorder: DotBorder(
                    //                 padding: 5.w,
                    //                 width: 2.w,
                    //                 color: Colors.white,
                    //               ),
                    //             ),
                    //             dotDecoration: DotDecoration(
                    //               width: 10.w,
                    //               height: 10.w,
                    //               color: Colors.white,
                    //               borderRadius: BorderRadius.circular(16.r),
                    //               verticalOffset: 0,
                    //             ),
                    //             spacing: 6.0.w,
                    //             // activeColorOverride: (i) => colors[i],
                    //           ),
                    //         ))),
                    msg == null
                        ? SizedBox(
                            height: 20.w,
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              msg == null
                  ? Positioned(bottom: 0, child: SighnUpwithGoogleCard())
                  : arrow!
                      ? Positioned(
                          bottom: 200.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                msg!,
                                textAlign: TextAlign.center,
                                style: introMsg()!.copyWith(fontSize: 20.sp),
                              ),
                              const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )
                      : Positioned(
                          bottom: 190.h,
                          child: SizedBox(
                            width: 300.w,
                            child: Text(
                              textAlign: TextAlign.center,
                              msg!,
                              maxLines: 2,
                              style: introMsg(),
                            ),
                          ),
                        )
            ],
          )),
    );
  }
}
