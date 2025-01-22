class CouponInfo {
  int? id;
  String? couponContent;
  String? couponNotes;
  bool? isActive;
  int? expiryTime;
  int? limit;
  String? agent;
  String? createdAt;
  String? updatedAt;
  List<SubjectCoupon>? subjectCoupon;

  CouponInfo(
      {this.id,
      this.couponContent,
      this.couponNotes,
      this.isActive,
      this.expiryTime,
      this.limit,
      this.agent,
      this.createdAt,
      this.updatedAt,
      this.subjectCoupon});

  CouponInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    couponContent = json['coupon_content'];
    couponNotes = json['coupon_notes'];
    isActive = json['is_active'];
    expiryTime = json['expiry_time'];
    limit = json['limit'];
    agent = json['agent'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['subject_coupon'] != null) {
      subjectCoupon = <SubjectCoupon>[];
      json['subject_coupon'].forEach((v) {
        subjectCoupon!.add(new SubjectCoupon.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['coupon_content'] = this.couponContent;
    data['coupon_notes'] = this.couponNotes;
    data['is_active'] = this.isActive;
    data['expiry_time'] = this.expiryTime;
    data['limit'] = this.limit;
    data['agent'] = this.agent;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.subjectCoupon != null) {
      data['subject_coupon'] =
          this.subjectCoupon!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubjectCoupon {
  int? couponId;
  Subject? subject;

  SubjectCoupon({this.couponId, this.subject});

  SubjectCoupon.fromJson(Map<String, dynamic> json) {
    couponId = json['coupon_id'];
    subject =
        json['subject'] != null ? new Subject.fromJson(json['subject']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coupon_id'] = this.couponId;
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
  int? yearId;
  int? bachelorId;

  Subject(
      {this.id,
      this.subjectName,
      this.subjectNotes,
      this.term,
      this.language,
      this.yearId,
      this.bachelorId});

  Subject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subjectName = json['subject_name'];
    subjectNotes = json['subject_notes'];
    term = json['term'];
    language = json['language'];
    yearId = json['year_id'];
    bachelorId = json['bachelor_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject_name'] = this.subjectName;
    data['subject_notes'] = this.subjectNotes;
    data['term'] = this.term;
    data['language'] = this.language;
    data['year_id'] = this.yearId;
    data['bachelor_id'] = this.bachelorId;
    return data;
  }
}
