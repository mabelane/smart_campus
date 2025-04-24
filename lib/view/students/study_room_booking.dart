import 'package:flutter/material.dart';

class StudyRoomBooking extends StatelessWidget {
  const StudyRoomBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Study Room Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Date',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Pick a date',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () {
                // Add date picker logic here
              },
            ),
            SizedBox(height: 20),
            Text(
              'Select Time Slot',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(border: OutlineInputBorder()),
              items: [
                DropdownMenuItem(
                  value: '9:00 AM - 11:00 AM',
                  child: Text('9:00 AM - 11:00 AM'),
                ),
                DropdownMenuItem(
                  value: '11:00 AM - 1:00 PM',
                  child: Text('11:00 AM - 1:00 PM'),
                ),
                DropdownMenuItem(
                  value: '2:00 PM - 4:00 PM',
                  child: Text('2:00 PM - 4:00 PM'),
                ),
              ],
              onChanged: (value) {
                // Handle time slot selection
              },
              hint: Text('Select a time slot'),
            ),
            SizedBox(height: 20),
            Text(
              'Room Number',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter room number',
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add booking logic here
                },
                child: Text('Book Room'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
