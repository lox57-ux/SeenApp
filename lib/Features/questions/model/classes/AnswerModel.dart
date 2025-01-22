import 'package:equatable/equatable.dart';

import '../../../../shared/model/LocalDataSource.dart/LocalData.dart';

class AnswerModel extends Equatable {
  int? ansId;
  String? ansContent;
  String? ansNotes;
  int? correctness;
  int? quesId;
  String? url;

  AnswerModel(
      {this.ansId,
      this.ansContent,
      this.ansNotes,
      this.url,
      this.correctness,
      this.quesId});

  AnswerModel.fromJson(Map<String, dynamic> json) {
    ansId = json['id'];
    ansContent = json['answer_content'];
    ansNotes = json['answer_notes'];
    url = json[aurl];
    correctness = json['correctness'];
    quesId = json['question_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = ansId;
    data[aurl] = url;
    data['answer_content'] = ansContent;
    data['answer_notes'] = ansNotes;
    data['correctness'] = correctness;
    data['question_id'] = quesId;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        ansId,
        ansContent,
        url,
        ansNotes,
        correctness,
        quesId,
      ];
}
