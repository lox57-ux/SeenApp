import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:seen/core/constants/Colors.dart';

import '../../constants/TextStyles.dart';
import '../../functions/LinksFunction.dart';

class CommonQuestions extends StatelessWidget {
  const CommonQuestions({super.key});
  static const routeName = '/commonQuestions';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
            color: Theme.of(context).primaryColor,
            size: 25.sp,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        titleSpacing: 1.w,
        title: Text(
          'الأسئلة الشائعة',
          textAlign: TextAlign.start,
          style: introMsg()!
              .copyWith(color: Theme.of(context).primaryColor, fontSize: 19.sp),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(10.0.w),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: FutureBuilder(
            future: getLink('commonQ'),
            builder: (context, state) {
              return state.hasData
                  ? SizedBox(
                      width: media(context).width * 0.95,
                      child: Text(
                        '${state.data == null ? '' : state.data!.url!}\n',
                        style: ownStyle(SeenColors.iconColor, 16.sp),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.start,
                      ),
                    )
                  : SizedBox(
                      width: media(context).width * 0.95,
                      height: media(context).height * 0.8,
                      child: Center(
                        child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor),
                      ),
                    );
            },
          ),
        ),
      )),
    );
  }
}
