// // ignore_for_file: public_member_api_docs, sort_constructors_first
// class SubjectD {
//   final String title;
//   final String subtitle;
//   final List<Section> sections;
//   SubjectD({
//     required this.title,
//     required this.subtitle,
//     required this.sections,
//   });
// }

// class Section {
//   final String title;
//   final String subtitle;
//   bool expanded;
//   final List<SubSection> subsections;
//   Section({
//     required this.title,
//     required this.subtitle,
//     this.expanded = false,
//     required this.subsections,
//   });
// }

// class SubSection {
//   final String title;
//   final String subtitle;
//   SubSection({
//     required this.title,
//     required this.subtitle,
//   });
// }

// List<SubjectD> dummy_subject = [
//   SubjectD(title: 'علوم', subtitle: "أحياء", sections: [
//     Section(title: 'الاعصاب', subtitle: "عصبية", subsections: [
//       SubSection(title: 'الدرس الاول', subtitle: "شش"),
//       SubSection(title: 'الدرس الثاني', subtitle: "شش")
//     ]),
//     Section(title: 'الانف', subtitle: "أنفية", subsections: [
//       SubSection(title: 'الدرس الاول', subtitle: "شش"),
//       SubSection(title: 'الدرس الثاني', subtitle: "شش")
//     ])
//   ])
// ];

import 'package:equatable/equatable.dart';

class Subject extends Equatable {
  int? id;
  String? subjectName;
  String? subjectNotes;
  String? term;
  String? language;

  int? bachelorId;
  int? yearId;
  int? subject_code;
  bool? expand;
  int? subject_coupon;
  bool? has_data;
  bool? open_subject;
  bool? hasUnloackedSub;
  Subject(
      {this.id,
      this.subjectName,
      this.subjectNotes,
      this.hasUnloackedSub,
      this.has_data,
      this.open_subject,
      this.term,
      this.language,
      this.bachelorId,
      this.yearId,
      this.subject_code,
      this.subject_coupon,
      this.expand});

  Subject.fromJson(Map<String, dynamic> json, bool? isOpen) {
    id = json['id'];
    open_subject = isOpen == null
        ? json['open_subject'] != null
            ? json['open_subject'] == 1
                ? true
                : false
            : false
        : isOpen;
    has_data = json['has_data'] == null
        ? false
        : json['has_data'].runtimeType == int
            ? json['has_data'] == 1
                ? true
                : false
            : json['has_data'];
    subjectName = json['subject_name'];
    subjectNotes = json['subject_notes'];
    term = json['term'];
    language = json['language'];
    hasUnloackedSub = json['has_unloacked'] == null
        ? false
        : json['has_unloacked'].runtimeType == int
            ? json['has_unloacked'] == 1
                ? true
                : false
            : json['has_unloacked'];
    bachelorId = json['bachelor_id'];
    yearId = json['year_id'];
    expand = false;

    if (json['codes'] != null) {
      if ((json['codes'] as List).isEmpty) {
        subject_code = null;
      } else {
        subject_code = (json['codes'] as List).length;
      }
    }

    if (json['coupons'] != null) {
      if ((json['coupons'] as List).isEmpty) {
        subject_coupon = null;
      } else {
        subject_coupon = (json['coupons'] as List).length;
      }
    }
    //first['code']['id'].first['code']['id']
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['has_unloacked'] = hasUnloackedSub! ? 1 : 0;
    data['has_data'] = has_data! ? 1 : 0;
    data['subject_name'] = this.subjectName;
    data['subject_notes'] = this.subjectNotes;
    data['term'] = this.term;
    data['language'] = this.language;
    data['open_subject'] = this.open_subject! ? 1 : 0;
    data['bachelor_id'] = this.bachelorId;
    data['year_id'] = this.yearId;
    data["subject_coupon"] = this.subject_coupon;
    data["subject_code"] = this.subject_code; //here all your proplem is
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        subjectName,
        subjectNotes,
        term,
        language,
        bachelorId,
        yearId,
        subject_coupon,
        subject_code
      ];
}
