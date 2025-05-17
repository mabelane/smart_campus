import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/course.dart';
import '../../utils/controllers/course_controller.dart';

class CourseManagementScreen extends StatelessWidget {
  final CourseController courseController = Get.find<CourseController>();

  CourseManagementScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => courseController.fetchCourses(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) => courseController.searchCourses(value),
              decoration: InputDecoration(
                hintText: 'Search courses...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Course List
          Expanded(
            child: Obx(() {
              if (courseController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (courseController.filteredCourses.isEmpty) {
                return const Center(child: Text('No courses found.'));
              }
              return ListView.builder(
                itemCount: courseController.filteredCourses.length,
                itemBuilder: (context, index) {
                  CourseModel course = courseController.filteredCourses[index];
                  return ListTile(
                    title: Text(course.name),
                    subtitle: Text(course.description ?? ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // you can add delete logic here if you implement it in controller
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),

      // Add Course Button
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCourseDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCourseDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

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
      onConfirm: () {
        final newCourse = CourseModel(
          name: nameController.text,
          description: descriptionController.text,
        );
        courseController.createCourse(newCourse);
        Get.back();
      },
    );
  }
}
