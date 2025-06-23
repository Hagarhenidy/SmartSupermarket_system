import '../../../core/api/api_client.dart';
import '../../../core/api/api_constant.dart';

class ProfileService {
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> updateUserProfile({
    required String token,
    required String name,
    required String email,
    required String phone,
  }) async {
    return _apiClient.put(
      ApiConstant.updateProfile,
      {'name': name, 'email': email, 'phone': phone},
      token: token,
    );
  }

  Future<dynamic> getAllReceipts({required String token}) async {
    return _apiClient.get(ApiConstant.getAllMyReceipts, token: token);
  }


// Future<dynamic> getReceiptDetails({required String token, required String paymentId}) async {
  //   return _apiClient.get('${ApiConstant.getReceiptBase}/$paymentId', token: token);
  // }
}