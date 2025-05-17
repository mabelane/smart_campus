import 'package:get/get.dart';
import '../../models/enrollment.dart';
import '../../services/api_service.dart';

class EnrollmentController extends GetxController {
  final ApiService api = Get.find<ApiService>();

  var enrollments = <EnrollmentModel>[].obs;
  var isLoading = false.obs;

  // Enroll a student
  Future<void> enrollStudent(String studentId, String courseId) async {
    isLoading.value = true;
    try {
      final res = await api.enrollStudent({
        'studentId': studentId,
        'courseId': courseId,
      });

      if (res.isOk && res.body != null) {
        final newEnrollment = EnrollmentModel.fromJson(res.body);
        enrollments.add(newEnrollment);
      }
    } catch (e) {
      "Error enrolling student: $e";
    }
    isLoading.value = false;
  }

  // Get enrollments for a student
  Future<void> getStudentEnrollments(String userId) async {
    isLoading.value = true;
    try {
      final res = await api.getStudentEnrollments(userId);
      if (res.isOk && res.body != null) {
        final List<dynamic> data = res.body;
        enrollments.assignAll(
          data.map((e) => EnrollmentModel.fromJson(e)).toList(),
        );
      }
    } catch (e) {
      "Error fetching student enrollments: $e";
      enrollments.clear();
    }
    isLoading.value = false;
  }

  // Get enrollments for a course
  Future<void> getCourseEnrollments(String courseId) async {
    isLoading.value = true;
    try {
      final res = await api.getCourseEnrollments(courseId);
      if (res.isOk && res.body != null) {
        final List<dynamic> data = res.body;
        enrollments.assignAll(
          data.map((e) => EnrollmentModel.fromJson(e)).toList(),
        );
      }
    } catch (e) {
      "Error fetching course enrollments: $e";
      enrollments.clear();
    }
    isLoading.value = false;
  }
}
