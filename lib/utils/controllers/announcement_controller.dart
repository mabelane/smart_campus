import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../models/announcement.dart';

class AnnouncementController extends GetxController {
  final baseUrl = 'https://smart-campus-9xjl.onrender.com/api/announcements';
  var announcements = <AnnouncementModel>[].obs;

  // Fetch all announcements
  Future<void> fetchAnnouncements(String token) async {
    final url = Uri.parse(baseUrl);
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['announcements'] as List;
        announcements.assignAll(
          data.map((e) => AnnouncementModel.fromJson(e)).toList(),
        );
      } else {
        throw Exception('Failed to fetch announcements: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Create a new announcement
  Future<void> createAnnouncement(
    AnnouncementModel announcement,
    String token,
  ) async {
    final url = Uri.parse(baseUrl);
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "title": announcement.title,
          "message": announcement.message,
          "target_role": announcement.targetRole,
        }),
      );

      if (response.statusCode == 201) {
        await fetchAnnouncements(token);
        Get.snackbar('Success', 'Announcement created');
      } else {
        throw Exception('Failed to create announcement: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Delete an announcement (admin only)
  Future<void> deleteAnnouncement(String id, String token) async {
    final url = Uri.parse('$baseUrl/$id');
    try {
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        announcements.removeWhere((a) => a.id == id);
        Get.snackbar('Success', 'Announcement deleted');
      } else {
        throw Exception('Failed to delete announcement: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Get announcement by ID (optional if needed)
  Future<AnnouncementModel?> getAnnouncementById(
    String id,
    String token,
  ) async {
    final url = Uri.parse('$baseUrl/$id');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['announcement'];
        return AnnouncementModel.fromJson(data);
      } else {
        Get.snackbar('Error', 'Failed to load announcement');
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return null;
    }
  }
}
