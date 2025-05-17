import 'package:flutter/material.dart';

class StudentInfoCard extends StatelessWidget {
  final Map<String, dynamic> student;

  const StudentInfoCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(student['name'] ?? 'No Name'),
        subtitle: Text('ID: ${student['id'] ?? 'N/A'}'),
        leading: const Icon(Icons.person),
      ),
    );
  }
}
