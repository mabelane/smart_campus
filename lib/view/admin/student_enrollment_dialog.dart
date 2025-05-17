import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/controllers/enroll_controller.dart';

class StudentEnrollmentDialog extends StatelessWidget {
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController courseIdController = TextEditingController();

  final EnrollmentController enrollmentController = Get.find();

  StudentEnrollmentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enroll Student'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: studentIdController, decoration: const InputDecoration(labelText: 'Student ID')),
          TextField(controller: courseIdController, decoration: const InputDecoration(labelText: 'Course ID')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            await enrollmentController.enrollStudent(
              studentIdController.text,
              courseIdController.text,
            );
            Get.back();
            Get.snackbar('Success', 'Student enrolled successfully');
          },
          child: const Text('Enroll'),
        ),
      ],
    );
  }
}
