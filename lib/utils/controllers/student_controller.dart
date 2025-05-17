import 'package:get/get.dart';
import '../../services/api_service.dart';
import '../../services/sessions.dart';

class StudentController extends GetxController {
  final api = Get.find<ApiService>();
  final session = Get.find<UserSession>();

  var bookings = [].obs;
  var timetable = [].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchStudentData();
    super.onInit();
  }

  void fetchStudentData() async {
    final userId = session.userId;

    if (userId.isEmpty) {
      Get.snackbar("Error", "User ID is missing. Please log in again.");
      return;
    }

    isLoading.value = true;
    try {
      final bookingsRes = await api.getStudentEnrollments(userId as String);
      final timetableRes = await api.getStudentTimetable(userId as String);

      if (bookingsRes.statusCode == 200) {
        bookings.value = bookingsRes.body;
      }

      if (timetableRes.statusCode == 200) {
        timetable.value = timetableRes.body;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch student data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createBooking(Map<String, dynamic> data) async {
    final userId = session.userId;

    if (userId.isEmpty) {
      Get.snackbar("Error", "User ID is missing. Please log in again.");
      return;
    }

    try {
      final res = await api.createBooking(data);
      if (res.statusCode == 200) {
        fetchStudentData();
        Get.snackbar("Success", "Booking created successfully");
      } else {
        Get.snackbar("Error", "Failed to create booking");
      }
    } catch (e) {
      Get.snackbar("Error", "Error creating booking: $e");
    }
  }

  Future<void> deleteBooking(String id) async {
    final userId = session.userId;

    if (userId == null || userId.isEmpty) {
      Get.snackbar("Error", "User ID is missing. Please log in again.");
      return;
    }

    try {
      final res = await api.deleteBooking(id);
      if (res.statusCode == 200) {
        fetchStudentData();
        Get.snackbar("Success", "Booking deleted successfully");
      } else {
        Get.snackbar("Error", "Failed to delete booking");
      }
    } catch (e) {
      Get.snackbar("Error", "Error deleting booking: $e");
    }
  }
}
