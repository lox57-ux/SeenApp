class ActiveCouponsLocal {
  int? id;
  String? name;
  bool? isActive;
  int? expiryTime;
  int? subjectID;
  String? endDate;
  String? activationDate;
  ActiveCouponsLocal(
      {this.id,
      this.name,
      this.activationDate,
      this.isActive,
      this.expiryTime,
      this.subjectID,
      this.endDate});

  ActiveCouponsLocal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isActive = json['is_active'] == 1 ? true : false;
    expiryTime = json['expiry_time'];
    name = json['coupon_content'];
    subjectID = json['subject_id'];
    activationDate = json['date_of_activation'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_active'] = this.isActive! ? 1 : 0;
    data['coupon_content'] = name;
    data['subject_id'] = this.subjectID;
    data['expiry_time'] = this.expiryTime;
    data['end_date'] = this.endDate;
    data['date_of_activation'] = this.activationDate;
    return data;
  }
}
