import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/auth_service.dart';
import '../../services/sessions.dart';
import '../../view/admin/admin_dashboard.dart';
import '../../view/admin/admin_sidebar.dart';
import '../../view/lecture/lecture_home.dart';
import '../../view/login_signup/loginui.dart';
import '../../view/students/student_home.dart';
import '../storage/token_storage.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;
  final session = Get.find<UserSession>();

  Future<void> login() async {
    isLoading.value = true;

    try {
      final url = Uri.parse(
        'https://smart-campus-9xjl.onrender.com/api/auth/login',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.value.trim(),
          'password': password.value.trim(),
        }),
      );

      isLoading.value = false;

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body != null && body['token'] != null) {
          final token = body['token'];

          // Save token securely
          await TokenStorage.saveToken(token);

          // Extract role and userId from token (assuming your AuthService does this)
          final role = AuthService.extractRole(token);
          final userId = AuthService.extractUserId(token);

          // Save userId in session for easy access later
          if (userId.isNotEmpty) {
            session.userId.value = userId;
          } else {
            Get.snackbar('Login Error', 'User ID missing from token.');
            return;
          }

          // Navigate based on role
          if (role == 'Student') {
            Get.offAll(() => StudentHome());
          } else if (role == 'Lecturer') {
            Get.offAll(() => LecturerDashboard());
          } else if (role == 'Admin') {
            Get.offAll(() => AdminManagementSidebar());
          } else {
            Get.snackbar('Login Error', 'Unknown user role');
          }
        } else {
          Get.snackbar('Login Failed', 'Missing token in response.');
        }
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar('Login Failed', error['message'] ?? 'Invalid credentials');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'An unexpected error occurred.');
      print('Login error: $e');
    }
  }

  Future<void> logout() async {
    await TokenStorage.deleteToken();
    session.clear(); // Clear stored session data if you have a clear method
    Get.offAll(() => LoginUI());
  }
}
