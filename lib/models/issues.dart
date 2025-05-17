class IssueModel {
  final String id;
  final String title;
  final String? description;
  final String? location;
  final String reportedBy;
  final String status;
  final DateTime createdAt;

  IssueModel({
    required this.id,
    required this.title,
    this.description,
    this.location,
    required this.reportedBy,
    required this.status,
    required this.createdAt,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      reportedBy: json['reportedBy'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'location': location,
      'reportedBy': reportedBy,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
