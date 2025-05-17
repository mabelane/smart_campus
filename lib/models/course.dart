class CourseModel {
  final String? id;
  final String name;
  final String? description;

  CourseModel({this.id, required this.name, this.description});

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "description": description};
  }
}
