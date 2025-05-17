import '../constant/strings.dart';

class Validator {
  // Validates if the first name is not empty
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }

  static String? validateName(String? value) {
    return (value == null || value.trim().isEmpty) ? 'Name is required' : null;
  }

  static String? validatePhone(String? value) {
    return (value == null || value.trim().length < 10)
        ? 'Valid phone number required'
        : null;
  }

  static String? validateRequiredField(String? value) {
    return (value == null || value.trim().isEmpty)
        ? 'This field is required'
        : null;
  }

  // Validates if the email is in a proper format
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // Validates if the password meets the minimum requirements
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigit = password.contains(RegExp(r'\d'));
    final hasSpecialCharacter = password.contains(
      RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
    );

    if (!hasUppercase) {
      return ATexts.hasUppercase;
    }
    if (!hasLowercase) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!hasDigit) {
      return 'Password must contain at least one number';
    }
    if (!hasSpecialCharacter) {
      return 'Password must contain at least one special character';
    }
    return null;
  }
}
