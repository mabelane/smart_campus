import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../models/notifications.dart';

class NotificationController extends GetxController {
  final baseUrl = 'https://smart-campus-9xjl.onrender.com/api/auth/bookings';
  var notifications = <NotificationModel>[].obs;

  Future<void> fetchNotifications(String token) async {
    final url = Uri.parse('$baseUrl/getMyNotifications/me');
    final res = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      notifications.assignAll(
        data.map((e) => NotificationModel.fromJson(e)).toList(),
      );
    } else {
      throw Exception('Failed to fetch notifications');
    }
  }

  Future<void> sendNotification(
    String message,
    String audience,
    String token,
  ) async {
    final url = Uri.parse('$baseUrl/sendNotification');
    final res = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'message': message, 'audience': audience}),
    );

    if (res.statusCode != 201) {
      throw Exception('Failed to send notification');
    }
  }

  Future<void> markNotificationRead(String id, String token) async {
    final url = Uri.parse('$baseUrl/markNotificationRead/$id');
    final res = await http.put(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to mark notification as read');
    }
  }
}
