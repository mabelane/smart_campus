import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/authentication/validation.dart';
import '../../utils/controllers/signup_controller.dart';

class SignupUI extends StatelessWidget {
  SignupUI({super.key});

  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: width * 0.4,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  /// Full Name
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Full Name"),
                    validator: Validator.validateName,
                    onChanged: (value) => controller.name.value = value,
                  ),
                  const SizedBox(height: 16),

                  /// Student Number (Optional)
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Student Number (Optional)",
                    ),
                    onChanged: (val) => controller.studentNumber.value = val,
                  ),
                  const SizedBox(height: 16),

                  /// Email
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Email"),
                    validator: Validator.validateEmail,
                    onChanged: (value) => controller.email.value = value,
                  ),
                  const SizedBox(height: 16),

                  /// Password
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Password"),
                    obscureText: true,
                    validator: Validator.validatePassword,
                    onChanged: (value) => controller.password.value = value,
                  ),
                  const SizedBox(height: 16),

                  /// Phone Number
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                    ),
                    validator: Validator.validatePhone,
                    onChanged: (value) => controller.phone.value = value,
                  ),
                  const SizedBox(height: 16),

                  /// Department
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Department"),
                    validator: Validator.validateRequiredField,
                    onChanged: (value) => controller.department.value = value,
                  ),
                  const SizedBox(height: 16),

                  /// Role Dropdown
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Role"),
                    value: controller.role.value,
                    items:
                        ['Student', 'Lecturer', 'Admin'].map((role) {
                          return DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                    onChanged: (val) {
                      if (val != null) controller.role.value = val;
                    },
                  ),
                  const SizedBox(height: 24),

                  /// Submit Button
                  Obx(
                    () =>
                        controller.isLoading.value
                            ? const CircularProgressIndicator()
                            : SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4A90E2),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    controller.registerUser();
                                  }
                                },
                                child: const Text(
                                  "Register",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
