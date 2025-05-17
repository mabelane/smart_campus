import 'package:get/get.dart';

class UserSession extends GetxController {
  var userId = ''.obs;

  void clear() {
    userId.value = '';
  }
}
