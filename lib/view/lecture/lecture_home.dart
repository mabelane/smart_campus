import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/timetable.dart';
import '../../utils/controllers/lecture_controller.dart';
import '../../utils/controllers/timetable_controller.dart';
import '../../utils/controllers/booking_controller.dart';

class LecturerDashboard extends StatefulWidget {
  const LecturerDashboard({super.key});

  @override
  State<LecturerDashboard> createState() => _LecturerDashboardState();
}

class _LecturerDashboardState extends State<LecturerDashboard> {
  final TimetableController timetableController = Get.put(
    TimetableController(),
  );
  final LecturerController lecturerController = Get.put(LecturerController());
  final BookingController bookingController = Get.put(BookingController());

  int selectedIndex = 0;

  final TextEditingController _courseIdController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.schedule),
                label: Text('Timetable'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.book),
                label: Text('Bookings'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people),
                label: Text('Enrolled Students'),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: _buildPage(selectedIndex)),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(selectedIndex),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return Obx(() {
          if (timetableController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: timetableController.timetableEntries.length,
            itemBuilder: (context, index) {
              final entry = timetableController.timetableEntries[index];
              return ListTile(
                title: Text("Course: ${entry.courseId} (${entry.dayOfWeek})"),
                subtitle: Text(
                  "Time: ${entry.startTime} - ${entry.endTime} | Room: ${entry.room}",
                ),
              );
            },
          );
        });

      case 1:
        return Obx(() {
          if (bookingController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: bookingController.bookings.length,
            itemBuilder: (context, index) {
              final booking = bookingController.bookings[index];
              return ListTile(
                //title: Text("Booking by ${booking.studentId}"),
                //subtitle: Text("For Course: ${booking.courseId}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () {
                        bookingController.updateBookingById(booking.id, {
                          'status': 'accepted',
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        bookingController.updateBookingById(booking.id, {
                          'status': 'declined',
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          );
        });
      case 2:
        return Obx(() {
          if (lecturerController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: lecturerController.bookings.length,
            itemBuilder: (context, index) {
              final enrolled = lecturerController.bookings[index];
              return ListTile(
                title: Text(
                  "Enrolled Student: ${enrolled['studentName'] ?? 'Unknown'}",
                ),
                subtitle: Text("Course: ${enrolled['courseId'] ?? 'N/A'}"),
              );
            },
          );
        });
      default:
        return const Center(child: Text("Select a page"));
    }
  }

  Widget? _buildFloatingActionButton(int index) {
    if (index == 0) {
      // Controllers for all fields
      final courseIdController = TextEditingController();
      final dayOfWeekController = TextEditingController();
      final startTimeController = TextEditingController();
      final endTimeController = TextEditingController();
      final roomController = TextEditingController();

      return FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Timetable'),
        onPressed: () {
          Get.defaultDialog(
            title: 'Create Timetable Entry',
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: courseIdController,
                    decoration: const InputDecoration(labelText: 'Course ID'),
                  ),
                  TextField(
                    controller: dayOfWeekController,
                    decoration: const InputDecoration(labelText: 'Day of Week'),
                  ),
                  TextField(
                    controller: startTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Start Time (e.g. 09:00)',
                    ),
                  ),
                  TextField(
                    controller: endTimeController,
                    decoration: const InputDecoration(
                      labelText: 'End Time (e.g. 11:00)',
                    ),
                  ),
                  TextField(
                    controller: roomController,
                    decoration: const InputDecoration(labelText: 'Room'),
                  ),
                ],
              ),
            ),
            textConfirm: 'Create',
            onConfirm: () async {
              final newEntry = TimetableModel(
                id: '',
                courseId: courseIdController.text,
                dayOfWeek: dayOfWeekController.text,
                startTime: startTimeController.text,
                endTime: endTimeController.text,
                room: roomController.text,
              );
              await timetableController.createTimetableEntry(newEntry.toJson());
              Get.back();
            },
          );
        },
      );
    }
    return null;
  }
}
