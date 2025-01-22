import 'package:equatable/equatable.dart';

import '../../../../shared/model/LocalDataSource.dart/LocalData.dart';

class ExamsLog extends Equatable {
  int? id;
  String? previousName;
  String? previousNotes;
  int? sort;
  int? subjectId;
  List<PreviousQuestions>? previousQuestions;

  ExamsLog(
      {this.id,
      this.previousName,
      this.previousNotes,
      this.sort,
      this.subjectId,
      this.previousQuestions});

  ExamsLog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    previousName = json['previous_name'];
    previousNotes = json['previous_notes'];
    sort = json['sort'];
    subjectId = json['subject_id'];
    if (json['previous_questions'] != null) {
      previousQuestions = <PreviousQuestions>[];
      json['previous_questions'].forEach((v) {
        previousQuestions!.add(new PreviousQuestions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['previous_name'] = this.previousName;
    data['previous_notes'] = this.previousNotes;
    // data['sort'] = this.sort;
    data['subject_id'] = this.subjectId;
    if (this.previousQuestions != null) {
      data['previous_questions'] =
          this.previousQuestions!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}

class PreviousQuestions {
  int? id;
  QuestionForPrev? question;

  PreviousQuestions({this.id, this.question});

  PreviousQuestions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'] != null
        ? new QuestionForPrev.fromJson(json['question'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.question != null) {
      data['question'] = this.question!.toJson();
    }
    return data;
  }
}

class QuestionForPrev {
  int? id;
  String? questionContent;
  String? questionNotes;
  bool? isMcq;
  String? url;
  List<AnswerForPrev>? answer;
  List<Notes>? notes;

  QuestionForPrev(
      {this.id,
      this.url,
      this.questionContent,
      this.questionNotes,
      this.isMcq,
      this.answer,
      this.notes});

  QuestionForPrev.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    questionContent = json['question_content'];
    questionNotes = json['question_notes'];
    isMcq = json['is_mcq'];
    if (json['answer'] != null) {
      answer = <AnswerForPrev>[];
      json['answer'].forEach((v) {
        answer!.add(new AnswerForPrev.fromJson(v));
      });
    }
    if (json['notes'] != null) {
      notes = <Notes>[];
      json['notes'].forEach((v) {
        notes!.add(new Notes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data[qurl] = this.url;
    data['question_content'] = this.questionContent;
    data['question_notes'] = this.questionNotes;
    data['is_mcq'] = this.isMcq;
    if (this.answer != null) {
      data['answer'] = this.answer!.map((v) => v.toJson()).toList();
    }
    if (this.notes != null) {
      data['notes'] = this.notes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AnswerForPrev {
  int? id;
  String? answerContent;
  String? answerNotes;
  bool? correctness;
  String? url;

  AnswerForPrev(
      {this.id,
      this.url,
      this.answerContent,
      this.answerNotes,
      this.correctness});

  AnswerForPrev.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    answerContent = json['answer_content'];
    answerNotes = json['answer_notes'];
    correctness = json['correctness'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data[aurl] = url;
    data['answer_content'] = this.answerContent;
    data['answer_notes'] = this.answerNotes;
    data['correctness'] = this.correctness;
    return data;
  }
}

class Notes {
  String? note;
  int? userId;
  int? questionId;

  Notes({this.note, this.userId, this.questionId});

  Notes.fromJson(Map<String, dynamic> json) {
    note = json['note'];
    userId = json['user_id'];
    questionId = json['question_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['note'] = this.note;
    data['user_id'] = this.userId;
    data['question_id'] = this.questionId;
    return data;
  }
}
