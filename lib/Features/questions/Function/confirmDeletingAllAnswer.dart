import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../Randomize/controllers/RandomizeController.dart';
import '../../../core/constants/Colors.dart';
import '../../../core/constants/TextStyles.dart';
import '../../../core/functions/localDataFunctions/CurrentSession.dart';
import '../../../shared/CustomizedButton.dart';
import '../../Sections/controller/indexQuestionController/indexQuestionsController.dart';
import '../Controller/CheckAnswerController/checkAnswerController.dart';
import '../Controller/LessonController.dart';

CheckAnswerController checkAnswerController = Get.find();
Future<dynamic> confirmDeleteingAllAnswer(
    int subID,
    IndexQuestionController indexQuestionController,
    CheckAnswerController checkAnswerController,
    LessonController _lessonController,
    RandomizeController randomizeController,
    BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Get.theme.cardColor,
          surfaceTintColor: Colors.white,
          title: Center(
            child: Text(
              'حذف جميع الإجابات',
              style: ownStyle(Get.theme.primaryColor, 18.sp),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  'هل أنت متأكد من رغبتك في حذف جميع الإجابات؟',
                  textAlign: TextAlign.center,
                  style: ownStyle(SeenColors.iconColor, 16.sp),
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            CustomizedButton(
              isCode: false,
              codeBack: true,
              color: Colors.grey,
              txt: 'إلغاء',
              fun: () {
                Get.back();
              },
              width: 100.w,
            ),
            CustomizedButton(
              isCode: true,
              codeBack: true,
              color: Get.theme.primaryColor,
              txt: 'موافق',
              fun: () async {
                checkAnswerController.solvedAnswer = [];
                checkAnswerController.doubleCheckedAnswer = [];
                _lessonController.resetGroup = true;
                _lessonController.isRandomize
                    ? {
                        randomizeController.resetCounters(),
                        deleteRandomSession(),
                      }
                    : _lessonController.isAllFave
                        ? deleteAllFavSession()
                        : _lessonController.isFave
                            ? deleteFavSession()
                            : _lessonController.isWrong
                                ? deleteWrongness()
                                : _lessonController.isAllWrong
                                    ? deleteAllWrongness()
                                    : _lessonController.isPreiviosQuestios
                                        ? deleteprevSession()
                                        : deleteSubSession(subID);
                checkAnswerController.check = false;

                checkAnswerController.solvedCheck = false;
                _lessonController.numberOfWrongQA = 0;
                _lessonController.resetQuestions();
                indexQuestionController.index = 0;

                Get.back();
                _lessonController.update();
              },
              width: 100.w,
            ),
          ],
        );
      });
}
