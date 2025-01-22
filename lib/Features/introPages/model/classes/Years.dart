class Years {
  int? id;
  String? yearName;
  String? createdAt;
  String? updatedAt;
  int? collageId;
  String? collageCollageName;
  String? collageUniversityUniversityName;
  String? collageUniversityUniversityState;
  int? collageUniversityId;

  Years(
      {this.id,
      this.yearName,
      this.createdAt,
      this.updatedAt,
      this.collageId,
      this.collageCollageName,
      this.collageUniversityUniversityName,
      this.collageUniversityUniversityState,
      this.collageUniversityId});

  Years.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yearName = json['year_name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    collageId = json['collage_id'];
    collageCollageName = json['collage.collage_name'];
    collageUniversityUniversityName =
        json['collage.university.university_name'];
    collageUniversityUniversityState =
        json['collage.university.university_state'];
    collageUniversityId = json['collage.university.id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['year_name'] = this.yearName;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['collage_id'] = this.collageId;
    data['collage.collage_name'] = this.collageCollageName;
    data['collage.university.university_name'] =
        this.collageUniversityUniversityName;
    data['collage.university.university_state'] =
        this.collageUniversityUniversityState;
    data['collage.university.id'] = this.collageUniversityId;
    return data;
  }
}
