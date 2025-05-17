class BookingModel {
  final String id;
  final String userId;
  final String room;
  final String appointmentType;
  final DateTime startTime;
  final DateTime endTime;
  final String? googleEventId;
  final String status;

  BookingModel({
    required this.id,
    required this.userId,
    required this.room,
    required this.appointmentType,
    required this.startTime,
    required this.endTime,
    this.googleEventId,
    required this.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['_id'],
      userId: json['userId'],
      room: json['room'],
      appointmentType: json['appointmentType'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      googleEventId: json['googleEventId'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'room': room,
      'appointmentType': appointmentType,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'googleEventId': googleEventId,
      'status': status,
    };
  }
}
