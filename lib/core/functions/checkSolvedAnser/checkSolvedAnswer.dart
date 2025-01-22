import 'package:get/get.dart';

import '../../../Features/questions/Controller/CheckAnswerController/checkAnswerController.dart';
import '../../../Features/questions/Controller/LessonController.dart';

checkSolvedAnswer(int id) {
  CheckAnswerController checkAnswerController = Get.find();
  LessonController lessonController = Get.find();

  List<Map<String, dynamic>> mp;
  mp = checkAnswerController.solvedAnswer
      .where((p0) => p0['questionId'] == id)
      .toList();

  if (mp.isNotEmpty) {
    print(mp);
    return mp.first;
  } else {}

  return null;
}

restorAlreadyCheckedAnswer(int id) {
  CheckAnswerController checkAnswerController = Get.find();

  List<Map<String, dynamic>> mp;
  mp = checkAnswerController.doubleCheckedAnswer
      .where((p0) => p0['questionId'] == id)
      .toList();

  if (mp.isNotEmpty) {
    return mp.first;
  }
  return null;
}
