import 'package:get/get.dart';
import '../../models/timetable.dart';
import '../../services/api_service.dart';

class TimetableController extends GetxController {
  final ApiService api = Get.find<ApiService>();

  var timetableEntries = <TimetableModel>[].obs;
  var isLoading = false.obs;

  // Fetch student's timetable
  Future<void> fetchStudentTimetable(String studentId) async {
    isLoading.value = true;
    try {
      final res = await api.getStudentTimetable(studentId);
      if (res.isOk && res.body != null) {
        final List<dynamic> data = res.body;
        timetableEntries.assignAll(
          data.map((e) => TimetableModel.fromJson(e)).toList(),
        );
      } else {
        timetableEntries.clear();
      }
    } catch (e) {
      timetableEntries.clear();
    }
    isLoading.value = false;
  }

  // Create a new timetable entry
  Future<void> createTimetableEntry(Map<String, dynamic> entry) async {
    isLoading.value = true;
    try {
      final res = await api.createTimetableEntry(entry);
      if (res.isOk && res.body != null) {
        final timetableData = res.body['timetable'];
        timetableEntries.add(TimetableModel.fromJson(timetableData));
      }
    } catch (e) {}
    isLoading.value = false;
  }
}
