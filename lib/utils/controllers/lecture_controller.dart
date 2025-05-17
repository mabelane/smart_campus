import 'package:get/get.dart';
import '../../services/api_service.dart';

class LecturerController extends GetxController {
  final api = Get.find<ApiService>();

  var bookings = [].obs;
  var timetable = [].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  void fetchData() async {
    isLoading.value = true;
    try {
      final bookingsRes =
          await api
              .getCourses(); // Using getAllCourses as closest to lecturer bookings
      final timetableRes =
          await api
              .getSummary(); // Using summary as placeholder for timetable data

      if (bookingsRes.statusCode == 200) {
        bookings.value = bookingsRes.body;
      }

      if (timetableRes.statusCode == 200) {
        timetable.value = timetableRes.body;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch lecturer data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateBooking(String id, Map<String, dynamic> data) async {
    try {
      final res = await api.updateBooking(id, data);
      if (res.statusCode == 200) {
        fetchData();
        Get.snackbar("Success", "Booking updated successfully");
      } else {
        Get.snackbar("Error", "Failed to update booking");
      }
    } catch (e) {
      Get.snackbar("Error", "Error updating booking: $e");
    }
  }

  Future<void> deleteBooking(String id) async {
    try {
      final res = await api.deleteBooking(id);
      if (res.statusCode == 200) {
        fetchData();
        Get.snackbar("Success", "Booking deleted successfully");
      } else {
        Get.snackbar("Error", "Failed to delete booking");
      }
    } catch (e) {
      Get.snackbar("Error", "Error deleting booking: $e");
    }
  }
}
