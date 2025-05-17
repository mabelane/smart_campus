import 'package:get/get.dart';
import '../../models/issues.dart';
import '../../services/api_service.dart';

class IssueController extends GetxController {
  final ApiService api = Get.find<ApiService>();

  var issues = <IssueModel>[].obs;
  var isLoading = false.obs;

  // Fetch all issues
  Future<void> fetchIssues() async {
    isLoading.value = true;
    try {
      final res = await api.getAllIssues();
      if (res.isOk && res.body != null) {
        final List<dynamic> data = res.body;
        issues.assignAll(data.map((e) => IssueModel.fromJson(e)).toList());
      } else {
        issues.clear();
      }
    } catch (e) {
      "Error fetching issues: $e";
      issues.clear();
    }
    isLoading.value = false;
  }

  // Report a new issue
  Future<void> reportIssue(Map<String, dynamic> issueData) async {
    isLoading.value = true;
    try {
      final res = await api.reportIssue(issueData);
      if (res.isOk && res.body != null) {
        final newIssue = IssueModel.fromJson(res.body['issue']);
        issues.add(newIssue);
      }
    } catch (e) {
      print("Error reporting issue: $e");
    }
    isLoading.value = false;
  }

  // Update an issue's status
  Future<void> updateIssueStatus(String id, String newStatus) async {
    isLoading.value = true;
    try {
      final res = await api.updateIssueStatus(id, {'status': newStatus});
      if (res.isOk && res.body != null) {
        final updatedIssue = IssueModel.fromJson(res.body['issue']);
        // replace the issue in the list
        final index = issues.indexWhere((i) => i.id == id);
        if (index != -1) {
          issues[index] = updatedIssue;
        }
      }
    } catch (e) {
      "Error updating issue status: $e";
    }
    isLoading.value = false;
  }
}
