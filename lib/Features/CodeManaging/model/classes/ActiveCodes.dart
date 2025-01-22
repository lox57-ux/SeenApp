class ActiveCodes {
  int? id;
  String? dateOfActivation;
  bool? isActive;
  int? userId;
  List<Subjects>? subjects;
  String? endDate;

  ActiveCodes(
      {this.id,
      this.dateOfActivation,
      this.isActive,
      this.userId,
      this.subjects,
      this.endDate});

  ActiveCodes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateOfActivation = json['date_of_activation'];
    isActive = json['is_active'];
    userId = json['user_id'];
    if (json['subjects'] != null) {
      subjects = <Subjects>[];
      json['subjects'].forEach((v) {
        subjects!.add(new Subjects.fromJson(v));
      });
    }
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date_of_activation'] = this.dateOfActivation;
    data['is_active'] = this.isActive;
    data['user_id'] = this.userId;
    if (this.subjects != null) {
      data['subjects'] = this.subjects!.map((v) => v.toJson()).toList();
    }
    data['end_date'] = this.endDate;
    return data;
  }
}

class Subjects {
  int? id;

  Subjects({this.id});

  Subjects.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
