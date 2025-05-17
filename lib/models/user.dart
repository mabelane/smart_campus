class User {
  String id;
  String name;
  String? studentNumber;
  String email;
  String role;
  String? department;
  String? phone;
  String? profilePicture;
  DateTime? createdAt;

  User({
    required this.id,
    required this.name,
    this.studentNumber,
    required this.email,
    required this.role,
    this.department,
    this.phone,
    this.profilePicture,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      studentNumber: json['studentNumber'],
      email: json['email'],
      role: json['role'],
      department: json['department'],
      phone: json['phone'],
      profilePicture: json['profilePicture'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'studentNumber': studentNumber,
      'email': email,
      'role': role,
      'department': department,
      'phone': phone,
      'profilePicture': profilePicture,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
