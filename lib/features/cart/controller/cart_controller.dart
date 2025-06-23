import 'package:get/get.dart';
import 'package:smart_supermarket/features/cart/model/cart_model.dart';
import 'package:smart_supermarket/features/cart/services/cart_service.dart';
import 'package:smart_supermarket/features/home/model/product_model.dart';


class CartController extends GetxController {
  final CartService _cartService = CartService();

  var cart = Rx<CartModel?>(null);
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var recommendedProducts = <Product>[].obs;
  var isRecommendationsLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    fetchCart();
    fetchRecommendations();
  }

  Future<void> fetchCart() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final cartData = await _cartService.getCart();
      cart.value = cartData;
    } catch (e) {
      errorMessage.value = 'Failed to load cart';
      cart.value = CartModel(id: '', items: [], totalPrice: 0.0);
      print('Error fetching cart: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addToCart(String scannedString) async {
    try {
      await _cartService.addToCart(scannedString: scannedString);
      await fetchCart();
      await fetchRecommendations();
      return true;
    } catch (e) {
      print('Error adding to cart: $e');
      return false;
    }
  }

  Future<bool> removeFromCart(String productId) async {
    try {
      await _cartService.removeFromCart(productId: productId);
      await fetchCart();
      await fetchRecommendations();
      return true;
    } catch (e) {
      print('Error removing from cart: $e');
      return false;
    }
  }

  void clearCart() async {
    try {
      await _cartService.clearCart();
      await fetchCart();
      await fetchRecommendations();
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }
  Future<void> decreaseQuantity(String productId) async {
    try {
      await _cartService.decreaseQuantity(productId: productId);
      await fetchCart();
      await fetchRecommendations();
    } catch (e) {
      print('Error decreasing quantity: $e');
    }
  }


  Future<void> fetchRecommendations() async {
    try {
      isRecommendationsLoading.value = true;
      recommendedProducts.value = await _cartService.getCartRecommendations();
    } catch (e) {
      print('Error fetching recommendations: $e');
      recommendedProducts.clear(); // Clear on error
    } finally {
      isRecommendationsLoading.value = false;
    }
  }
  Future<List<Product>> getCartRecommendations() {
    return _cartService.getCartRecommendations();
  }
}