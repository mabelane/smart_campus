import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For formatting datetime
import '../../utils/controllers/booking_controller.dart';

class BookingsManagementPage extends StatelessWidget {
  final BookingController bookingController = Get.find();

  BookingsManagementPage({super.key});

  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Your Bookings')),
      body: Obx(() {
        if (bookingController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return bookingController.bookings.isEmpty
            ? Center(child: Text('No bookings found.'))
            : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookingController.bookings.length,
              itemBuilder: (context, index) {
                final booking = bookingController.bookings[index];
                return Card(
                  child: ListTile(
                    title: Text("Room: ${booking.room}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Type: ${booking.appointmentType}"),
                        Text("Start: ${formatDateTime(booking.startTime)}"),
                        Text("End: ${formatDateTime(booking.endTime)}"),
                        Text("Status: ${booking.status}"),
                      ],
                    ),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to booking details if needed
                    },
                  ),
                );
              },
            );
      }),
    );
  }
}
