import 'package:get/get.dart';
import '../../models/booking.dart';
import '../../services/api_service.dart';

class BookingController extends GetxController {
  final ApiService api = Get.find<ApiService>();

  var bookings = <BookingModel>[].obs;
  var isLoading = false.obs;

  // Fetch single booking by ID
  Future<void> fetchBookingById(String id) async {
    isLoading.value = true;
    try {
      final res = await api.getBooking(id);
      if (res.isOk && res.body != null) {
        final booking = BookingModel.fromJson(res.body);
        bookings.value = [booking];
      } else {
        bookings.clear();
      }
    } catch (e) {
      "Error fetching booking: $e";
      bookings.clear();
    }
    isLoading.value = false;
  }

  // Create a new booking
  Future<void> createBooking(BookingModel booking) async {
    isLoading.value = true;
    try {
      final res = await api.createBooking(booking.toJson());
      if (res.isOk && res.body != null) {
        final newBooking = BookingModel.fromJson(res.body);
        bookings.add(newBooking);
      } else {
        Get.snackbar('Error', 'Failed to create booking');
      }
    } catch (e) {
      "Error creating booking: $e";
      Get.snackbar('Error', 'Failed to create booking');
    }
    isLoading.value = false;
  }

  // Update booking by ID
  Future<void> updateBookingById(
    String id,
    Map<String, dynamic> updates,
  ) async {
    isLoading.value = true;
    try {
      final res = await api.updateBooking(id, updates);
      if (res.isOk && res.body != null) {
        final updated = BookingModel.fromJson(res.body);
        final index = bookings.indexWhere((b) => b.id == id);
        if (index != -1) {
          bookings[index] = updated;
        }
      } else {
        Get.snackbar('Error', 'Failed to update booking');
      }
    } catch (e) {
      "Error updating booking: $e";
      Get.snackbar('Error', 'Failed to update booking');
    }
    isLoading.value = false;
  }

  // Delete booking by ID
  Future<void> deleteBookingById(String id) async {
    isLoading.value = true;
    try {
      final res = await api.deleteBooking(id);
      if (res.isOk) {
        bookings.removeWhere((b) => b.id == id);
        Get.snackbar('Success', 'Booking deleted');
      } else {
        Get.snackbar('Error', 'Failed to delete booking');
      }
    } catch (e) {
      "Error deleting booking: $e";
      Get.snackbar('Error', 'Failed to delete booking');
    }
    isLoading.value = false;
  }
}
