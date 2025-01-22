class AuthResponse {
  int? id;
  String? userFullname;
  String? userEmail;
  String? userPhonenumber;
  String? userType;
  bool? isLoggedIn;
  String? userImage;
  String? userToken;
  String? sex;
  String? createdAt;
  String? updatedAt;
  Student? student;
  Bachelorean? bachelorean;
  String? messege;
  int? subjectYear;
  AuthResponse(
      {this.id,
      this.userFullname,
      this.userEmail,
      this.userPhonenumber,
      this.userType,
      this.isLoggedIn,
      this.userImage,
      this.userToken,
      this.sex,
      this.createdAt,
      this.updatedAt,
      this.messege,
      this.student,
      this.subjectYear,
      this.bachelorean});

  AuthResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userFullname = json['user_fullname'];
    userEmail = json['user_email'];
    userPhonenumber = json['user_phonenumber'];
    userType = json['user_type'];
    isLoggedIn = json['is_logged_in'];
    userImage = json['user_image'];
    userToken = json['user_token'];
    sex = json['sex'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    messege = json['message'];
    subjectYear = json['subject_year_id'];
    student =
        json['student'] != null ? new Student.fromJson(json['student']) : null;
    bachelorean = json['bachelorean'] != null
        ? new Bachelorean.fromJson(json['bachelorean'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_fullname'] = this.userFullname;
    data['user_email'] = this.userEmail;
    data['user_phonenumber'] = this.userPhonenumber;
    data['user_type'] = this.userType;
    data['is_logged_in'] = this.isLoggedIn;
    data['user_image'] = this.userImage;
    data['user_token'] = this.userToken;
    data['sex'] = this.sex;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.student != null) {
      data['student'] = this.student!.toJson();
    }
    if (this.bachelorean != null) {
      data['bachelorean'] = this.bachelorean!.toJson();
    }
    return data;
  }
}

class Student {
  int? id;
  int? studentNumber;
  int? yearId;
  Year? year;

  Student({this.id, this.studentNumber, this.yearId, this.year});

  Student.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentNumber = json['student_number'];
    yearId = json['year_id'];
    year = json['year'] != null ? new Year.fromJson(json['year']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['student_number'] = this.studentNumber;
    data['year_id'] = this.yearId;
    if (this.year != null) {
      data['year'] = this.year!.toJson();
    }
    return data;
  }
}

class Year {
  int? id;
  String? yearName;
  int? collageId;
  Collage? collage;

  Year({this.id, this.yearName, this.collageId, this.collage});

  Year.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yearName = json['year_name'];
    collageId = json['collage_id'];
    collage =
        json['collage'] != null ? new Collage.fromJson(json['collage']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['year_name'] = this.yearName;
    data['collage_id'] = this.collageId;
    if (this.collage != null) {
      data['collage'] = this.collage!.toJson();
    }
    return data;
  }
}

class Collage {
  int? id;
  String? collageName;
  int? universityId;
  University? university;

  Collage({this.id, this.collageName, this.universityId, this.university});

  Collage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    collageName = json['collage_name'];
    universityId = json['university_id'];
    university = json['university'] != null
        ? new University.fromJson(json['university'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['collage_name'] = this.collageName;
    data['university_id'] = this.universityId;
    if (this.university != null) {
      data['university'] = this.university!.toJson();
    }
    return data;
  }
}

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

class Bachelorean {
  int? id;
  String? state;
  int? bachelorId;
  Bachelor? bachelor;

  Bachelorean({this.id, this.state, this.bachelorId, this.bachelor});

  Bachelorean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    state = json['state'];
    bachelorId = json['bachelor_id'];
    bachelor = json['bachelor'] != null
        ? new Bachelor.fromJson(json['bachelor'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['state'] = this.state;
    data['bachelor_id'] = this.bachelorId;
    if (this.bachelor != null) {
      data['bachelor'] = this.bachelor!.toJson();
    }
    return data;
  }
}

class Bachelor {
  int? id;
  String? bachelorName;

  Bachelor({this.id, this.bachelorName});

  Bachelor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bachelorName = json['bachelor_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bachelor_name'] = this.bachelorName;
    return data;
  }
}
