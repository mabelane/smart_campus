class AnnouncementModel {
  final String id;
  final String title;
  final String message;
  final String createdBy;
  final String targetRole;
  final DateTime createdAt;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.message,
    required this.createdBy,
    required this.targetRole,
    required this.createdAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['_id'],
      title: json['title'],
      message: json['message'],
      createdBy: json['created_by'],
      targetRole: json['target_role'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'created_by': createdBy,
      'target_role': targetRole,
    };
  }
}
