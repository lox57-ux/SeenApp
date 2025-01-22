import 'package:equatable/equatable.dart';

class IndexedSubject extends Equatable {
  int? id;
  String? subjectName;
  String? language;
  int? subject_code;
  int? subject_coupon;
  bool? has_data;
  bool? open_subject;
  bool? hasUnloackedSub;
  int? indexo;
  IndexedSubject(
      {this.id,
      this.subjectName,
      this.hasUnloackedSub,
      this.has_data,
      this.open_subject,
      this.language,
      this.subject_code,
      this.subject_coupon,
      this.indexo});

  factory IndexedSubject.fromJson(Map<String, dynamic> json) {
    return IndexedSubject(
        open_subject: json['open_subject'] != null
            ? json['open_subject'].runtimeType == int
                ? json['open_subject'] == 1
                    ? true
                    : false
                : json['open_subject']
            : false,
        hasUnloackedSub: json['has_unloacked'] == null
            ? false
            : json['has_unloacked'].runtimeType == int
                ? json['has_unloacked'] == 1
                    ? true
                    : false
                : json['has_unloacked'],
        has_data: json['has_data'] == null
            ? false
            : json['has_data'].runtimeType == int
                ? json['has_data'] == 1
                    ? true
                    : false
                : json['has_data'],
        id: json['id'],
        subjectName: json['subject_name'],
        language: json['language'],
        subject_coupon: json['subject_coupon'],
        subject_code: json['subject_code'],
        indexo: json['subjectIndex']);
  }
  Map<String, dynamic> toJson(int index) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject_name'] = this.subjectName;
    data['has_unloacked'] = hasUnloackedSub! ? 1 : 0;
    data['has_data'] = has_data! ? 1 : 0;
    data['language'] = this.language;
    data['open_subject'] = this.open_subject! ? 1 : 0;
    data['subject_code'] = this.subject_code; //here all your proplem is
    data['subject_coupon'] = this.subject_coupon;
    data['subjectIndex'] = index;
    return data;
  }

  @override
  List<Object?> get props =>
      [id, subjectName, language, subject_code, indexo, subject_coupon];
}
