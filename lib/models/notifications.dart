class NotificationModel {
  final String? id;
  final String message;
  final String? audience;
  final DateTime createdAt;

  NotificationModel({
    this.id,
    required this.message,
    this.audience,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      message: json['message'],
      audience: json['audience'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'message': message,
      'audience': audience,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
