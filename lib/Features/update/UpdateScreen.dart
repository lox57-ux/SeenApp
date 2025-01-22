import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seen/core/constants/Colors.dart';
import 'package:seen/core/constants/TextStyles.dart';

class UpdateSceen extends StatelessWidget {
  const UpdateSceen({super.key});
  static const routeName = '/updateScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.1),
      ),
      extendBodyBehindAppBar: true,
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
                child: SvgPicture.asset(
              'assets/Splash&intro/2Seen.svg',
              fit: BoxFit.fitWidth,
            )),
            Positioned(
                top: 100.h,
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/Splash&intro/Group (1).svg',
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    SizedBox(
                        width: 320.w,
                        child: Text(
                          "يتوفر تحديث جديد ..الرجاء التحديث للمتابعة",
                          style: ownStyle(SeenColors.mainColor, 18.sp),
                          textAlign: TextAlign.center,
                        ))
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
