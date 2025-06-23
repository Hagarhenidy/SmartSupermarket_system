import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/product_model.dart';
import '../model/category_model.dart';
import '../../../core/api/api_constant.dart';
import '../../../core/api/api_client.dart';

class HomeService {
  final ApiClient _apiClient = ApiClient();

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<Category>> fetchCategories() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Authorization token not found.');
      }
      final jsonData = await _apiClient.get(
        ApiConstant.categoriesEndpoint,
        token: token,
      );
      final List<dynamic> categoriesData =
      jsonData is List ? jsonData : jsonData['result'] ?? [];
      return categoriesData.map((e) => Category.fromJson(e)).toList();
    } catch (e) {
      print('Error in fetchCategories: $e');
      rethrow;
    }
  }

  Future<List<Product>> fetchProducts({
    required String category,
    int page = 1,
    int limit = 5,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Authorization token not found.');
      }

      final uri =
      Uri.parse(ApiConstant.productsEndpoint).replace(queryParameters: {
        'category': category,
        'page': '$page',
        'limit': '$limit',
      });

      print('Fetching products from: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final jsonData = jsonDecode(response.body);

        
          if (jsonData is Map<String, dynamic>) {
            final List<dynamic> productsData =
                jsonData['products'] ?? jsonData['result'] ?? [];
            return productsData.map((e) => Product.fromJson(e)).toList();
          } else {
            print("Warning: API returned valid JSON that was not in the expected format. Body: ${response.body}");
            return []; 
          }
        } catch (e) {
          
          print("Error: Failed to parse JSON from server. Body: ${response.body}");
          return []; 
        }
      } else {
      
        print("API Error: Server responded with status ${response.statusCode} and body ${response.body}");
        return [];
      }
    } catch (e) {
      print('Error in fetchProducts: $e');
      rethrow;
    }
  }

  Future<List<Product>> searchProducts({required String query}) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Authorization token not found.');
      }

      final uri = Uri.parse(ApiConstant.searchProductsEndpoint)
          .replace(queryParameters: {'q': query});

      final jsonData = await _apiClient.get(
        uri.toString(),
        token: token,
      );

      final List<dynamic> productsData =
      jsonData is List ? jsonData : jsonData['products'] ?? [];
      return productsData.map((e) => Product.fromJson(e)).toList();
    } catch (e) {
      print('Error in searchProducts: $e');
      rethrow;
    }
  }

  Future<Product> fetchProductByQRCode(String qrCode) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Authorization token not found.');
    }

    final String url = '${ApiConstant.baseUrl}/products/by-qrcode/$qrCode';
    final jsonData = await _apiClient.get(url, token: token);
    return Product.fromJson(jsonData);
  }
}