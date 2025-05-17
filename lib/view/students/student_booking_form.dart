import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/api_service.dart';

class BookingUI extends StatefulWidget {
  final String studentId;
  const BookingUI({super.key, required this.studentId});

  @override
  State<BookingUI> createState() => _BookingUIState();
}

class _BookingUIState extends State<BookingUI> {
  final apiService = ApiService();
  final roomController = TextEditingController();
  final lecturerController = TextEditingController();
  final reasonController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool isLoading = false;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  Future<void> _submitBooking() async {
    if (roomController.text.isEmpty && lecturerController.text.isEmpty) {
      Get.snackbar("Error", "Please enter a room or lecturer name.");
      return;
    }
    setState(() => isLoading = true);
    final data = {
      'studentId': widget.studentId,
      'room': roomController.text.trim(),
      'lecturer': lecturerController.text.trim(),
      'reason': reasonController.text.trim(),
      'date': selectedDate.toIso8601String().split('T').first,
      'time': selectedTime.format(context),
    };
    try {
      final res = await apiService.createBooking(data);
      if (res.body['success'] == true) {
        Get.snackbar("Success", "Booking created successfully");
        roomController.clear();
        lecturerController.clear();
        reasonController.clear();
      } else {
        Get.snackbar("Error", res.body['message'] ?? "Booking failed");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Room or Appointment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: roomController,
              decoration: const InputDecoration(labelText: "Room (Optional)"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: lecturerController,
              decoration: const InputDecoration(
                labelText: "Lecturer (Optional)",
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(labelText: "Reason"),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Date: ${selectedDate.toLocal().toString().split(' ')[0]}",
                  ),
                ),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text("Pick Date"),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child: Text("Time: ${selectedTime.format(context)}")),
                TextButton(
                  onPressed: _pickTime,
                  child: const Text("Pick Time"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: _submitBooking,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text("Submit Booking"),
                ),
          ],
        ),
      ),
    );
  }
}
