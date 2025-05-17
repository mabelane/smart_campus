import 'package:get/get.dart';

import '../../models/course.dart';
import '../../services/api_service.dart';

class CourseController extends GetxController {
  final ApiService api = Get.find<ApiService>();

  var courses = <CourseModel>[].obs;
  var filteredCourses = <CourseModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCourses();
  }

  // Fetch all courses
  Future<void> fetchCourses() async {
    isLoading.value = true;
    try {
      final res = await api.getCourses();
      if (res.isOk && res.body != null) {
        final List<dynamic> data = res.body;
        courses.assignAll(data.map((e) => CourseModel.fromJson(e)).toList());
        filteredCourses.value = courses;
      } else {
        Get.snackbar('Error', 'Failed to fetch courses');
      }
    } catch (e) {
      "Error fetching courses: $e";
    }
    isLoading.value = false;
  }

  // Create a new course
  Future<void> createCourse(CourseModel course) async {
    isLoading.value = true;
    try {
      final res = await api.createCourse(course.toJson());
      if (res.isOk) {
        Get.snackbar('Success', 'Course created successfully');
        await fetchCourses();
      } else {
        Get.snackbar('Error', 'Failed to create course');
      }
    } catch (e) {
      "Error creating course: $e";
    }
    isLoading.value = false;
  }

  // Search/filter courses
  void searchCourses(String query) {
    filteredCourses.value =
        courses
            .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
  }
}
