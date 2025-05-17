import 'dart:convert';

class AuthService {
  static Map<String, dynamic> decodeJWT(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }
    final payload = base64Url.normalize(parts[1]);
    final decoded = utf8.decode(base64Url.decode(payload));
    return jsonDecode(decoded);
  }

  static String extractRole(String token) {
    final payload = decodeJWT(token);
    return payload['role'];
  }

  static String extractUserId(String token) {
    final payload = decodeJWT(token);
    return payload['userId'];
  }
}
