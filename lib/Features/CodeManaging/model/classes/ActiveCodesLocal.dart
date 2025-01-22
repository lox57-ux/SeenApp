class ActiveCodesLocal {
  int? id;
  String? dateOfActivation;
  bool? isActive;
  int? userId;
  String? name;
  int? subjectId;
  int? expiryTime;
  String? endDate;

  ActiveCodesLocal(
      {this.id,
      this.dateOfActivation,
      this.isActive,
      this.expiryTime,
      this.name,
      this.userId,
      this.subjectId,
      this.endDate});

  ActiveCodesLocal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    expiryTime = json['expiry_time'];
    name = json['code_name'];
    dateOfActivation = json['date_of_activation'];
    isActive = json['is_active'] == 1 ? true : false;
    userId = json['user_id'];
    subjectId = json['subject_id'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['expiry_time'] = this.expiryTime;
    data['code_name'] = this.name;
    data['date_of_activation'] = this.dateOfActivation;
    data['is_active'] = this.isActive! ? 1 : 0;
    data['user_id'] = this.userId;
    data['subject_id'] = this.subjectId;
    data['end_date'] = this.endDate;
    return data;
  }
}
