import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/controllers/enroll_controller.dart';

class EnrolledStudentsPage extends StatelessWidget {
  final EnrollmentController enrollmentController = Get.put(
    EnrollmentController(),
  );

  EnrolledStudentsPage({super.key}) {
    String courseId = '12345'; // or pass it from previous screen
    enrollmentController.getCourseEnrollments(courseId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enrolled Students')),
      body: Obx(() {
        if (enrollmentController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: enrollmentController.enrollments.length,
          itemBuilder: (context, index) {
            final student = enrollmentController.enrollments[index];
            return ListTile(
              title: Text(student.studentId),
              subtitle: Text(student.studentId),
            );
          },
        );
      }),
    );
  }
}
