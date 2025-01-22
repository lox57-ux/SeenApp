class CodeInfo {
  int? id;
  String? codeContent;
  String? codeName;
  String? codeNotes;
  int? expiryTime;
  String? dateOfActivation;
  bool? isActive;
  String? agent;
  String? type;
  String? createdAt;
  String? updatedAt;
  int? userId;
  List<SubjectCode>? subjectCode;

  CodeInfo(
      {this.id,
      this.codeContent,
      this.codeName,
      this.codeNotes,
      this.expiryTime,
      this.dateOfActivation,
      this.isActive,
      this.agent,
      this.type,
      this.createdAt,
      this.updatedAt,
      this.userId,
      this.subjectCode});

  CodeInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    codeContent = json['code_content'];
    codeName = json['code_name'];
    codeNotes = json['code_notes'];
    expiryTime = json['expiry_time'];
    dateOfActivation = json['date_of_activation'];
    isActive = json['is_active'];
    agent = json['agent'];
    type = json['type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userId = json['user_id'];
    if (json['subject_code'] != null) {
      subjectCode = <SubjectCode>[];
      json['subject_code'].forEach((v) {
        subjectCode!.add(new SubjectCode.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code_content'] = this.codeContent;
    data['code_name'] = this.codeName;
    data['code_notes'] = this.codeNotes;
    data['expiry_time'] = this.expiryTime;
    data['date_of_activation'] = this.dateOfActivation;
    data['is_active'] = this.isActive;
    data['agent'] = this.agent;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['user_id'] = this.userId;
    if (this.subjectCode != null) {
      data['subject_code'] = this.subjectCode!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubjectCode {
  int? codeId;
  Subject? subject;

  SubjectCode({this.codeId, this.subject});

  SubjectCode.fromJson(Map<String, dynamic> json) {
    codeId = json['code_id'];
    subject =
        json['subject'] != null ? new Subject.fromJson(json['subject']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code_id'] = this.codeId;
    if (this.subject != null) {
      data['subject'] = this.subject!.toJson();
    }
    return data;
  }
}

class Subject {
  int? id;
  String? subjectName;
  String? subjectNotes;
  String? term;
  String? language;
  int? bachelorId;
  int? yearId;

  Subject(
      {this.id,
      this.subjectName,
      this.subjectNotes,
      this.term,
      this.language,
      this.bachelorId,
      this.yearId});

  Subject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subjectName = json['subject_name'];
    subjectNotes = json['subject_notes'];
    term = json['term'];
    language = json['language'];
    bachelorId = json['bachelor_id'];
    yearId = json['year_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject_name'] = this.subjectName;
    data['subject_notes'] = this.subjectNotes;
    data['term'] = this.term;
    data['language'] = this.language;
    data['bachelor_id'] = this.bachelorId;
    data['year_id'] = this.yearId;
    return data;
  }
}
