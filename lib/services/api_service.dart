import 'package:get/get_connect/connect.dart';

class ApiService extends GetConnect {
  static const String apiBaseUrl =
      'https://smart-campus-9xjl.onrender.com/api/auth';

  @override
  void onInit() {
    httpClient.baseUrl = apiBaseUrl;
    httpClient.defaultContentType = 'application/json';
    super.onInit();
  }

  // AUTH
  Future<Response> registerUser(Map<String, dynamic> userData) =>
      post('/register', userData);
  Future<Response> loginUser(String email, String password) =>
      post('/login', {"email": email, "password": password});
  Future<Response> updateUser(String id, Map<String, dynamic> data) =>
      put('/updateUser/$id', data);
  Future<Response> deleteUser(String id) => delete('/deleteUser/$id');

  // BOOKINGS
  Future<Response> createBooking(Map<String, dynamic> data) =>
      post('/bookings/createBooking', data);
  Future<Response> getBooking(String id) => get('/bookings/getBooking/$id');
  Future<Response> updateBooking(String id, Map<String, dynamic> data) =>
      put('/bookings/updateBooking/$id', data);
  Future<Response> deleteBooking(String id) =>
      delete('/bookings/deleteBooking/$id');

  // COURSES
  Future<Response> getCourses() => get('/courses/getAllCourses');
  Future<Response> createCourse(Map<String, dynamic> data) =>
      post('/courses/createCourse', data);
  Future<Response> updateCourse(String id, Map<String, dynamic> data) =>
      put('/courses/updateCourse/$id', data);
  Future<Response> deleteCourse(String id) =>
      delete('/courses/deleteCourse/$id');

  // ENROLLMENT
  Future<Response> enrollStudent(Map<String, dynamic> data) =>
      post('/enrollment/enrollStudent', data);
  Future<Response> getStudentEnrollments(String userId) =>
      get('/enrollment/getStudentEnrollments/$userId');
  Future<Response> getCourseEnrollments(String courseId) =>
      get('/enrollments/getCourseEnrollments/$courseId');

  // ISSUES
  Future<Response> reportIssue(Map<String, dynamic> data) =>
      post('/issues/reportIssue', data);
  Future<Response> getAllIssues() => get('/bookings/getAllIssues');
  Future<Response> updateIssueStatus(String id, Map<String, dynamic> data) =>
      put('/issues/updateIssueStatus/$id', data);

  // NOTIFICATIONS
  Future<Response> sendNotification(Map<String, dynamic> data) =>
      post('/announcements/sendNotification', data);
  Future<Response> getMyNotifications() =>
      get('/announcements/getMyNotifications/me');
  Future<Response> markNotificationRead(String id) =>
      put('/announcements/markNotificationRead/$id', {});

  // TIMETABLE
  Future<Response> getStudentTimetable(String studentId) =>
      get('/timetable/getStudentTimetable/$studentId');
  Future<Response> createTimetableEntry(Map<String, dynamic> data) =>
      post('/timetable/createTimetableEntry', data);

  // SUMMARY
  Future<Response> getSummary() => get('/bookings/summary');
}
