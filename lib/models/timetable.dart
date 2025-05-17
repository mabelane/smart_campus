class TimetableModel {
  final String id;
  final String courseId;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String room;

  TimetableModel({
    required this.id,
    required this.courseId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.room,
  });

  factory TimetableModel.fromJson(Map<String, dynamic> json) {
    return TimetableModel(
      id: json['_id'],
      courseId: json['courseId'],
      dayOfWeek: json['dayOfWeek'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      room: json['room'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'courseId': courseId,
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'room': room,
    };
  }
}
