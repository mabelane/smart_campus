import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final hidePassword = true.obs;
  final password = TextEditingController();
  final email = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  // Observables
  var isLoading = false.obs;
  //var email = ''.obs;
  //var password = ''.obs;

  Future<void> login() async {
    try {
      if (loginFormKey.currentState!.validate()) {
        isLoading.value = true;
        // Perform login action
        await Future.delayed(const Duration(seconds: 2));
        isLoading.value = false;
      }
    } catch (e) {}
  }

  //   void redirectUser() {
  //   switch (user.role) {
  //     case 'admin':
  //       Navigator.push(context, MaterialPageRoute(builder: (_) => AdminDashboard()));
  //       break;
  //     case 'student':
  //       Navigator.push(context, MaterialPageRoute(builder: (_) => StudentHome()));
  //       break;
  //     // ... other roles
  //   }
  // }
}
