import 'package:get/get.dart';
import '../../services/api_service.dart';
import '../../view/admin/admin_dashboard.dart';
import '../../view/lecture/lecture_home.dart';
import '../../view/students/student_home.dart';
import '../storage/token_storage.dart';

class RegisterController extends GetxController {
  final api = Get.find<ApiService>();

  var name = ''.obs;
  var studentNumber = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var role = 'Student'.obs;
  var department = ''.obs;
  var phone = ''.obs;
  var isLoading = false.obs;

  void registerUser() async {
    if (email.value.trim().isEmpty ||
        password.value.trim().isEmpty ||
        name.value.trim().isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Name, Email, and Password are required",
      );
      return;
    }

    // Set loading state
    isLoading.value = true;

    try {
      print("Attempting registration for ${email.value}...");

      // Create registration payload
      final payload = {
        "name": name.value.trim(),
        "email": email.value.trim(),
        "password": password.value.trim(),
        "studentNumber":
            studentNumber.value.isEmpty ? null : studentNumber.value.trim(),
        "phone": phone.value.trim(),
        "department": department.value.trim(),
        "role": role.value,
      };

      print("Registration payload: $payload");

      // Make API call with timeout
      final response = await api
          .registerUser(payload)
          .timeout(
            Duration(seconds: 10),
            onTimeout: () {
              throw Exception("Registration request timed out");
            },
          );

      print("Registration response status: ${response.statusCode}");
      print("Registration response body: ${response.body}");

      final responseBody = response.body;

      if (response.statusCode == 200 &&
          responseBody != null &&
          responseBody['token'] != null) {
        final token = responseBody['token'];
        await TokenStorage.saveToken(token);

        // Force loading state to false before navigation
        isLoading.value = false;

        // Get user role - first try from response, then fallback to input
        String userRole = '';
        if (responseBody['user'] != null &&
            responseBody['user']['role'] != null) {
          userRole = responseBody['user']['role'].toString().toLowerCase();
        } else {
          userRole = role.value.toLowerCase();
        }

        print("User role for navigation: $userRole");

        // Separate navigation from API call with slight delay
        Future.delayed(Duration(milliseconds: 100), () {
          // Navigate based on role
          if (userRole == 'student') {
            Get.offAll(() => StudentHome());
          } else if (userRole == 'lecturer') {
            Get.offAll(() => LecturerDashboard());
          } else if (userRole == 'admin') {
            Get.offAll(() => AdminDashboard());
          } else {
            Get.snackbar(
              "Navigation Error",
              "Unrecognized user role: $userRole",
            );
          }
        });
      } else {
        isLoading.value = false;
        String message = "Registration failed";
        if (responseBody is Map && responseBody['message'] != null) {
          message = responseBody['message'];
        }
        Get.snackbar("Error", message);
      }
    } catch (e) {
      print("Registration error: $e");
      isLoading.value = false;
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      // Ensure loading state is reset even if there was an error
      isLoading.value = false;
    }
  }
}
