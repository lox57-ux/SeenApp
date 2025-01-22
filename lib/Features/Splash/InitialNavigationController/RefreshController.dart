import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seen/core/functions/ExamsLogFunction.dart';
import 'package:seen/core/functions/QuestionFunction.dart';
import 'package:seen/core/functions/localDataFunctions/ActiveCoupon.dart';
import 'package:seen/core/functions/localDataFunctions/SubjectFunctions.dart';
import 'package:seen/core/functions/localDataFunctions/SubsubjectsFunction.dart';
import 'package:seen/core/functions/localDataFunctions/UserCodefunction.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/Services/Network.dart';
import '../../../core/functions/ActiveCodeFunction.dart';
import '../../../core/functions/LinksFunction.dart';

import '../../../shared/model/DataSource/BackgroundDataSource.dart';
import '../../../shared/model/DataSource/LinksDataSource.dart';
import '../../../shared/model/entites/Links.dart';
import '../../CodeManaging/controller/CodeManagingController.dart';
import '../../CodeManaging/model/classes/ActiveCodesLocal.dart';
import '../../CodeManaging/model/classes/ActiveCoupons.dart';
import '../../CodeManaging/model/classes/ActiveCouponsLocal.dart';
import '../../CodeManaging/model/classes/UserCodes.dart';
import '../../CodeManaging/model/data/CodeManagingDataSource.dart';
import '../../Sections/model/Data/SubjectDatatSource.dart';
import '../../Sections/model/classes/SubSubjects.dart';
import '../../Sections/model/classes/SubjectModule.dart';
import '../../questions/model/classes/QuestionWithAnswer.dart';
import '../../questions/model/data/QuestionsDataSource.dart';
import '../../selectLevel/controller/select_level_controller.dart';

