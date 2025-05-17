import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/controllers/timetable_controller.dart';

class LecturerTimetablePage extends StatelessWidget {
  final TimetableController timetableController = Get.put(
    TimetableController(),
  );
  final _courseIdController = TextEditingController();
  final _timeController = TextEditingController();

  LecturerTimetablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lecturer Timetable')),
      body: Obx(() {
        if (timetableController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: timetableController.timetableEntries.length,
          itemBuilder: (context, index) {
            final entry = timetableController.timetableEntries[index];
            return ListTile(
              title: Text("Course: ${entry.courseId}"),
              //subtitle: Text("Time: ${entry.time}"),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Timetable'),
        onPressed: () {
          Get.defaultDialog(
            title: 'Create Timetable Entry',
            content: Column(
              children: [
                TextField(
                  controller: _courseIdController,
                  decoration: const InputDecoration(labelText: 'Course ID'),
                ),
                TextField(
                  controller: _timeController,
                  decoration: const InputDecoration(labelText: 'Time'),
                ),
              ],
            ),
            textConfirm: 'Create',
            onConfirm: () async {
              final newEntry = {
                'courseId': _courseIdController.text,
                'time': _timeController.text,
              };
              await timetableController.createTimetableEntry(newEntry);
              Get.back();
            },
          );
        },
      ),
    );
  }
}
