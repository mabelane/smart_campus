import 'package:get/get.dart';

import '../../services/api_service.dart';
import '../../utils/controllers/admin_controller.dart';
import '../../utils/controllers/booking_controller.dart';
import '../../utils/controllers/course_controller.dart';
import '../../utils/controllers/lecture_controller.dart';
import '../../utils/controllers/login_controller.dart';
import '../../utils/controllers/signup_controller.dart';
import '../../utils/controllers/student_controller.dart';
import '../../utils/controllers/timetable_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService(), fenix: true);
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<RegisterController>(() => RegisterController(), fenix: true);
    Get.lazyPut<BookingController>(() => BookingController(), fenix: true);
    Get.lazyPut<TimetableController>(() => TimetableController(), fenix: true);
    Get.lazyPut<StudentController>(() => StudentController(), fenix: true);
    Get.lazyPut<LecturerController>(() => LecturerController(), fenix: true);
    Get.lazyPut<AdminController>(() => AdminController(), fenix: true);
    Get.lazyPut<CourseController>(
      () => CourseController(),
      fenix: true,
    ); // ✅ Added this
  }
}
