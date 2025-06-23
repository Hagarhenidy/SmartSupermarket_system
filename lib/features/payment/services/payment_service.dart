import '../../../core/api/api_client.dart';
import '../../../core/api/api_constant.dart';

class PaymentService {
  final ApiClient _apiClient = ApiClient();

  
  Future<dynamic> createPaymentIntent({
    required String authToken,
  }) async {
    final response = await _apiClient.post(
      ApiConstant.createPayment,
      {},
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );
    return response;
  }


  Future<dynamic> confirmPaymentOnBackend({
    required String authToken,
    required String paymentId, 
  }) async {
    final response = await _apiClient.post(
      ApiConstant.confirmPayment,
      {

        'paymentId': paymentId,
      },
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );
    return response;
  }


  Future<dynamic> getReceipt({
    required String authToken,
    required String paymentId, 
  }) async {
    final response = await _apiClient.get(
      ApiConstant.getAllMyReceipts,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );
    return response;
  }
}
