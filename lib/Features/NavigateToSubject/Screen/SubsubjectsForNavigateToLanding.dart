import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'package:seen/Features/Sections/widgets/MainHeader.dart';
import 'package:seen/Features/Sections/widgets/NotMemberWidget.dart';

import '../../Splash/InitialNavigationController/RefreshController.dart';
import '../../questions/Controller/SelectAnswerController/WrongAnswersController.dart';
import '../../Sections/controller/subjectController/SubSubjectController.dart';

import '../../Sections/Screens/ChooseSections.dart';

class SubsubjectsForNavigateToLanding extends StatelessWidget {
  SubsubjectsForNavigateToLanding({
    super.key,
    required this.data,
  });

  final WrongAnswersCotroller _wrongAnswersController =
      Get.put(WrongAnswersCotroller());
  static const routeName = '/SubsubjectsForNavigateToLanding';
  SubSubjectController subjectController = Get.put(SubSubjectController());
  RefreshController refreshController = Get.put(RefreshController());
  final Map<String, dynamic> data;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          //'/subject'
          Get.back();
          // if (!e) {
          //   Get.back();
          // }
          refreshController.update();
          return false;
        },
        child: Scaffold(
            // backgroundColor: SeenColors.lightBackground,
            body: SafeArea(
                child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              MainHeader(),
              SizedBox(
                height: 600.h,
                child: Navigator(
                  key: Get.nestedKey(2),
                  onGenerateRoute: (settings) {
                    switch (settings.name) {
                      case '/SubSubjects':
                        return GetPageRoute(
                            settings: settings,
                            transition: Transition.leftToRight,
                            transitionDuration:
                                const Duration(milliseconds: 500),
                            page: () => ChooseSections(arg: data),
                            curve: Curves.easeOutQuart);
                      case '/notAmember':
                        return GetPageRoute(
                            transition: Transition.leftToRight,
                            transitionDuration:
                                const Duration(milliseconds: 500),
                            page: () => NotMemberScreen(arg: data),
                            curve: Curves.easeOutQuart);
                      default:
                        return null;
                    }
                  },
                  initialRoute:
                      Get.arguments['isValid'] ? '/SubSubjects' : '/notAmember',
                ),
              ),
            ],
          ),
        ))));
  }
}
