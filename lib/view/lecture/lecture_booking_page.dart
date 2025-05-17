import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/controllers/lecture_controller.dart';

class BookingsPage extends StatelessWidget {
  final LecturerController controller = Get.find();

  BookingsPage({super.key}) {
    controller.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bookings')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.bookings.length,
          itemBuilder: (context, index) {
            final booking = controller.bookings[index];
            return ListTile(
              title: Text(booking['courseName'] ?? 'No Name'),
              subtitle: Text(booking['status'] ?? 'Pending'),
              trailing: ElevatedButton(
                onPressed: () {
                  controller.updateBooking(booking['_id'], {
                    'status': 'accepted',
                  });
                },
                child: Text('Accept'),
              ),
            );
          },
        );
      }),
    );
  }
}
