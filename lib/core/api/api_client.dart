import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
  };

  Future<dynamic> post(String url, Map<String, dynamic> body, {Map<String, String>? headers, String? token}) async {
    final mergedHeaders = {..._defaultHeaders, if (headers != null) ...headers};

    if (token != null) {
      mergedHeaders['Authorization'] = 'Bearer $token';
    }

    final response = await http.post(
      Uri.parse(url),
      headers: mergedHeaders,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> get(String url, {Map<String, String>? headers, String? token}) async {
    final mergedHeaders = {..._defaultHeaders, if (headers != null) ...headers};

    if (token != null) {
      mergedHeaders['Authorization'] = 'Bearer $token';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: mergedHeaders,
    );
    return _handleResponse(response);
  }

  Future<dynamic> put(String url, Map<String, dynamic> body, {Map<String, String>? headers, String? token}) async {
    final mergedHeaders = {..._defaultHeaders, if (headers != null) ...headers};

    if (token != null) {
      mergedHeaders['Authorization'] = 'Bearer $token';
    }

    final response = await http.put(
      Uri.parse(url),
      headers: mergedHeaders,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(String url, {Map<String, dynamic>? body, Map<String, String>? headers, String? token}) async {
    final mergedHeaders = {..._defaultHeaders, if (headers != null) ...headers};
    if (token != null) {
      mergedHeaders['Authorization'] = 'Bearer $token';
    }

    final response = await http.delete(
      Uri.parse(url),
      headers: mergedHeaders,
      body: body != null ? jsonEncode(body) : null, 
    );
    return _handleResponse(response);
  }
  Future<dynamic> patch(String url, Map<String, dynamic> body, {Map<String, String>? headers, String? token}) async {
    final mergedHeaders = {..._defaultHeaders, if (headers != null) ...headers};
    if (token != null) {
      mergedHeaders['Authorization'] = 'Bearer $token';
    }

    final response = await http.patch(
      Uri.parse(url),
      headers: mergedHeaders,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode} → ${response.body}');
    }
  }
}