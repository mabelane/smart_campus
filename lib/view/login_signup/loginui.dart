import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/authentication/validation.dart';
import '../../utils/constant/strings.dart';
import '../../utils/controllers/login_controller.dart';
import 'signupui.dart';

class LoginUI extends StatelessWidget {
  LoginUI({super.key});
  final _formKey = GlobalKey<FormState>();
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            width: width * 0.35,
            height: height * 0.65,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //email
                  TextFormField(
                    validator: (value) => Validator.validateEmail(value),
                    decoration: const InputDecoration(labelText: ATexts.email),
                    onChanged: (value) => controller.email.value = value,
                  ),
                  SizedBox(height: 20),

                  //password
                  TextFormField(
                    validator: (value) => Validator.validatePassword(value),
                    decoration: InputDecoration(labelText: ATexts.password),
                    obscureText: true,
                    onChanged: (value) => controller.password.value = value,
                  ),

                  SizedBox(height: 20),
                  //remember me and forgot password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Remember Me"),
                      SizedBox(
                        height: 20,
                        child: TextButton(
                          onPressed: () {
                            // Handle forgot password action
                          },
                          child: const Text(ATexts.forgotPassword),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30),
                  //login button
                  Obx(
                    () =>
                        controller.isLoading.value
                            ? CircularProgressIndicator()
                            : SizedBox(
                              width: width,
                              height: 40,
                              child: MaterialButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    controller.login();
                                  }
                                },
                                color: const Color(0xFF4A90E2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Text(ATexts.signInTitle),
                              ),
                            ),
                  ),
                  SizedBox(height: 20),
                  //sign up button
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(ATexts.noAccount),
                      TextButton(
                        onPressed: () => Get.to(() => SignupUI()),
                        child: const Text(ATexts.signUpTitle),
                      ),
                    ],
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
