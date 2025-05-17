import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final token = ''.obs;
  final user = {}.obs;

  final baseUrl = 'https://smart-campus-9xjl.onrender.com/api/auth';

  @override
  void onInit() {
    super.onInit();
    loadUserFromPrefs(); // auto-load on start
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        token.value = data['token'];
        user.value = data['user'];
        await saveUserToPrefs();
        Get.snackbar('Success', 'Logged in successfully');
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Login failed';
        Get.snackbar('Error', error);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String role,
  ) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        }),
      );
      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Registered successfully');
      } else {
        final error =
            jsonDecode(response.body)['error'] ?? 'Registration failed';
        Get.snackbar('Error', error);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/updateUser/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token.value}',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final updatedUser = jsonDecode(response.body);
        user.value = updatedUser;
        await saveUserToPrefs();
        Get.snackbar('Success', 'User updated');
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Update failed';
        Get.snackbar('Error', error);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update user: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/deleteUser/$userId'),
        headers: {'Authorization': 'Bearer ${token.value}'},
      );
      if (response.statusCode == 200) {
        await logout();
        Get.snackbar('Success', 'User deleted successfully');
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Deletion failed';
        Get.snackbar('Error', error);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete user: $e');
    }
  }

  Future<void> saveUserToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token.value);
    await prefs.setString('user', jsonEncode(user));
  }

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('token');
    final storedUser = prefs.getString('user');

    if (storedToken != null && storedUser != null) {
      token.value = storedToken;
      user.value = jsonDecode(storedUser);
    }
  }

  Future<void> logout() async {
    token.value = '';
    user.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    Get.snackbar('Logged out', 'You have been logged out.');
  }
}
