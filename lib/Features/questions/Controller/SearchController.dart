import 'package:get/get.dart';

import '../model/classes/QuestionAnswerModel.dart';
import 'CheckAnswerController/checkAnswerController.dart';
import 'LessonController.dart';

class QuesSearchController extends GetxController {
  final LessonController _lessonController = Get.find();
  final CheckAnswerController _checkAnswerController = Get.find();
  bool active = false;

  List<QuestionAnswerModel?>? temporaryList = [];
  changeActivationState() {
    active = !active;
    if (active) {
      _checkAnswerController.restoreAlreadycheck = true;
      temporaryList = _lessonController.ans;
    } else {
      _lessonController.ans = temporaryList;
    }
    _lessonController.update();
  }

  void runFilter(String enteredKeyword) {
    List<QuestionAnswerModel?>? results = [];
    if (enteredKeyword.isEmpty) {
      _lessonController.ans = temporaryList!;
      update();

// if the search field is empty or only contains white-space, we'll display all users
    } else {
      for (int i = 0; i < temporaryList!.length; i++) {
        List<QuestionAnswerModel?>? question = [];
        for (int j = 0; j < temporaryList![i]!.answer!.length; j++) {
          if (temporaryList![i]!
              .answer![j]
              .answerContent!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase())) {
            if (question.contains(temporaryList![i]!)) {
            } else {
              question.add(temporaryList![i]!);
            }
          }
        }

        if (temporaryList![i]!
            .questionContent!
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase())) {
          if (results.contains(temporaryList![i]!)) {
          } else {
            results.add(temporaryList![i]);
          }
        }
        if (question.isNotEmpty) {
          for (int c = 0; c < question.length; c++) {
            if (results.contains(question[c]!)) {
            } else {
              results.add(question[c]);
            }
          }
        }
      }

      _lessonController.ans = results;
      update();
// we use the toLowerCase() method to make it case-insensitive
    }

// Refresh the UI
    update();
  }
}
