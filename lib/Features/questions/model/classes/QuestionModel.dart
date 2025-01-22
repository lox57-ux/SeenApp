import 'package:equatable/equatable.dart';

import '../../../../shared/model/LocalDataSource.dart/LocalData.dart';

class QuestionModel extends Equatable {
  late final int quesId;
  late final String quesContent;
  var quesNotes;
  var isMcq;
  var isMcq2;
  String? subSubId;
  var prevId;
  var subjectID;
  var iswrong;
  var isfavorite;
  var note;
  String? url;
  String? hurl;
  QuestionModel(
      {required this.quesId,
      required this.quesContent,
      required this.quesNotes,
      required this.isMcq,
      required this.subSubId,
      required this.prevId,
      this.hurl,
      required this.subjectID,
      this.url,
      this.isMcq2,
      required this.note,
      required this.iswrong,
      required this.isfavorite});

  QuestionModel.fromJson(Map<String, dynamic> json) {
    quesId = json[questionId];
    url = json[qurl];
    hurl = json['h_url'];
    subjectID = json[questionSubjectID];
    quesContent = json[questionContent];
    quesNotes = json[questionNotes];
    isMcq = json[isMcqColumn];
    prevId = json[previousId];
    subSubId = json[questionSubSubjectId];
    iswrong = json[isWrong] ?? 0;
    note = json['note'];
    isfavorite = json[isWrong] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data[questionId] = quesId;
    data[questionContent] = quesContent;
    data[questionNotes] = quesNotes;
    data[isMcqColumn] = isMcq;
    data[questionSubjectID] = subjectID;
    data[previousId] = prevId;
    data["h_url"] = hurl;
    data[questionSubSubjectId] = subSubId;
    data[isWrong] = iswrong ?? 0;
    data[isFavorite] = isfavorite ?? 0;
    data['note'] = note;
    data[qurl] = url;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [quesId, quesContent, quesNotes, isMcq, isMcq2, iswrong, url, isfavorite];
}
