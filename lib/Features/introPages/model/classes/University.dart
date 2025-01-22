class University {
  int? id;
  String? universityName;
  String? universityState;

  University({this.id, this.universityName, this.universityState});

  University.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    universityName = json['university_name'];
    universityState = json['university_state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['university_name'] = this.universityName;
    data['university_state'] = this.universityState;
    return data;
  }
}
