import '../../Features/questions/model/classes/QuestionAnswerModel.dart';
import '../../Features/questions/model/classes/QuestionWithAnswer.dart';

List<QuestionAnswerModel> question2 = [];
late int id2;
late List<QuestionWithAnswer?>? value2;

List<QuestionAnswerModel> convertFunc2(List<QuestionWithAnswer?>? value) {
  question2.clear();
  try {
    value2 = value;
    for (int i = 0; i < value2!.length; i++) {
      List<Answer1> answer1 = [];
      if (value2!.isNotEmpty) {
        id2 = value2![i]!.questionId!;

        if (value2![i]!.isMcq == 1) {
          for (int s = 0; s < value2!.length; s++) {
            if (id2 == value2![s]!.questionId) {
              if (answer1.contains(Answer1(
                  checked: false,
                  url: value2![s]!.aurl,
                  id: value2![s]!.answerId,
                  correctness: value2![s]!.correctness == 1 ? true : false,
                  answerContent: value2![s]!.answerContent,
                  answerNotes: value2![s]!.answerNotes))) {
              } else {
                answer1.add(Answer1(
                    checked: false,
                    url: value2![s]!.aurl,
                    id: value2![s]!.answerId,
                    correctness: value2![s]!.correctness == 1 ? true : false,
                    answerContent: value2![s]!.answerContent,
                    answerNotes: value2![s]!.answerNotes));
              }

              // value2=value.remove(value);
            }
          }
        } else {
          QuestionWithAnswer? e =
              value2!.firstWhere((element) => element!.questionId == id2);
          answer1.add(Answer1(
              checked: false,
              url: e!.hurl,
              id: e!.answerId,
              answerContent: e.answerContent,
              answerNotes: e.answerNotes,
              correctness: true));
        }

        value2![i]!.isMcq == 1
            ? question2.add(QuestionAnswerModel(
                url: value2![i]!.qurl,
                note: value2![i]!.note,
                wrong_times: value2![i]!.wrong_times,
                hurl: value2![i]!.hurl,
                show: false,
                nextDate: value2![i]!.nextDate,
                right_times: value2![i]!.right_times,
                isFavorites: value2![i]!.isFavorites,
                isWrong: value2![i]!.isWrong,
                isMcq: true,
                answer: answer1,
                id: value2![i]!.questionId,
                previousId: value2![i]!.previousId,
                questionContent: value2![i]!.questionContent,
                questionNote: value2![i]!.questionNotes,
                subSubjectId: value2![i]!.subSubjectId,
                groupValue: value2![i]!.questionId! + 50001))
            : question2.add(QuestionAnswerModel(
                show: false,
                wrong_times: value2![i]!.wrong_times,
                nextDate: value2![i]!.nextDate,
                right_times: value2![i]!.right_times,
                hurl: value2![i]!.hurl,
                note: value2![i]!.note,
                isFavorites: value2![i]!.isFavorites,
                isWrong: value2![i]!.isWrong,
                isMcq: false,
                url: value2![i]!.qurl,
                answer: answer1,
                id: value2![i]!.questionId,
                previousId: value2![i]!.previousId,
                questionContent: value2![i]!.questionContent,
                questionNote: value2![i]!.questionNotes,
                subSubjectId: value2![i]!.subSubjectId,
                groupValue: value2![i]!.questionId! + 50001));

        // for (int j = 0; j < value2!.length; j++) {
        //   if (value2![i]!.questionId == value2![j]!.questionId) {
        //     value2!.remove(value2![i]);
        //   }
        // }
      }
    }
  } catch (errore) {}
  List<QuestionAnswerModel> qquestion2 = [];
  for (int ss = 0; ss < question2.length; ss++) {
    if (qquestion2.isNotEmpty) {
      if (qquestion2.contains(question2[ss])) {
      } else {
        qquestion2.add(question2[ss]);
      }
    } else {
      qquestion2.add(question2[ss]);
    }
  }

  return qquestion2;
}
