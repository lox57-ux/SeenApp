class WrongAnswer {
  int? id;

  int? subjectID;

  WrongAnswer({this.id, this.subjectID});

  WrongAnswer.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    subjectID = json['answer']['question']['sub_subject_questions'] == null
        ? null
        : (json['answer']['question']['sub_subject_questions'] as List).isEmpty
            ? null
            : (json['answer']['question']['sub_subject_questions'] as List)
                .first['sub_subject']['subject_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject_id'] = this.subjectID;
    return data;
  }
}
