import 'package:get/get.dart';
import '../../models/booking.dart';
import '../../models/notifications.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';
import '../controllers/course_controller.dart';
import '../controllers/login_controller.dart';
import '../storage/token_storage.dart';

class AdminController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final CourseController courseController = Get.find<CourseController>();

  var isLoading = false.obs;
  var users = <User>[].obs;
  var bookings = <BookingModel>[].obs;
  var notifications = <NotificationModel>[].obs;
  var recentActivities = <Map<String, dynamic>>[].obs;

  var userCount = 0.obs;
  var courseCount = 0.obs;
  var bookingCount = 0.obs;
  var issueCount = 0.obs;
  var studentCount = 0.obs;
  var lecturerCount = 0.obs;
  var adminCount = 0.obs;
  var resolvedIssues = 0.obs;

  var activeScreen = 'dashboard'.obs;

  @override
  void onInit() {
    super.onInit();
    courseController.fetchCourses();
    loadDashboardData();
    ever(courseController.courses, (_) {
      courseCount.value = courseController.courses.length;
    });
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        fetchUsers(),
        fetchNotifications(),
        fetchIssues(),
        fetchSummary(),
      ]);
      generateRecentActivities();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUsers() async {
    try {
      final token = await TokenStorage.getToken();
      final response = await apiService.httpClient.get(
        '/getAllUsers',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 && response.body != null) {
        final List<dynamic> data = response.body;
        users.assignAll(data.map((user) => User.fromJson(user)).toList());
        userCount.value = users.length;
      }
    } catch (e) {
      'Error fetching users: $e';
    }
  }

  Future<void> fetchNotifications() async {
    try {
      final token = await TokenStorage.getToken();
      final response = await apiService.httpClient.get(
        '/bookings/getAllNotifications',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 && response.body != null) {
        final List<dynamic> data = response.body;
        notifications.assignAll(
          data.map((n) => NotificationModel.fromJson(n)).toList(),
        );
      }
    } catch (e) {
      'Error fetching notifications: $e';
    }
  }

  Future<void> fetchIssues() async {
    try {
      final token = await TokenStorage.getToken();
      final response = await apiService.httpClient.get(
        '/bookings/getAllIssues',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 && response.body != null) {
        final List<dynamic> data = response.body;
        issueCount.value = data.length;
      }
    } catch (e) {
      'Error fetching issues: $e';
    }
  }

  Future<void> fetchSummary() async {
    try {
      final token = await TokenStorage.getToken();
      final response = await apiService.httpClient.get(
        '/admin/summary', // assuming correct route
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 && response.body != null) {
        final summary = response.body;

        // Parse user breakdown
        final usersMap = summary['users'] ?? {};
        userCount.value = usersMap['total'] ?? 0;

        studentCount.value = usersMap['students'] ?? 0;
        lecturerCount.value = usersMap['lecturers'] ?? 0;
        adminCount.value = usersMap['admins'] ?? 0;

        // Assign other counts
        bookingCount.value = summary['bookings'] ?? 0;
        courseCount.value = summary['courses'] ?? 0;

        final maintenanceMap = summary['maintenance'] ?? {};
        issueCount.value = maintenanceMap['total'] ?? 0;
        resolvedIssues.value = maintenanceMap['resolved'] ?? 0;
        // Assign recent bookings and issues
        final recent = summary['recentActivity'] ?? {};
        final recentBookings = (recent['bookings'] ?? []) as List;
        final recentIssues = (recent['issues'] ?? []) as List;

        bookings.assignAll(
          recentBookings.map((e) => BookingModel.fromJson(e)).toList(),
        );

        notifications.assignAll(
          recentIssues
              .map(
                (e) => NotificationModel(
                  message: e['description'] ?? 'Issue reported',
                  createdAt:
                      DateTime.tryParse(e['createdAt'] ?? '') ?? DateTime.now(),
                ),
              )
              .toList(),
        );
      }
    } catch (e) {
      'Error fetching summary: $e';
    }
  }

  void generateRecentActivities() {
    List<Map<String, dynamic>> activities = [];

    for (var booking in bookings) {
      activities.add({
        'type': 'booking',
        'title': 'New Booking',
        'description': 'Room: ${booking.room}, Status: ${booking.status}',
        'time': _formatDateTime(booking.startTime),
        'timestamp': booking.startTime,
      });
    }

    for (var notification in notifications) {
      activities.add({
        'type': 'issue',
        'title': 'New Issue',
        'description': notification.message,
        'time': _formatDateTime(notification.createdAt),
        'timestamp': notification.createdAt,
      });
    }

    activities.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
    recentActivities.assignAll(activities);
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} mins ago';
      }
      return '${difference.inHours} hrs ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  void setActiveScreen(String screen) {
    activeScreen.value = screen;
  }

  Future<void> logout() async {
    final loginController = Get.find<LoginController>();
    await loginController.logout();
  }
}
