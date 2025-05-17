import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../models/course.dart';
import '../../utils/controllers/admin_controller.dart';
import '../../utils/controllers/course_controller.dart';
import '../../utils/controllers/enroll_controller.dart';
import '../../utils/controllers/timetable_controller.dart';
import '../shared/timetable_creation.dart';
import 'student_enrollment_dialog.dart';

class AdminDashboard extends StatelessWidget {
  final AdminController adminController = Get.put(AdminController());
  final TimetableController timetableController = Get.put(
    TimetableController(),
  );
  final EnrollmentController enrollmentController = Get.put(
    EnrollmentController(),
  );
  final _viewEnrolledCourseId = TextEditingController();
  final RxList<Map<String, dynamic>> enrolledStudents =
      <Map<String, dynamic>>[].obs;
  final courseController = Get.find<CourseController>();

  AdminDashboard({super.key});

  final studentIdController = TextEditingController();
  final courseIdController = TextEditingController();
  final timetableCourseIdController = TextEditingController();
  final timetableTimeController = TextEditingController();

  void _showCourseListDialog() {
    final courseController = Get.find<CourseController>();
    courseController.fetchCourses(); // Make sure it's updated

    Get.defaultDialog(
      title: 'All Courses',
      content: SizedBox(
        width: 300,
        height: 400,
        child: Obx(() {
          if (courseController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: courseController.courses.length,
            itemBuilder: (context, index) {
              final course = courseController.courses[index];
              return ListTile(
                title: Text(course.name),
                subtitle: Text(course.description ?? ''),
              );
            },
          );
        }),
      ),
      textConfirm: 'Close',
      onConfirm: () => Get.back(),
    );
  }

  void _showAddCourseDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    Get.defaultDialog(
      title: 'Add New Course',
      content: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Course Name'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      textCancel: 'Cancel',
      textConfirm: 'Add',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        final newCourse = CourseModel(
          name: nameController.text,
          description: descriptionController.text,
        );
        await courseController.createCourse(newCourse);
        await courseController.fetchCourses();
        Get.back();
        //Get.snackbar('Success', 'Course added successfully');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Obx(
        () =>
            adminController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          _buildStatCard(
                            'Users',
                            adminController.userCount.value.toString(),
                            Colors.blue,
                          ),
                          _buildStatCard(
                            'Courses',
                            adminController.courseCount.value.toString(),
                            Colors.green,
                          ),
                          _buildStatCard(
                            'Bookings',
                            adminController.bookingCount.value.toString(),
                            Colors.orange,
                          ),
                          _buildStatCard(
                            'Issues',
                            adminController.issueCount.value.toString(),
                            Colors.red,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'User Distribution',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // SizedBox(
                      //   height: 200,
                      //   child: PieChart(
                      //     PieChartData(
                      //       sections:
                      //           adminController.userRoleDistribution
                      //               .map(
                      //                 (e) => PieChartSectionData(
                      //                   color: e['color'],
                      //                   value: e['value'],
                      //                   title: e['label'],
                      //                   radius: 50,
                      //                 ),
                      //               )
                      //               .toList(),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                      const Text(
                        'Bookings vs Issues',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [
                                  BarChartRodData(
                                    toY:
                                        adminController.bookingCount.value
                                            .toDouble(),
                                    color: Colors.orange,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 1,
                                barRods: [
                                  BarChartRodData(
                                    toY:
                                        adminController.issueCount.value
                                            .toDouble(),
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ],
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        value == 0 ? 'Bookings' : 'Issues',
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Recent Activity',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ...adminController.recentActivities.map(
                        (activity) => ListTile(
                          leading: Icon(
                            Icons.circle,
                            color: Colors.grey.shade700,
                          ),
                          title: Text(activity['title']),
                          subtitle: Text(activity['description']),
                          trailing: Text(activity['time']),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'View Enrolled Students',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: _viewEnrolledCourseId,
                        decoration: const InputDecoration(
                          labelText: 'Course ID',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await enrollmentController.getStudentEnrollments(
                            _viewEnrolledCourseId.text,
                          );
                          //enrolledStudents.assignAll(students);
                        },
                        child: const Text('Fetch Students'),
                      ),
                      Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              enrolledStudents
                                  .map(
                                    (student) => ListTile(
                                      title: Text(student['name'] ?? 'No Name'),
                                      subtitle: Text(
                                        'ID: ${student['id'] ?? 'N/A'}',
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
      ),

      //floatingActionButton section
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'timetableBtn',
            icon: const Icon(Icons.schedule),
            label: const Text('Create Timetable'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => TimetableCreationDialog(),
              );
            },
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            heroTag: 'enrollBtn',
            icon: const Icon(Icons.school),
            label: const Text('Enroll Student'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => StudentEnrollmentDialog(),
              );
            },
          ),

          const SizedBox(height: 16),

          FloatingActionButton.extended(
            heroTag: 'addCourseBtn',
            icon: const Icon(Icons.add),
            label: const Text('Add Course'),
            onPressed: () {
              _showAddCourseDialog();
            },
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            heroTag: 'viewCoursesBtn',
            icon: const Icon(Icons.list),
            label: const Text('View Courses'),
            onPressed: _showCourseListDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      width: 160,
      height: 100,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 16, color: color)),
          ],
        ),
      ),
    );
  }
}
