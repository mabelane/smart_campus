import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_campus/utils/authentication/validation.dart';

import '../../utils/authentication/controllers/signup/signup_controller.dart';
import '../../utils/constant/strings.dart';

class SignupUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text(ATexts.signUpTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.signupFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.firstname,
                decoration: InputDecoration(
                  labelText: ATexts.firstName,
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) => Validator.validateEmptyText("First Name", value),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: controller.lastname,
                decoration: InputDecoration(
                  labelText: ATexts.lastName,
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) => Validator.validateEmptyText("Last Name", value),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: controller.email,
                decoration: InputDecoration(
                  labelText: ATexts.email,
                  border: OutlineInputBorder(),
                ),
                validator: (value) => Validator.validateEmail(value),
              ),
              SizedBox(height: 16),
              Obx(
                () => TextFormField(
                  obscureText: controller.hidePassword.value,
                  controller: controller.password,
                  validator: (value) => Validator.validatePassword(value),
                  decoration: InputDecoration(
                    labelText: ATexts.password,
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.hidePassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        controller.hidePassword.value =
                            !controller.hidePassword.value;
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => controller.signup(),
                child: Text(ATexts.signUpTitle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
