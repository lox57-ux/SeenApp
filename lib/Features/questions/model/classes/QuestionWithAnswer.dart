import 'package:equatable/equatable.dart';

import '../../../../shared/model/LocalDataSource.dart/LocalData.dart';

class QuestionWithAnswer extends Equatable {
  int? qId;
  int? id;
  String? questionContent;
  var questionNotes;
  int? isMcq;
  int? subSubjectId;
  var previousId;
  int? answerId;
  String? answerContent;
  String? answerNotes;
  int? correctness;
  int? questionId;
  int? right_times;
  int? wrong_times;
  bool? isFavorites;
  bool? isWrong;
  String? note;
  String? qurl;
  String? aurl;
  String? hurl;
  String? nextDate;
  QuestionWithAnswer(
      {this.qId,
      this.id,
      this.hurl,
      this.nextDate,
      this.qurl,
      this.isFavorites,
      this.isWrong,
      this.questionContent,
      this.questionNotes,
      this.isMcq,
      this.subSubjectId,
      this.previousId,
      this.answerId,
      this.wrong_times,
      this.note,
      this.aurl,
      this.answerContent,
      this.right_times,
      this.answerNotes,
      this.correctness,
      this.questionId});
  QuestionWithAnswer.fromJson(Map<String, dynamic> json, {int? subid}) {
    qId = json['q_id'];
    hurl = json['h_url'];
    id = json['id'];
    nextDate = json[nextShowDate];
    right_times = json[rightTimes];
    wrong_times = json[wrongTimes];
    qurl = json['q_url'];
    aurl = json['a_url'];
    note = json['note'];
    questionContent = json['question_content'];
    questionNotes = json['question_notes'];
    isMcq = json['is_mcq'];
    subSubjectId = subid;
    previousId = json['previous_id'];
    answerId = json['id'];
    answerContent = json['answer_content'];
    answerNotes = json['answer_notes'];
    correctness = json['correctness'];
    questionId = json['question_id'];
    isFavorites = json[isFavorite] == 1 ? true : false;
    isWrong = json['is_wrong'] == 1 ? true : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['q_id'] = this.qId;
    data['id'] = this.id;
    data['q_url'] = qurl;
    data['a_url'] = aurl;
    data['h_url'] = hurl;
    data['question_content'] = this.questionContent;
    data['question_notes'] = this.questionNotes;
    data['is_mcq'] = this.isMcq;
    data['sub_subject_id'] = this.subSubjectId;
    data['previous_id'] = this.previousId;
    data['answer_id'] = this.answerId;
    data['answer_content'] = this.answerContent;
    data['answer_notes'] = this.answerNotes;
    data['correctness'] = this.correctness;
    data['question_id'] = this.id;
    data['note'] = this.note;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
