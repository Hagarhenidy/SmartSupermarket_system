class ApiConstant {
  static const String baseUrl = 'https://super-market-five.vercel.app/api';
  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String forgetPassword = '$baseUrl/auth/forgetPassword';
  static const String resetPassword = '$baseUrl/auth/resetPassword';
  static const String userProfileEndpoint = '$baseUrl/users/MyProfile';
  //products endpoints
  static const String categoriesEndpoint = '$baseUrl/category/all';
  static const String productsEndpoint = '$baseUrl/products';
  static const String searchProductsEndpoint = '$baseUrl/products/search';
  //cart endpoints
  static const String getCartEndpoint = '$baseUrl/carts/MyCart';
  static const String addToCartEndpoint = '$baseUrl/carts/add';
  static const String decreaseQuantityEndpoint = '$baseUrl/carts/decrease';
  static const String deleteFromCartEndpoint = '$baseUrl/carts/delete';
  static const String clearCartEndpoint = '$baseUrl/carts/clear';

  static const String cartRecommendationsEndpoint = '$baseUrl/recommendations/cart/recommendations';
//payment
  static const String createPayment = 'https://super-market-fawn.vercel.app/api/payment/create-payment';
  static const String confirmPayment = 'https://super-market-fawn.vercel.app/api/payment/confirm-payment';

  static const String getAllMyReceipts = '$baseUrl/receipts/myreceipts';
  static const String updateProfile = '$baseUrl/users/UpdateProfile';
}
