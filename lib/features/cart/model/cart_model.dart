import 'package:smart_supermarket/features/home/model/product_model.dart';

class CartItem {
  final Product product;
  final int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['productId']),
      quantity: json['quantity'] ?? 0,
    );
  }
}

class CartModel {
  final String id;
  final List<CartItem> items;
  final double totalPrice;

  CartModel({
    required this.id,
    required this.items,
    required this.totalPrice,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final cartData = json['cart'] ?? {};
    final itemsList = cartData['items'] as List<dynamic>? ?? [];

    return CartModel(
      id: cartData['_id'] ?? '',
      items: itemsList.map((item) => CartItem.fromJson(item)).toList(),
      totalPrice: (json['grandTotal'] ?? json['totalPrice'] ?? 0).toDouble(),
    );
  }
}
