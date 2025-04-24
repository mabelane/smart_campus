import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService extends GetxService {
  final String baseUrl = "https://your-nodejs-api.com/api";

  Future<dynamic> getStudents() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/students'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load students');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getTeachers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/teachers'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load teachers');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getAdmins() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/admins'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load admins');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> createUser(String role, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$role'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create user');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> updateUser(
    String role,
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$role/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update user');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteUser(String role, String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$role/$id'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      rethrow;
    }
  }
}
