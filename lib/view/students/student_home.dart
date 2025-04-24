import 'package:flutter/material.dart';

import 'lecture_appointment.dart';
import 'study_room_booking.dart' show StudyRoomBooking;

class StudentHome extends StatelessWidget {
  const StudentHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HomeOptionCard(
              title: 'Study Room Booking',
              description: 'Book a study room for group or individual study.',
              icon: Icons.meeting_room,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudyRoomBooking()),
                );
              },
            ),
            SizedBox(height: 16),
            HomeOptionCard(
              title: 'Appointments with Lecturers',
              description: 'Schedule an appointment with your lecturer.',
              icon: Icons.calendar_today,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LectureAppointment()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HomeOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const HomeOptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, size: 40, color: Theme.of(context).primaryColor),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        onTap: onTap,
      ),
    );
  }
}
