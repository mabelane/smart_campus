class EnrollmentModel {
  final String studentId;
  final String courseId;

  EnrollmentModel({required this.studentId, required this.courseId});

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      studentId: json['studentId'],
      courseId: json['courseId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'studentId': studentId, 'courseId': courseId};
  }
}
