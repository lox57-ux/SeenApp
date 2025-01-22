import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'package:seen/Features/Sections/widgets/MainHeader.dart';
import 'package:seen/Features/Sections/widgets/NotMemberWidget.dart';

import '../../CodeManaging/controller/QrCodeController.dart';

import '../../Splash/InitialNavigationController/RefreshController.dart';
import '../../questions/Controller/SelectAnswerController/WrongAnswersController.dart';
import '../../../core/controller/nameController.dart';
import '../controller/subjectController/SubSubjectController.dart';

import '../../../core/Date/NotValidDate.dart';
import '../../../core/settings/widget/SubjectLadingSkeleton.dart';
import '../widgets/SubjectScop.dart';
import 'ChooseSections.dart';

class ChooseSubject extends StatelessWidget {
  ChooseSubject({super.key, this.isNavigateToSubject});
  final bool? isNavigateToSubject;
  final WrongAnswersCotroller _wrongAnswersController =
      Get.put(WrongAnswersCotroller());
  NameController nameController = Get.put(NameController());
  static const routeName = '/chooseSubject';
  SubSubjectController subjectController = Get.put(SubSubjectController());
  RefreshController refreshController = Get.put(RefreshController());
  QrCodeController qrCodeController = Get.put(QrCodeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RefreshController>(
      builder: (controller) => refreshController.isLoading
          ? SubjectLoadingSkeleton()
          : refreshController.notValidDate ?? false
              ? NotValidDate()
              : WillPopScope(
                  onWillPop: () async {
                    //'/subject'
                    bool e = await Get.nestedKey(1)!.currentState!.maybePop();
                    if (!e) {
                      SystemNavigator.pop();
                    }
                    refreshController.update();
                    return false;
                  },
                  child: Scaffold(
                    appBar: AppBar(
                      toolbarHeight: 0.1.h,
                    ),
                    body: SafeArea(
                        child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          MainHeader(),
                          SizedBox(
                            height: 600.h,
                            child: Navigator(
                              key: Get.nestedKey(1),
                              onGenerateRoute: (settings) {
                                switch (settings.name) {
                                  case '/subject':
                                    return GetPageRoute(
                                      transition: Transition.leftToRight,
                                      transitionDuration:
                                          const Duration(milliseconds: 400),
                                      curve: Curves.easeOutQuart,
                                      page: () => SubjectsScope(),
                                    );
                                  case '/SubSubjects':
                                    return GetPageRoute(
                                        settings: settings,
                                        transition: Transition.leftToRight,
                                        transitionDuration:
                                            const Duration(milliseconds: 500),
                                        page: () => ChooseSections(
                                            arg: settings.arguments),
                                        curve: Curves.easeOutQuart);
                                  case '/notAmember':
                                    return GetPageRoute(
                                        transition: Transition.leftToRight,
                                        transitionDuration:
                                            const Duration(milliseconds: 500),
                                        page: () => NotMemberScreen(),
                                        curve: Curves.easeOutQuart);
                                  default:
                                    return null;
                                  // GetPageRoute(
                                  //     settings: settings,
                                  //     transition: Transition.leftToRight,
                                  //     transitionDuration:
                                  //         const Duration(milliseconds: 500),
                                  //     page: () => SubjectsScope(),
                                  //     curve: Curves.easeInToLinear)
                                }
                              },
                              initialRoute: '/subject',
                            ),
                          ),
                        ],
                      ),
                    )),
                  ),
                ),
    );
  }
}
