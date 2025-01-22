import 'package:equatable/equatable.dart';

class UserCodes extends Equatable {
  int? id;
  String? codeContent;
  String? codeName;
  String? codeNotes;
  int? expiryTime;
  String? dateOfActivation;
  int? isActive;
  int? userId;
  bool? expanded;
  bool? iscoupon;

  UserCodes(
      {this.id,
      this.iscoupon,
      this.codeContent,
      this.codeName,
      this.codeNotes,
      this.expiryTime,
      this.dateOfActivation,
      this.isActive,
      this.expanded,
      this.userId});

  UserCodes.fromJson(Map<String, dynamic> json, bool coup) {
    id = json['id'];
    iscoupon = coup;
    codeContent = json['code_content'];
    codeName = json['code_name'];
    codeNotes = json['code_notes'];
    expiryTime = json['expiry_time'];
    dateOfActivation = json['date_of_activation'];
    isActive = json['is_active'] == true || json['is_active'] == 1 ? 1 : 0;
    userId = json['user_id'];
    expanded = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['iscoupon'] = iscoupon! ? 1 : 0;
    data['code_content'] = this.codeContent;
    data['code_name'] = this.codeName;
    data['code_notes'] = this.codeNotes;
    data['expiry_time'] = this.expiryTime;
    data['date_of_activation'] = this.dateOfActivation;
    data['is_active'] = this.isActive;
    data['user_id'] = this.userId;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [codeName, id];
}
