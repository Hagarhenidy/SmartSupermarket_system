import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  var userName = 'Loading...'.obs;
  var userEmail = 'Loading...'.obs;
  var userPhone = ''.obs;



  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
  }

  Future<bool> signup(String name, String email, String phone, String password) async {
    try {
      final result = await _authService.signup(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      
      if (result != null && result['message'] == "User created successfully") {
        return true;
      }
      
      if (result != null && result['message'] == "this user already exist") {
        throw Exception('this user already exist');
      }
      return false;
    } catch (e) {
      print("Signup Error in Controller: $e");
      throw e;
    }
  }



  Future<bool> login(String email, String password) async {
    try {
      await _ensureInitialized(); 
      final result = await _authService.login(email: email, password: password);

      if (result != null && result['token'] != null) {
        final token = result['token'] ?? '';
        final name = result['user']?['name'] ?? '';
        final emailRes = result['user']?['email'] ?? '';
        final phoneRes = result['user']?['phone'] ?? '';

        await _prefs.setString('token', token);
        await _prefs.setString('name', name);
        await _prefs.setString('email', emailRes);
        await _prefs.setString('phone', phoneRes);

        await loadUserFromPrefs();
        return true;
      }
      return false;
    } catch (e) {
      print("Login Error: $e");
      return false;
    }
  }

  Future<String> getUserName() async {
    await _ensureInitialized();
    return _prefs.getString('name') ?? 'Guest';
  }

  Future<String> getUserEmail() async {
    await _ensureInitialized();
    return _prefs.getString('email') ?? 'no-email@example.com';
  }

  Future<void> logout() async {
    await _ensureInitialized();
    await _prefs.clear();
    userName.value = '';
    userEmail.value = '';
    userPhone.value = '';
  }

  Future<String?> getToken() async {
    await _ensureInitialized();
    return _prefs.getString('token');
  }

  Future<bool> forgetPassword(String email) async {
    try {
      await _authService.forgetPassword(email);
      return true;
    } catch (e) {
      print("Forget Password Error: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> resetPassword(String email, String code, String newPassword) async {
    try {
      final result = await _authService.resetPassword(
        email: email,
        code: code,
        newPassword: newPassword,
      );
      return {'success': true, 'message': result['message'] ?? 'Password reset successfully'};
    } catch (e) {
      var errorMessage = "An unknown error occurred.";
      if (e.toString().contains("→")) {
        final body = e.toString().split('→')[1].trim();
        try {
          final decodedBody = jsonDecode(body);
          errorMessage = decodedBody['message'] ?? "Failed to reset password.";
        } catch (_) {
          errorMessage = "Failed to parse error response.";
        }
      }
      return {'success': false, 'message': errorMessage};
    }
  }
  Future<void> updateLocalUser({String? name, String? email,String? phone}) async {
    await _ensureInitialized();
    if (name != null) {
      await _prefs.setString('name', name);
      userName.value = name;
    }
    if (email != null) {
      await _prefs.setString('email', email);
      userEmail.value = email;
    }
    if (phone != null) {
      await _prefs.setString('phone', phone);
      userPhone.value = phone;
    }
  }
  Future<void> loadUserFromPrefs() async {
      await _ensureInitialized();
      userName.value = _prefs.getString('name') ?? 'Guest';
      userEmail.value = _prefs.getString('email') ?? 'no-email@example.com';
      userPhone.value = _prefs.getString('phone') ?? '';
  }

}