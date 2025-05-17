import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/controllers/timetable_controller.dart';

class TimetableCreationDialog extends StatelessWidget {
  final TextEditingController courseIdController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController roomController = TextEditingController();

  final TimetableController timetableController = Get.find();

  TimetableCreationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Timetable Entry'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(controller: courseIdController, decoration: const InputDecoration(labelText: 'Course ID')),
            TextField(controller: dayController, decoration: const InputDecoration(labelText: 'Day (e.g. Monday)')),
            TextField(controller: startTimeController, decoration: const InputDecoration(labelText: 'Start Time')),
            TextField(controller: endTimeController, decoration: const InputDecoration(labelText: 'End Time')),
            TextField(controller: roomController, decoration: const InputDecoration(labelText: 'Room')),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            await timetableController.createTimetableEntry({
              'courseId': courseIdController.text,
              'dayOfWeek': dayController.text,
              'startTime': startTimeController.text,
              'endTime': endTimeController.text,
              'room': roomController.text,
            });
            Get.back();
            Get.snackbar('Success', 'Timetable created successfully');
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
