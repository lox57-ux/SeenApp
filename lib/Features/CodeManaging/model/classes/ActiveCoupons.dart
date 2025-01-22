class ActiveCoupons {
  int? id;
  String? name;
  bool? isActive;
  int? expiryTime;
  List<Subjects>? subjects;
  String? endDate;
  String? activationDate;

  ActiveCoupons(
      {this.id,
      this.name,
      this.isActive,
      this.activationDate,
      this.expiryTime,
      this.subjects,
      this.endDate});

  ActiveCoupons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['coupon_content'];
    isActive = json['is_active'];
    expiryTime = json['expiry_time'];
    activationDate = json['date_of_activation'];
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
    data['coupon_content'] = this.name;
    data['date_of_activation'] = this.activationDate;
    data['is_active'] = this.isActive;
    data['expiry_time'] = this.expiryTime;
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
