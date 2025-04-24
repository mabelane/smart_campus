import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupController extends GetxController {
  var isLoading = false.obs;
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  static SignupController get instance => Get.find();

  //variables
  final hidePassword = true.obs;
  final hideConfirmPassword = true.obs;
  final hidePasswordIcon = Icons.visibility_off.obs;
  final hideConfirmPasswordIcon = Icons.visibility_off.obs;
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  Future<void> signup() async {
    isLoading.value = true;

    try {
      if (signupFormKey.currentState!.validate()) return;

      final url = Uri.parse('https://your-node-api.com/signup');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstname': firstname.text,
          'lastname': lastname.text,
          'email': email.text,
          'password': password.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Handle success response
        Get.snackbar('Success', 'Signup successful!');
      } else {
        final errorData = jsonDecode(response.body);
        // Handle error response
        Get.snackbar('Error', errorData['message'] ?? 'Signup failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
