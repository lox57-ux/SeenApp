import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/Auth/SignUpwithGoogle.dart';
import '../../../core/constants/Colors.dart';
import '../../../core/constants/TextStyles.dart';
import '../Widgets/IntroPageButton.dart';
import '../Widgets/PageViewDesighn.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/constants/Colors.dart';
import '../Widgets/SighnUpwithGoogleCard.dart';

class IntroLanding extends StatefulWidget {
  const IntroLanding({super.key});

  @override
  State<IntroLanding> createState() => _IntroLandingState();
}

class _IntroLandingState extends State<IntroLanding> {
  late int selectedPage;
  late final PageController _pageController;

  @override
  void initState() {
    selectedPage = 0;
    _pageController = PageController(initialPage: selectedPage);

    super.initState();
  }

  int isSighn = 0;
  int pageCount = 3;
  GoogleSignUpController _googleSignUpController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        backgroundColor: SeenColors.mainColor,
        body: WillPopScope(
          onWillPop: () async {
            _googleSignUpController.isopeningSign.value =
                !_googleSignUpController.isopeningSign.value;
            return false;
          },
          child: Stack(
            fit: StackFit.loose,
            clipBehavior: Clip.hardEdge,
            alignment: AlignmentDirectional.center,
            children: [
              PageView(
                onPageChanged: (value) {
                  isSighn = value;
                  setState(() {});
                },
                controller: _pageController,
                clipBehavior: Clip.none,
                children: [
                  PageDesighn(
                    arrow: true,
                    msg: ' اسحب للمتابعة',
                    background: '1Seen.svg',
                    img: 'SeenLight.svg',
                    pageController: _pageController,
                  ),
                  PageDesighn(
                    arrow: false,
                    msg: 'أنشئ اختبارات عشوائية تناسب طلبك',
                    pageController: _pageController,
                    background: '2Seen.svg',
                    img: 'shuffleLight.svg',
                  ),
                  PageDesighn(
                    arrow: false,
                    msg: "حساب واحد لحفظ جميع بياناتك",
                    pageController: _pageController,
                    background: '4Seen.svg',
                    img: 'profile.svg',
                  ),
                  SizedBox(
                    height: 500.h,
                    child: PageDesighn.continueWithGoogle(
                      background: '3Seen.svg',
                      img: 'SeenLight.svg',
                      pageController: _pageController,
                    ),
                  ),
                ],
              ),
              isSighn == 3.0
                  ? SizedBox()
                  : Positioned(
                      bottom: 120,
                      child: SizedBox(
                          // color: Colors.red.withOpacity(.4),
                          child: SmoothPageIndicator(
                        controller: _pageController,
                        count: 3,
                        effect: CustomizableEffect(
                          activeDotDecoration: DotDecoration(
                            width: 10.w,
                            height: 10.w,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24.r),
                            dotBorder: DotBorder(
                              padding: 5.w,
                              width: 2.w,
                              color: Colors.white,
                            ),
                          ),
                          dotDecoration: DotDecoration(
                            width: 10.w,
                            height: 10.w,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            verticalOffset: 0,
                          ),
                          spacing: 6.0.w,
                          // activeColorOverride: (i) => colors[i],
                        ),
                      )),
                    ),
              AnimatedPositioned(
                curve: Curves.linear,
                duration: const Duration(milliseconds: 500),
                bottom: isSighn == 3.0 ? -100 : 40.h,
                width: 350.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IntroPageButton(
                      isForward: true,
                      color: SeenColors.iconColor,
                      value: 1,
                      pageController: _pageController,
                      txt: 'التالي',
                    ),
                    IntroPageButton(
                      color: SeenColors.iconColor,
                      isForward: false,
                      value: 1,
                      pageController: _pageController,
                      txt: 'تخطي',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
