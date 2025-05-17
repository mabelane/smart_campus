import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Model for Lecture Appointment
class Lecture {
  final String id;
  final String title;
  final String time;
  final bool isBooked;

  Lecture({
    required this.id,
    required this.title,
    required this.time,
    required this.isBooked,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) {
    return Lecture(
      id: json['id'],
      title: json['title'],
      time: json['time'],
      isBooked: json['isBooked'],
    );
  }
}

// Controller using GetX for state management
class LectureController extends GetxController {
  var lectures = <Lecture>[].obs;
  var isLoading = false.obs;
  final String apiUrl = 'YOUR_API_BASE_URL'; // Replace with your API base URL

  // Assume you have a user model and role management
  final String userId = 'CURRENT_USER_ID'; // Replace with actual user ID
  final String userRole = 'student'; // Replace with actual role

  @override
  void onInit() {
    super.onInit();
    fetchLectures();
  }

  Future<void> fetchLectures() async {
    if (userRole != 'student') {
      Get.snackbar('Access Denied', 'Only students can view lectures');
      return;
    }
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('$apiUrl/lectures?userId=$userId'),
      );
      if (response.statusCode == 200) {
        var lectureList = json.decode(response.body) as List;
        lectures.value = lectureList.map((e) => Lecture.fromJson(e)).toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch lectures');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch lectures');
    } finally {
      isLoading(false);
    }
  }

  Future<void> bookLecture(String lectureId) async {
    if (userRole != 'student') {
      Get.snackbar('Access Denied', 'Only students can book lectures');
      return;
    }
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/lectures/$lectureId/book'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      );
      if (response.statusCode == 200) {
        await fetchLectures();
        Get.snackbar('Success', 'Lecture booked successfully');
      } else {
        Get.snackbar('Error', 'Failed to book lecture');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to book lecture');
    }
  }
}

// UI Widget
class LectureAppointment extends StatelessWidget {
  final LectureController controller = Get.put(LectureController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lecture Appointments')),
      body: Obx(
        () =>
            controller.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                  itemCount: controller.lectures.length,
                  itemBuilder: (context, index) {
                    final lecture = controller.lectures[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(lecture.title),
                        subtitle: Text(lecture.time),
                        trailing:
                            lecture.isBooked
                                ? Text(
                                  'Booked',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                                : ElevatedButton(
                                  onPressed:
                                      () => controller.bookLecture(lecture.id),
                                  child: Text('Book'),
                                ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
