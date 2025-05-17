import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../utils/controllers/booking_controller.dart';
import '../../utils/controllers/student_controller.dart';
import '../../utils/controllers/timetable_controller.dart';
import '../../utils/storage/token_storage.dart';

class StudentHome extends StatefulWidget {
  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  final StudentController controller = Get.put(StudentController());
  final BookingController bookingController = Get.put(BookingController());
  final TimetableController timetableController = Get.put(
    TimetableController(),
  );

  final selectedDay = DateTime.now().obs;

  @override
  void initState() {
    super.initState();
    _fetchTimetable();
  }

  void _fetchTimetable() async {
    final token = await TokenStorage.getToken();
    final userId = controller.session.userId.value;
    if (userId.isNotEmpty && token != null) {
      await timetableController.fetchStudentTimetable(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student Home')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildTimetableCard(),
                    SizedBox(height: 16),
                    _buildReportIssueCard(),
                  ],
                ),
              ),
              SizedBox(width: 16),

              // Right Column
              Expanded(flex: 2, child: _buildBookingsCard()),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTimetableCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Optional: navigate to detailed timetable view
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Timetable',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              timetableController.timetableEntries.isEmpty
                  ? Text("No timetable available.")
                  : TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: selectedDay.value,
                    selectedDayPredicate:
                        (day) => isSameDay(selectedDay.value, day),
                    onDaySelected: (selected, focused) {
                      selectedDay.value = selected;
                    },
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, date, events) {
                        final sessions =
                            timetableController.timetableEntries
                                .where(
                                  (e) =>
                                      _isSameWeekday(e.dayOfWeek, date.weekday),
                                )
                                .toList();
                        if (sessions.isEmpty) return null;
                        return Column(
                          children:
                              sessions
                                  .map(
                                    (s) => Padding(
                                      padding: const EdgeInsets.only(bottom: 2),
                                      child: Text(
                                        s.courseId,
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        );
                      },
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Optional: navigate to bookings management
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Bookings',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              controller.bookings.isEmpty
                  ? Text("No bookings yet.")
                  : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.bookings.length,
                    itemBuilder: (context, index) {
                      final booking = controller.bookings[index];
                      return Card(
                        child: InkWell(
                          onTap: () {
                            // Optional: show booking details
                          },
                          child: ListTile(
                            title: Text("Room: ${booking['room'] ?? 'N/A'}"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Type: ${booking['appointmentType'] ?? 'N/A'}",
                                ),
                                Text("Start: ${booking['startTime'] ?? ''}"),
                                Text("End: ${booking['endTime'] ?? ''}"),
                                Text(
                                  "Status: ${booking['status'] ?? 'pending'}",
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportIssueCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          _showReportIssueDialog();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.report_problem, color: Colors.red),
              SizedBox(width: 10),
              Text('Report an Issue'),
            ],
          ),
        ),
      ),
    );
  }

  bool _isSameWeekday(String modelDay, int calendarWeekday) {
    const dayMap = {
      'Monday': DateTime.monday,
      'Tuesday': DateTime.tuesday,
      'Wednesday': DateTime.wednesday,
      'Thursday': DateTime.thursday,
      'Friday': DateTime.friday,
      'Saturday': DateTime.saturday,
      'Sunday': DateTime.sunday,
    };
    return dayMap[modelDay] == calendarWeekday;
  }

  void _showReportIssueDialog() {
    final issueController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Report an Issue'),
          content: TextField(
            controller: issueController,
            decoration: InputDecoration(labelText: 'Describe your issue'),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () {
                // send issue report logic here
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
