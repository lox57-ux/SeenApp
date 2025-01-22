import 'package:get/get.dart';

import '../../../../core/functions/QuestionFunction.dart';
import '../../../../core/functions/checkSolvedAnser/checkSolvedAnswer.dart';
import '../../../../shared/model/LocalDataSource.dart/LocalData.dart';
import '../../model/classes/restoreResults.dart';

/* heres functions used in user answer check  */
class CheckAnswerController extends GetxController {
  RxInt selectedAnswerIndex = RxInt(-1);
  RxInt correctAnswerIndex = RxInt(-1);

  RxInt selected = 0.obs;
  bool check = false;
  bool solvedCheck = false;
  bool restoreAlreadycheck = false;

  List<Map<String, dynamic>> solvedAnswer = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> doubleCheckedAnswer = <Map<String, dynamic>>[].obs;
  restoreQuestionWidgetState(
      {questionId,
      show,
      isMcq,
      correctAnswer,
      correctID,
      isSelected,
      selectedAnswer,
      isWrong}) {
    var tempq = restorAlreadyCheckedAnswer(questionId);
    /* all parmeter are needed to restor the ui state 
     in many cases like longpress check or just select answer with out check 
     or check all answers solved or not  */
    if (restoreAlreadycheck) {
      /* the right answer highlited with green and the 
           other is red (after checking in each way)
           we used it when  restoring session if the student exit after completing the exam  */
      if (restorAlreadyCheckedAnswer(questionId) != null) {
        show = isMcq! ? false : true;

        if (restorAlreadyCheckedAnswer(questionId)['correctness']) {
          if (checkSolvedAnswer(questionId)['a_index'] == 111) {
            correctAnswer = 111;
          } else {
            //    isSelected = restorAlreadyCheckedAnswer(questionId)['correctIndex'];
            correctAnswer = correctID;
            isSelected = correctID;
          }
        } else {
          if (checkSolvedAnswer(questionId)['a_index'] == 1000) {
            selectedAnswer = 1000;
          } else {
            isSelected = checkSolvedAnswer(questionId)['choice'];
            selectedAnswer = checkSolvedAnswer(questionId)['choice'];

            if (isMcq!) {
              correctAnswer = correctID;
            }
          }
        }
      }
      print(tempq);
      return RestoreResults(
          questionId: questionId,
          show: show,
          isMcq: isMcq,
          correctAnswer: correctAnswer,
          correctID: correctID,
          isSelected: isSelected,
          isWrong: tempq == null ? false : tempq['is_wrong'],
          nextDate: tempq == null ? null : tempq[nextShowDate],
          right_times: tempq == null ? 0 : tempq[rightTimes],
          selectedAnswer: selectedAnswer);
    }

    if (check) {
      /* if answers were checked with
            this option  all answers
            will be checked in real time to view in ui  */
      if (checkSolvedAnswer(questionId) != null) {
        show = true;
        if (checkSolvedAnswer(questionId)['correctness']) {
          updateWrongness(questionId, 0);
          isWrong = false;
          if (checkSolvedAnswer(questionId)['a_index'] == 111) {
            correctAnswer = 111;
          } else {
            correctAnswer = correctID;
          }
        } else {
          updateWrongness(questionId, 1);
          isWrong = true;
          if (checkSolvedAnswer(questionId)['a_index'] == 1000) {
            selectedAnswer = 1000;
          } else {
            selectedAnswer = checkSolvedAnswer(questionId)['choice'];

            correctAnswer = correctID;
          }
        }
      } else {
        show = true;
        if (!isMcq!) {
          correctID = 111;
        } else {
          correctAnswer = correctID;
        }
      }
      return RestoreResults(
        questionId: questionId,
        show: show,
        isMcq: isMcq,
        correctAnswer: correctAnswer,
        correctID: correctID,
        isSelected: isSelected,
        isWrong: tempq == null ? false : tempq['is_wrong'],
        nextDate: tempq == null ? null : tempq[nextShowDate],
        right_times: tempq == null ? 0 : tempq[rightTimes],
        selectedAnswer: selectedAnswer,
      );
    }
    if (solvedCheck) {
      /* if answers were checked with
            this option  just solved answers
            will be checked in real time to view in ui  */
      if (checkSolvedAnswer(questionId) != null) {
        show = isMcq! ? false : true;
        if (checkSolvedAnswer(questionId)['correctness']) {
          updateWrongness(questionId, 0);
          isWrong = false;
          if (checkSolvedAnswer(questionId)['a_index'] == 111) {
            correctAnswer = 111;
          } else {
            correctAnswer = correctID;
          }

          //  correctAnswer = checkSolvedAnswer(questionId)['a_index'];
        } else {
          updateWrongness(questionId, 1);
          isWrong = true;
          if (checkSolvedAnswer(questionId)['a_index'] == 1000) {
            selectedAnswer = 1000;
          } else {
            selectedAnswer = checkSolvedAnswer(questionId)['choice'];

            correctAnswer = checkSolvedAnswer(questionId)['correctIndex'];
          }
          //    selectedAnswer = checkSolvedAnswer(questionId)['a_index'];
          //  correctAnswer = checkSolvedAnswer(questionId)['correctIndex'];
        }
      }
      return RestoreResults(
        questionId: questionId,
        show: show,
        isMcq: isMcq,
        correctAnswer: correctAnswer,
        correctID: correctID,
        isSelected: isSelected,
        selectedAnswer: selectedAnswer,
        isWrong: tempq == null ? false : tempq['is_wrong'],
        nextDate: tempq == null ? null : tempq[nextShowDate],
        right_times: tempq == null ? 0 : tempq[rightTimes],
      );
    }
  }
  // void check(id) {}
}
