import 'package:get/get.dart';

class LoginController extends GetxController {
  var obscurePassword = true.obs;

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+com$');

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 8) {
      return "At least 8 characters required";
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Add one uppercase letter";
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Add one lowercase letter";
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Add one number";
    }
    if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
      return "Add one special character";
    }
    return null;
  }
}
