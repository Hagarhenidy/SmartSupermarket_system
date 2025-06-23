// import '../model/category_model.dart';
// import '../model/product_model.dart';
// import '../services/home_service.dart';
//
// class HomeController {
//   final HomeService _homeService = HomeService();
//
//   Future<List<Category>> getCategories() => _homeService.fetchCategories();
//
//   Future<List<Product>> getProducts(String category,
//       {int page = 1, int limit = 10, double? minPrice, double? maxPrice, String? sort}) {
//     return _homeService.fetchProducts(
//       category: category,
//       page: page,
//       limit: limit,
//       minPrice: minPrice,
//       maxPrice: maxPrice,
//       sort: sort,
//     );
//   }
//
//   Future<List<Product>> searchProducts(String query) {
//     return _homeService.searchProducts(query: query);
//   }
//
//   Future<Product?> getProductByQRCode(String qrCode) async {
//     try {
//       return await _homeService.fetchProductByQRCode(qrCode);
//     } catch (e) {
//       print('Failed to find product with QR code $qrCode: $e');
//       return null;
//     }
//   }
// }
import '../model/category_model.dart';
import '../model/product_model.dart';
import '../services/home_service.dart';

class HomeController {
  final HomeService _homeService = HomeService();

  Future<List<Category>> getCategories() => _homeService.fetchCategories();


  Future<List<Product>> getProducts(String category, {int page = 1, int limit = 75}) {
    return _homeService.fetchProducts(
      category: category,
      page: page,
      limit: limit,
    );
  }


  Future<List<Product>> searchProducts(String query) {
    return _homeService.searchProducts(query: query);
  }

  Future<Product?> getProductByQRCode(String qrCode) async {
    try {
      return await _homeService.fetchProductByQRCode(qrCode);
    } catch (e) {
      print('Failed to find product with QR code $qrCode: $e');
      return null;
    }
  }
}