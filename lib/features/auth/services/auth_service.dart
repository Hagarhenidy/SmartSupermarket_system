import '../../../core/api/api_client.dart';
import '../../../core/api/api_constant.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstant.register,
      {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      },
    );
    return response;
  }

  Future<dynamic> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstant.login,
      {
        'email': email,
        'password': password,
      },
    );
    return response;
  }
  Future<dynamic> forgetPassword(String email) async {
    return await _apiClient.post(ApiConstant.forgetPassword, {
      'email': email,
    });
  }

  Future<dynamic> resetPassword({ required String email, required String code, required String newPassword }) async {
    return await _apiClient.post(ApiConstant.resetPassword, {
      'email': email,
      'code': code,
      'newPassword': newPassword,
    });
  }
}
