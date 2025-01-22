class BachelorType {
  int? id;
  String? bachelorName;
  String? createdAt;
  String? updatedAt;

  BachelorType({this.id, this.bachelorName, this.createdAt, this.updatedAt});

  BachelorType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bachelorName = json['bachelor_name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bachelor_name'] = this.bachelorName;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