class RefreshController extends GetxController {
  CodeManagingController codeManagingController =
      Get.put(CodeManagingController());
  late SharedPreferences pref;
  bool isLoading = false;
  bool subjectLoaded = false;
  bool subSubjectLoaded = false;
  bool linkloaded = false;
  bool codeLoaded = false;
  bool questionLoaded = false;
  bool examsLoaded = false;
  bool activeCodesLoaded = false;
  bool wrongLoaded = false;
  bool favLoaded = false;
  bool activeCouponLoaded = false;
  @override
  void onReady() async {
    pref = await SharedPreferences.getInstance();
    /* first controller to work it checks for data in local
     tables and then decide what to do  */
    if (await checkConnection()) {
      List<Subject?>? subjects = await getSubjects();
      List<SubSubject?>? subSubjects = await getSubSubjects();
      List<UserCodes?>? codes = await getAllCodes();
      List<ActiveCodesLocal?>? activeCodes = await getAllActiveCode();
      List<ActiveCouponsLocal?>? activeCoupons = await getAllActiveCoupon();
      List<Links?>? links = await getAllLinks();
      int? getAllQuestionW = await checkifTableisEmpty();
      List<int?>? fav = await getAllFavoritesQuestionID();
      int? examsLog = await checkifExaisEmpty();
      await BackgroundDataSource.instance.getChapter().then((value) async {
        /* we use this one to check if
          there is un update or the device 
         date is uncorrect or user is active in other device  */
        print(pref!.getString('time'));
        date = DateTime.parse(pref!.getString('time') ?? '');
        notValidDate =
            DateTime.now().isBefore(date!.subtract(Duration(days: 1)));
        print('1');
        if (value != null && value == 401) {
          Get.snackbar(' غير مصرح بالدخول ', ' عذراً..انتهت صلاحية الجلسة',
              colorText: Colors.white,
              backgroundColor: Colors.redAccent.shade200,
              duration: const Duration(milliseconds: 1500));
          await Future.delayed(const Duration(milliseconds: 2400));

          Get.offAllNamed('/intro');
          Get.put(SelectLevelController());
          throw Exception();
        }
        // if (pref.getBool('isFirstTime') == null) {
        //   //used to check if its first time so this loaading skeleton wouldn't be shown
        //   pref.setBool('isFirstTime', true);
        //   isLoading = true;
        //   update();
        // } else {
        //   isLoading = false;
        //   update();
        // }
      });

      if (subjects == null || subjects.isEmpty) {
        await SubjectDataSource.instance.get_All_Subjects().then((value) {
          if (value.runtimeType == List<Subject>) {
            return subjectLoaded = true;
          }
          print('2');
        });
      } else {
        subjectLoaded = true;
      }

      if (subSubjects == null || subSubjects.isEmpty) {
        await SubjectDataSource.instance.get_AllSub_Subjects().then((value) {
          if (value.runtimeType == List<SubSubject?>) {
            subSubjectLoaded = true;
          }
          print('2');
        });
      } else {
        subSubjectLoaded = true;
      }

      if ((activeCoupons == null || activeCoupons.isEmpty)) {
        await CodeManagingDataSource.instance
            .getActiveUserCoupon()
            .then((value) {
          if (value.runtimeType == List<ActiveCoupons>) {
            activeCouponLoaded = true;
          }
          print('3');
        });
      } else {
        activeCouponLoaded = true;
      }

      // if (getAllQuestionW == null || getAllQuestionW == 0) {
      //   await QuestionDataSource.instance
      //       .getAllUserQuestions()
      //       .then((value) async {
      //     if (value.runtimeType == List<QuestionWithAnswer>) {
      //       questionLoaded = true;
      //     }
      //     print('4');
      //   });
      // } else {
      questionLoaded = true;
      // }
      // if (wrongLoaded = false) {
      //   await WrongAnswerDataSource.instace.getAllWrongAnswers().then((value) {
      //     if (value.runtimeType == List<WrongAnswer>) {
      //       wrongLoaded = true;
      //     }
      //     print('5');
      //   });
      // }
      // if (fav == null || fav.isEmpty) {
      //   await BackgroundDataSource.instance.getFavorites().then((value) {
      //     if (value.runtimeType == List<dynamic>) {
      //       return favLoaded = true;
      //     }
      //     print('6');
      //   });
      // } else {
      favLoaded = true;
      // }
      // if (examsLog == null || examsLog == 0) {
      //   List<int?>? a = await getAllQuestionID();
      //   if (a == null) {
      //   } else {
      //     await ExamsLogDataSource.instance.getAllExamsLog(a!).then((value) {
      //       if (value.runtimeType == List<ExamsLog?>) {
      //         examsLoaded = true;
      //       }
      //     });
      //   }
      // } else {   }
      examsLoaded = true;

      if (links == null || links.isEmpty) {
        await LinksDataSource.instance.getAllLinks().then((value) {
          if (value.runtimeType == List<Links>) {
            linkloaded = true;
          }
          print('7');
        });
      } else {
        linkloaded = true;
      }
      // if (codes == null || codes.isEmpty) {
      //   await CodeManagingDataSource.instance.getUserCode().then((value) {
      //     if (value.runtimeType == List<UserCodes>) {
      //       codeLoaded = true;
      //     }
      //   });
      // } else {}
      codeLoaded = true;

      while (!(codeLoaded &&
          favLoaded &&
          subSubjectLoaded &&
          subjectLoaded &&
          pref.getString('chapter') != null &&
          questionLoaded)) {
        if (pref.getString('chapter') == null) {
          BackgroundDataSource.instance.getChapter();
          print('6577');
        }

        if (subjectLoaded == false) {
          await SubjectDataSource.instance.get_All_Subjects().then((value) {
            if (value.runtimeType == List<Subject>) {
              subjectLoaded = true;
            }
          });
        }
        if (subSubjectLoaded == false) {
          subSubjectLoaded = true;

          await SubjectDataSource.instance.get_AllSub_Subjects().then((value) {
            if (value.runtimeType == List<SubSubject>) {
              subSubjectLoaded = true;
            }
          });
        }
        // if (activeCodesLoaded == false) {
        //   await CodeManagingDataSource.instance
        //       .getActiveUserCode()
        //       .then((value) {
        //     if (value.runtimeType == List<ActiveCodes>) {
        //       activeCodesLoaded = true;
        //     }
        //   });
        // }
        if (activeCouponLoaded == false) {
          await CodeManagingDataSource.instance
              .getActiveUserCoupon()
              .then((value) {
            if (value.runtimeType == List<ActiveCoupons>) {
              activeCouponLoaded = true;
            }
          });
        }

        if (questionLoaded == false) {
          await QuestionDataSource.instance
              .getAllUserQuestions()
              .then((value) async {
            if (value.runtimeType == List<QuestionWithAnswer>) {
              questionLoaded = true;
            }
          });
        }
        if (favLoaded == false) {
          if (questionLoaded == false) {
          } else {
            await BackgroundDataSource.instance.getFavorites().then((value) {
              if (value.runtimeType == List<dynamic>) {
                return favLoaded = true;
              }
            });
          }
        }
        // if (wrongLoaded == false) {
        //   if (questionLoaded == false) {
        //   } else {
        //     await WrongAnswerDataSource.instace
        //         .getAllWrongAnswers()
        //         .then((value) {
        //       if (value.runtimeType == List<WrongAnswer>) {
        //         wrongLoaded = true;
        //       }
        //     });
        //   }
        // }

        // if (examsLoaded == false) {
        //   if (questionLoaded == false) {
        //   } else {
        //     List<int?>? a = await getAllQuestionID();

        //     if (a == null || a.isEmpty) {
        //       examsLoaded = true;
        //     } else {
        //       await ExamsLogDataSource.instance
        //           .getAllExamsLog(a!)
        //           .then((value) {
        //         if (value.runtimeType == List<ExamsLog?>) {
        //           examsLoaded = true;
        //         }
        //       });
        //     }
        //   }
        // }

        // if (codeLoaded == false) {
        //   await CodeManagingDataSource.instance.getUserCode().then((value) {
        //     if (value.runtimeType == List<UserCodes>) {
        //       codeLoaded = true;
        //     }
        //   });
        // }
      }
    } else {
      //  Get.defaultDialog(
      //   backgroundColor: Get.theme.cardColor,
      //   contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
      //   title: 'لا يوجد اتصال',
      //   titleStyle: ownStyle(Colors.red, 16.5),
      //   content: Text(
      //     'الرجاء التاكد من اتصالك والمحاولة مرة اخرى',
      //     textAlign: TextAlign.center,
      //     style: ownStyle(Get.theme.primaryColor, 14.5),
      //   ),
      // );
    }
    isLoading = false;

    update();

    super.onReady();
  }

  bool? notValidDate = false;
  DateTime? date;
  @override
  void onInit() async {
    isLoading = true;
    pref = await SharedPreferences.getInstance();
    if (pref.getBool('isFirstTime') == null) {
      //used to check if its first time so this loaading skeleton wouldn't be shown
      pref.setBool('isFirstTime', true);
      isLoading = true;
      update();
    } else {
      isLoading = false;
      update();
    }

    super.onInit();
  }
}
