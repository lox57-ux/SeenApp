import 'package:get/get.dart';

import '../../../Features/questions/Controller/LessonController.dart';
import '../../../Features/questions/model/classes/QuestionAnswerModel.dart';

checkAllAnswer() {
  LessonController _lessonController = Get.find();
  int? correctIndex;
  List<QuestionAnswerModel?>? list = _lessonController.ans;
  List answerList = list!.map((e) {
    for (int i = 0; i < e!.answer!.length; i++) {
      if (e.answer![i].correctness!) {
        correctIndex = i;
      }
    }

    // return {
    //   "answerId": answers[i].id,
    //   "correctness": answers[i].correctness,
    //   "answerContent": answers[i].answerContent,
    //   "questionId": questionId,
    //   "index": i,
    //   "correctIndex": correctIndex
    // };
  }).toList();

  if (!answerList.isEmpty) {
    return answerList.first;
  }

  return null;
}
