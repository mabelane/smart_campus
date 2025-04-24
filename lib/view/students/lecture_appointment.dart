import 'package:flutter/material.dart';

class LectureAppointment extends StatefulWidget {
  const LectureAppointment({super.key});

  @override
  _LectureAppointmentState createState() => _LectureAppointmentState();
}

class _LectureAppointmentState extends State<LectureAppointment> {
  final List<Map<String, dynamic>> lectures = [
    {'title': 'Mathematics', 'time': '10:00 AM - 11:00 AM', 'isBooked': false},
    {'title': 'Physics', 'time': '11:30 AM - 12:30 PM', 'isBooked': true},
    {'title': 'Chemistry', 'time': '1:00 PM - 2:00 PM', 'isBooked': false},
    {'title': 'Biology', 'time': '2:30 PM - 3:30 PM', 'isBooked': true},
  ];

  void bookLecture(int index) {
    setState(() {
      lectures[index]['isBooked'] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lecture Appointments')),
      body: ListView.builder(
        itemCount: lectures.length,
        itemBuilder: (context, index) {
          final lecture = lectures[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(lecture['title']),
              subtitle: Text(lecture['time']),
              trailing:
                  lecture['isBooked']
                      ? Text(
                        'Booked',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      : ElevatedButton(
                        onPressed: () => bookLecture(index),
                        child: Text('Book'),
                      ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: LectureAppointment()));
}
