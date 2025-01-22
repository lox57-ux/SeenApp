import 'package:equatable/equatable.dart';

class SubSubject extends Equatable {
  int? id;
  String? subSubjectName;
  String? subSubjectNotes;
  int? fatherId;
  int? subjectId;
  int? sort;
  bool? expanded;
  bool? isLatex;
  bool? isUnlocked;
  bool? has_data;
  bool? open_sub_subject;
  SubSubject(
      {this.id,
      this.sort,
      this.isUnlocked,
      this.subSubjectName,
      this.subSubjectNotes,
      this.fatherId,
      this.isLatex,
      this.subjectId,
      this.expanded});

  SubSubject.fromJson(Map<String, dynamic> json, bool ex) {
    id = json['id'];
    sort = json['sort'];
    isLatex = json['is_latex'].runtimeType == bool
        ? json['is_latex']
        : json['is_latex'] == 1
            ? true
            : false;
    isUnlocked = json['is_unlocked'].runtimeType == bool
        ? json['is_unlocked']
        : json['is_unlocked'] == 1
            ? true
            : false;
    open_sub_subject = json['open_sub_subject'] != null
        ? json['open_sub_subject'] == 1
            ? true
            : false
        : open_sub_subject;
    has_data = json['has_data'] == null
        ? false
        : json['has_data'] == 1
            ? true
            : false;
    subSubjectName = json['sub_subject_name'];
    subSubjectNotes = json['sub_subject_notes'];
    fatherId = json['father_id'];
    subjectId = json['subject_id'];
    expanded = ex;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_latex'] = this.isLatex == null
        ? 0
        : isLatex!
            ? 1
            : 0;
    data['has_data'] = this.has_data == null
        ? 0
        : has_data!
            ? 1
            : 0;
    data['is_unlocked'] = this.isUnlocked == null
        ? 0
        : isUnlocked!
            ? 1
            : 0;
    data['open_sub_subject'] = this.open_sub_subject == null
        ? 0
        : open_sub_subject!
            ? 1
            : 0;

    data['sub_subject_name'] = this.subSubjectName;
    data['sub_subject_notes'] = this.subSubjectNotes;
    data['father_id'] = this.fatherId;
    data['subject_id'] = this.subjectId;
    data['sort'] = this.sort;

    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [id, subSubjectName, subSubjectNotes, fatherId, subjectId, expanded];
}
