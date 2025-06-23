import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_supermarket/core/api/api_client.dart'; // Corrected Path
import 'package:smart_supermarket/core/api/api_constant.dart'; // Corrected Path
import 'package:smart_supermarket/features/cart/model/cart_model.dart';
import 'package:smart_supermarket/features/home/model/product_model.dart';

class CartService {
  final ApiClient _apiClient = ApiClient();

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> addToCart({required String scannedString}) async {
    final token = await _getToken();
    if (token == null) throw Exception('Authorization token not found.');

    await _apiClient.post(
      ApiConstant.addToCartEndpoint,
      {'qrstring': scannedString},
      token: token,
    );
  }

  Future<CartModel> getCart() async {
    final token = await _getToken();
    if (token == null) {
      print("No token found, returning an empty cart.");
      return CartModel(id: '', items: [], totalPrice: 0.0);
    }

    try {
      final responseBody = await _apiClient.get(ApiConstant.getCartEndpoint, token: token);

      if (responseBody == null) { 
        return CartModel(id: '', items: [], totalPrice: 0.0);
      }
      return CartModel.fromJson(responseBody);
    } catch (e) {
      if (e.toString().contains("404")) {
        print("Cart not found on server, returning an empty cart locally.");
        return CartModel(id: '', items: [], totalPrice: 0.0);
      } else {
        print("Error fetching cart: $e");
        rethrow;
      }
    }
  }

  Future<List<Product>> getCartRecommendations() async {
    final token = await _getToken();
    if (token == null) throw Exception('Authorization token not found.');

    final responseBody = await _apiClient.post(
      ApiConstant.cartRecommendationsEndpoint,
      {},
      token: token,
    );

    final List<dynamic> jsonData = responseBody;
    return jsonData.map((e) => Product.fromJson(e)).toList();
  }

  Future<void> decreaseQuantity({required String productId}) async {
    final token = await _getToken();
    if (token == null) throw Exception('Authorization token not found.');

    await _apiClient.patch(
      ApiConstant.decreaseQuantityEndpoint,
      {'productId': productId},
      token: token,
    );
  }

  Future<void> removeFromCart({required String productId}) async {
    final token = await _getToken();
    if (token == null) throw Exception('Authorization token not found.');


    await _apiClient.delete(
      ApiConstant.deleteFromCartEndpoint,
      body: {'productId': productId},
      token: token,
    );
  }

  Future<void> clearCart() async {
    final token = await _getToken();
    if (token == null) throw Exception('Authorization token not found.');
    await _apiClient.delete(ApiConstant.clearCartEndpoint, token: token);
  }
}