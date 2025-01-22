import 'package:equatable/equatable.dart';
import 'package:seen/core/functions/concatingAnswerWithQuestion.dart';
import 'package:seen/shared/model/LocalDataSource.dart/LocalData.dart';

class QuestionAnswerModel extends Equatable {
  int? id;
  String? questionContent;
  var questionNote;
  bool? isMcq;
  String? createdAt;
  String? updatedAt;
  var previousId;
  int? subSubjectId;
  int? groupValue;
  List<Answer1>? answer;
  bool? checked;
  bool? isFavorites;
  bool? isWrong;
  String? note;
  bool? show;
  String? url;
  String? hurl;
  String? nextDate;
  int? right_times;
  int? wrong_times;
  QuestionAnswerModel(
      {this.id,
      this.questionContent,
      this.questionNote,
      this.nextDate,
      this.right_times,
      required this.url,
      this.isMcq,
      this.show = false,
      this.hurl,
      this.createdAt,
      this.updatedAt,
      this.previousId,
      this.subSubjectId,
      this.note,
      this.answer,
      this.groupValue,
      this.wrong_times,
      this.checked,
      this.isFavorites,
      this.isWrong});

  QuestionAnswerModel.fromJson(Map<String, dynamic> json, int group, bool ch) {
    id = json['id'];
    hurl = json['h_url'];
    right_times = json[rightTimes];
    wrong_times = json[wrongTimes];
    nextDate = json[nextShowDate];
    questionContent = json['question_content'];
    questionNote = json['question_note'];
    isMcq = json['is_mcq'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    previousId = json['previous_id'];
    subSubjectId = json['sub_subject_id'];
    note = json['note'];
    groupValue = group;
    checked = ch;
    show = false;
    if (json['answer'] != null) {
      answer = <Answer1>[];
      json['answer'].forEach((v) {
        answer!.add(new Answer1.fromJson(v, false));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question_content'] = this.questionContent;
    data['question_note'] = this.questionNote;
    data['is_mcq'] = this.isMcq;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['h_url'] = hurl;
    data['previous_id'] = this.previousId;
    data['note'] = this.note;
    data['sub_subject_id'] = this.subSubjectId;
    if (this.answer != null) {
      data['answer'] = this.answer!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, questionContent];
}

class Answer1 extends Equatable {
  int? id;
  String? answerContent;
  String? answerNotes;
  bool? correctness;
  bool? checked;
  bool imgReload = false;
  String? url;
  Answer1(
      {this.checked,
      this.id,
      this.url,
      this.answerContent,
      this.answerNotes,
      this.correctness});

  Answer1.fromJson(Map<String, dynamic> json, bool check) {
    id = json['id'];
    answerContent = json['answer_content'];
    answerNotes = json['answer_notes'];
    correctness = json['correctness'];
    checked = check;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['answer_content'] = this.answerContent;
    data['answer_notes'] = this.answerNotes;
    data['correctness'] = this.correctness;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, answerContent];
}
