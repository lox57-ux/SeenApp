import '../LocalDataSource.dart/LocalData.dart';

class Links {
  int? id;
  String? url;
  String? description;

  Links({this.id, this.url, this.description});

  Links.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data[linkDescription] = this.description;
    return data;
  }
}
