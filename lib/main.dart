import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'services/sessions.dart';
import 'view/bindings/initial_binding.dart';
import 'view/login_signup/loginui.dart';

void main() async {
  await GetStorage.init();
  Get.put<UserSession>(UserSession());
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialBinding: InitialBinding(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LoginUI(),
    ),
  );
}
